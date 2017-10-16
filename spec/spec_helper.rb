require "pry" if !ENV["CI"]

require "simplecov"
SimpleCov.start do
  add_filter %r{^/spec/}
end

require "faker"
require "metacrunch/redis"

RSpec.configure do |config|
end
