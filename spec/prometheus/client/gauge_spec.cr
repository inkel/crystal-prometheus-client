require "../../spec_helper"
require "../../../src/prometheus/client/gauge"

def with_gauge
  yield Prometheus::Client::Gauge.new(:test, "some docstring", {:label => "value"})
end

describe Prometheus::Client::Gauge do
  describe ".new" do
    it "defaults value to 0.0" do
      with_gauge do |gauge|
        gauge.get.should eq(0.0)
      end
    end
  end

  describe "#set" do
    it "sets a metric value" do
      with_gauge do |gauge|
        gauge.set({} of Symbol => String, 42.0)
        gauge.get.should eq(42.0)
      end
    end

    it "sets a metric value for a given label set" do
      with_gauge do |gauge|
        gauge.set({:test => "value"}, 5.0)
        gauge.get({:test => "value"}).should eq(5.0)
        gauge.get({:test => "foobar"}).should eq(0.0)
      end
    end
  end

  describe "#increment" do
    it "increments the gauge" do
      with_gauge do |gauge|
        gauge.increment
        gauge.get.should eq(1.0)
      end
    end

    it "increments the gauge by a given value" do
      with_gauge do |gauge|
        gauge.increment({} of Symbol => String, 5.0)
        gauge.get.should eq(5.0)
      end
    end

    it "returns the new gauge value" do
      with_gauge do |gauge|
        gauge.increment.should eq(1.0)
      end
    end
  end

  describe "#decrement" do
    it "decrements the gauge" do
      with_gauge do |gauge|
        gauge.decrement
        gauge.get.should eq(-1.0)
      end
    end

    it "decrements the gauge by a given value" do
      with_gauge do |gauge|
        gauge.decrement({} of Symbol => String, 5.0)
        gauge.get.should eq(-5.0)
      end
    end

    it "returns the new gauge value" do
      with_gauge do |gauge|
        gauge.decrement.should eq(-1.0)
      end
    end
  end
end
