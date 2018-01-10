require "../../spec_helper"
require "../../../src/prometheus/client/counter"

def with_counter
  yield Prometheus::Client::Counter.new(:test, "some docstring", {:label => "value"})
end

describe Prometheus::Client::Counter do
  describe ".new" do
    it "defaults value to 0.0" do
      with_counter do |counter|
        counter.get.should eq(0.0)
      end
    end
  end

  describe "#increment" do
    it "increments the counter" do
      with_counter do |counter|
        counter.increment
        counter.get.should eq(1.0)
      end
    end

    it "increments the counter by a given value" do
      with_counter do |counter|
        counter.increment({} of Symbol => String, 5.0)
        counter.get.should eq(5.0)
      end
    end

    it "raises ArgumentError on negative increments" do
      with_counter do |counter|
        expect_raises(ArgumentError) do
          counter.increment({} of Symbol => String, -1.0)
        end
      end
    end

    it "returns the new counter value" do
      with_counter do |counter|
        counter.increment.should eq(1.0)
      end
    end
  end
end
