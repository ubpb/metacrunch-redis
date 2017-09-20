require "active_support"
require "active_support/core_ext"
require "redis"

module Metacrunch
  module Redis
    require_relative "redis/queue_source"
    require_relative "redis/queue_destination"
  end
end
