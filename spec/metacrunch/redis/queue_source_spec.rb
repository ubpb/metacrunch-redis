describe Metacrunch::Redis::QueueSource do

  redis = Redis.new(url: "redis://localhost:6379/metacrunch-redis-rspec")

  before(:each) {
    # Delete users list for a clean start
    redis.del("users")

    # Add 100 dummy users
    100.times.each do |i|
      redis.rpush("users", {
        id: i,
        name: Faker::Name.name,
        email: Faker::Internet.email
      })
    end
  }

  context "when _not_ in blocking mode" do
    let(:source) {
      described_class.new(redis, "users", blocking_mode: false)
    }

    it "reads all the test data and exists" do
      results = []

      source.each do |data|
        results << data
      end

      expect(results.count).to eq(100)
    end
  end

  context "when in blocking mode" do
    let(:source) {
      described_class.new(redis, "users", blocking_mode: true)
    }

    it "reads all the test data and waits" do
      results = []

      expect {
        Timeout::timeout(2) do
          source.each do |data|
            results << data
          end
        end
      }.to raise_error(Timeout::Error)
    end
  end

end

