require "metacrunch/redis"

module Metacrunch
  class Redis::QueueSource

    DEFAULT_OPTIONS = {
      blocking_mode: false
    }

    def initialize(redis, queue_name, options = {})
      @redis = redis
      @queue_name = queue_name
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def each(&block)
      return enum_for(__method__) unless block_given?

      if @options[:blocking_mode]
        while true
          list, result = @redis.blpop(@queue_name, timeout: 0)
          if result.present?
            yield result
          else
            yield nil
          end
        end
      else
        while result = @redis.lpop(@queue_name)
          yield result
        end
      end

      self
    end

  end
end
