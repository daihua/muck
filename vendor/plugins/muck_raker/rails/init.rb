ActiveSupport::Dependencies.load_once_paths << lib_path

if config.respond_to?(:gems)
  config.gem "mbleigh-acts-as-taggable-on", :source => "http://gems.github.com", :lib => "acts-as-taggable-on"
else
  begin
    require 'acts-as-taggable-on'
  rescue LoadError
    begin
      gem 'mbleigh-acts-as-taggable-on'
    rescue Gem::LoadError
      puts "Please install the acts-as-taggable-on gem from http://gems.github.com"
    end
  end
end

I18n.load_path += Dir[ File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'locales', '*.{rb,yml}') ]

ENV['APP_AVAILABLE_LOCALES'] = "^en|es|fr|nl|ja|de|ru|zh"
ENV['APP_DEFAULT_LOCALE'] = 'en'

require 'muck_raker'
require 'muck_raker/initialize_routes'

config.to_prepare do
  ApplicationController.helper(MuckRakerHelper)
end