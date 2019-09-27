# Be sure to restart your server when you modify this file.
require 'action_dispatch/middleware/session/dalli_store'

# Rails.application.config.session_store :cookie_store, key: '_ruby-docker-app_session' # default
# if Rails.env.development?
  # Rails.application.config.session_store :dalli_store, :memcache_server => ['memcached'], :namespace => 'sessions', :key => '_foundation_session', :expire_after => 5.days
# elsif Rails.env.production?
  # Rails.application.config.session_store :dalli_store, :memcache_server => ['my-memcached.mfh9as.0001.use1.cache.amazonaws.com'], :namespace => 'sessions', :key => '_foundation_session', :expire_after => 5.days
# end

Rails.application.config.session_store :dalli_store, :memcache_server => [ENV["MEMCACHED_SERVER"]], :namespace => 'sessions', :key => '_foundation_session', :expire_after => 5.days
