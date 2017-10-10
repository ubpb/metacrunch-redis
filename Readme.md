metacrunch-redis
===============

[![Gem Version](https://badge.fury.io/rb/metacrunch-redis.svg)](http://badge.fury.io/rb/metacrunch-redis)
[![Code Climate](https://codeclimate.com/github/ubpb/metacrunch-redis/badges/gpa.svg)](https://codeclimate.com/github/ubpb/metacrunch-redis)
[![Build Status](https://travis-ci.org/ubpb/metacrunch-redis.svg)](https://travis-ci.org/ubpb/metacrunch-redis)

This is the official [Redis](https://redis.io) package for the [metacrunch ETL toolkit](https://github.com/ubpb/metacrunch).

Installation
------------

Include the gem in your `Gemfile`

```ruby
gem "metacrunch-redis", "~> 1.0.1"
```

and run `$ bundle install` to install it.

Or install it manually

```
$ gem install metacrunch-redis
```

Usage
-----

*Note: For working examples on how to use this package check out our [demo repository](https://github.com/ubpb/metacrunch-demo).*

### `Metacrunch::Redis::QueueSource`

This class provides a metacrunch `source` implementation that can be used to read data from a Redis queue/list into a metacrunch job.

```ruby
# my_job.metacrunch

# connect to redis
redis = Redis.new(url: "redis://localhost:6379/my-db")

# Set the source
source Metacrunch::Redis::QueueSource.new(redis, "my-list" [, OPTIONS])
```

**Options**

* `:blocking`: When set to `true` the source will block and waits for new data if the redis list is empty. Defaults to `false`.


### `Metacrunch::Redis::QueueDestination`

This class provides a metacrunch `destination` implementation that can be used to write data from a metacrunch job into a redis queue/list.

Redis only stores strings as values. If you want to store an object, you can use a serialization mechanism such as JSON. You can use a transformation to convert your data into JSON format before your data reaches the destination.

In case Redis reaches it's `maxmemory` limit during write, the implementation will wait for 10 seconds and tries to write the data again. That means you can set a proper `maxmemory` limit for your Redis instance and don't need to worry about your metacrunch jobs getting aborted.

```ruby
# my_job.metacrunch

# Prepare the data to be stored. 
transformation ->(data) do
  # Return json for the destination
  data.to_json
end

# Write data into redis queue
destination Metacrunch::Redis::QueueDestination.new(redis, "my-list" [, OPTIONS])
```

**Options**

* `:save_on_close`: When set to `true` a Redis `bgsave` will be performed when the destination is closed. Defaults to `false`. 
