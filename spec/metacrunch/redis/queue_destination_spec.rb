describe Metacrunch::Redis::QueueDestination do

  redis = Redis.new(url: "redis://localhost:6379/metacrunch-redis-rspec")

  before(:each) {
    # Delete users list for a clean start
    redis.del("users")
  }

  let(:destination) {
    described_class.new(redis, "users", save_on_close: true)
  }

  describe "#write" do
    it "writes data" do
      100.times do |i|
        destination.write(
          {
            id: i,
            name: Faker::Name.name,
            email: Faker::Internet.email
          }
        )
      end

      expect(redis.llen("users")).to eq(100)
    end

    context "when Redis reaches maxmemory" do
      let(:fake_redis) {
        Class.new do
          def initialize
            @maxmemory = true
            @data_written = false
          end

          attr_reader :data_written

          def rpush(queue_name, data)
            if @maxmemory == true
              @maxmemory = false
              raise RuntimeError.new("maxmemory")
            else
              @data_written = true
            end
          end
        end.new
      }

      let(:destination) {
        described_class.new(fake_redis, "users")
      }

      it "the write will be retried after 10 seconds" do
        destination.write(42)
        expect(fake_redis.data_written).to eq(true)
      end
    end

    context "when Redis raises an error" do
      let(:fake_redis) {
        Class.new do
          def rpush(queue_name, data)
            raise RuntimeError.new("oops")
          end
        end.new
      }

      let(:destination) {
        described_class.new(fake_redis, "users")
      }

      it "the error is re-raised" do
        expect {
          destination.write(42)
          }.to raise_error(RuntimeError, "oops")
      end
    end
  end

  describe "#close" do
    it "Closes the redis connection" do
      destination.close
      expect(redis.connected?).to eq(false)
    end
  end

end
