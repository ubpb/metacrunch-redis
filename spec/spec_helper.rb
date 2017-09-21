require "pry" if !ENV["CI"]
require "simplecov"
require "metacrunch/redis"

SimpleCov.start

RSpec.configure do |config|
end
