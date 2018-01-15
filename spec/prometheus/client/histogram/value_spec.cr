require "../../../spec_helper"
require "../../../../src/prometheus/client/histogram"

def with_value
  value = Prometheus::Client::Histogram::Value.new([2.5, 5.0, 10.0])
  value.observe(3.0)
  value.observe(5.2)
  value.observe(13.0)
  value.observe(4.0)

  yield value
end

describe Prometheus::Client::Histogram::Value do
  describe ".validate_buckets" do
    it "raises an error for empty buckets" do
      expect_raises(ArgumentError) do
        Prometheus::Client::Histogram::Value.validate_buckets([] of Float64)
      end
    end

    it "raises an error for unsorted buckets" do
      expect_raises(ArgumentError) do
        Prometheus::Client::Histogram::Value.validate_buckets([5.0, 2.5, 10.0])
      end
    end

    it "raises an error for duplicated buckets" do
      expect_raises(ArgumentError) do
        Prometheus::Client::Histogram::Value.validate_buckets([1.0, 1.0])
      end
    end
  end

  describe "#sum" do
    it "should sum all the values" do
      with_value do |value|
        value.sum.should eq(25.2)
      end
    end
  end

  describe "#total" do
    it "should return the total number of values" do
      with_value do |value|
        value.total.should eq(4)
      end
    end
  end

  it "should be a set of bucket values" do
    with_value do |value|
      value.should eq({ 2.5 => 0.0, 5 => 2.0, 10 => 3.0 })
    end
  end

  it "uses zero as default value" do
    value = Prometheus::Client::Histogram::Value.new([2.5, 5.0, 10.0])
    value.should eq({ 2.5 => 0.0, 5 => 0.0, 10 => 0.0 })
  end
end
