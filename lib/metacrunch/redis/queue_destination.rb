require "metacrunch/redis"

module Metacrunch
  class Redis::QueueDestination

    DEFAULT_OPTIONS = {
      save_on_close: false
    }

    def initialize(redis, queue_name, options = {})
      @redis = redis
      @queue_name = queue_name
      @options = DEFAULT_OPTIONS.merge(options)
    end

    def write(data)
      return if data.blank?

      @redis.rpush(@queue_name, data)
    rescue RuntimeError => e
      if e.message =~ /maxmemory/
        puts "Redis has reached maxmemory. Waiting 10 seconds and trying again..."
        sleep(10)
        retry
      else
        raise e
      end
    end

    def close
      if @redis
        begin
          @redis.bgsave if @options[:save_on_close]
        rescue Redis::CommandError ; end
        @redis.quit
      end
    end

  end
end
