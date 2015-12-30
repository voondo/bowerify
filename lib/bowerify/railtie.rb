module Bowerify
  class Railtie < Rails::Railtie
    railtie_name :bowerify

    config.before_initialize do |app|
      app.config.bower_components_path = [
        Rails.root.join('vendor', 'assets', 'bower_components')
      ]
    end

    config.assets.configure do |env|
      env.register_postprocessor 'text/css', Bowerify::AssetsProcessor
      env.register_postprocessor 'application/javascript', Bowerify::AssetsProcessor
      env.register_postprocessor 'text/html', Bowerify::AssetsProcessor
    end

    config.after_initialize do |app|
      app.config.assets.paths += Array(app.config.bower_components_path)

      %w[png gif jpg jpeg ttf svg eot woff woff2].each do |ext|
        Array(app.config.bower_components_path).each do |bower_path|
          config.assets.precompile += Dir.glob("#{bower_path}/**/*.#{ext}")
        end
      end
    end
  end
end
