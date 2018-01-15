require "../../spec_helper"
require "../../../src/prometheus/client/histogram"

def with_histogram
  yield Prometheus::Client::Histogram.new(:test, "some docstring", {:label => "value"}, [2.5, 5.0, 10.0])
end

def with_histogram_and_values
  with_histogram do |histogram|
    histogram.observe({ :foo => "bar" }, 3.0)
    histogram.observe({ :foo => "bar" }, 5.2)
    histogram.observe({ :foo => "bar" }, 13.0)
    histogram.observe({ :foo => "bar" }, 4.0)

    yield histogram
  end
end

describe Prometheus::Client::Histogram do
  describe ".new" do
    it "raises an error for empty buckets" do
      expect_raises(ArgumentError) do
        Prometheus::Client::Histogram.new(:test, "foo", { :foo => "bar" }, [] of Float64)
      end
    end

    it "raises an error for unsorted buckets" do
      expect_raises(ArgumentError) do
        Prometheus::Client::Histogram.new(:test, "foo", { :foo => "bar" }, [5.0, 2.5, 10.0])
      end
    end

    it "raises an error for duplicated buckets" do
      expect_raises(ArgumentError) do
        Prometheus::Client::Histogram.new(:test, "foo", { :foo => "bar" }, [1.0, 1.0])
      end
    end
  end

  describe "#observe" do
    it "records the given value" do
      with_histogram do |histogram|
        histogram.observe({ :foo => "bar" }, 5.0).should be_a(Prometheus::Client::Histogram::Value)
      end
    end
  end

  describe "#get" do
    it "returns a set of buckets values" do
      with_histogram_and_values do |histogram|
        histogram.get({ :foo => "bar" }).should eq({ 2.5 => 0.0, 5 => 2.0, 10 => 3.0 })
      end
    end

    it "returns a value which responds to #sum and #total" do
      with_histogram_and_values do |histogram|
        value = histogram.get({ :foo => "bar" })

        value.sum.should eq(25.2)
        value.total.should eq(4.0)
      end
    end

    it "uses zero as default value" do
      with_histogram_and_values do |histogram|
        histogram.get({} of Symbol => String).should eq({ 2.5 => 0.0, 5 => 0.0, 10 => 0.0 })
      end
    end
  end
end
