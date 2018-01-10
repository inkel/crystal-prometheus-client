require "../../spec_helper"
require "../../../src/prometheus/client/label_set_validator"

describe Prometheus::Client::LabelSetValidator do
  describe "#valid?" do
    it "returns true for a valid label set" do
      validator = Prometheus::Client::LabelSetValidator.new

      validator.valid?({:version => "alpha"}).should eq(true)
    end

    it "raises ReserverdLabelError if label key starts with __" do
      validator = Prometheus::Client::LabelSetValidator.new

      expect_raises(Prometheus::Client::LabelSetValidator::ReservedLabelError) do
        validator.valid?({:__version__ => "alpha"})
      end
    end

    it "raises ReserverdLabelError if label key is reserved" do
      validator = Prometheus::Client::LabelSetValidator.new

      [:job, :instance].each do |key|
        expect_raises(Prometheus::Client::LabelSetValidator::ReservedLabelError) do
          validator.valid?({key => "alpha"})
        end
      end
    end
  end

  describe "#validate" do
    it "returns a given valid label set" do
      validator = Prometheus::Client::LabelSetValidator.new

      labels = {:foo => "bar"}

      validator.validate(labels).should eq(labels)
    end

    it "raises InvalidLabelSetError for varying label sets" do
      validator = Prometheus::Client::LabelSetValidator.new

      validator.validate({:method => "get", :code => "200"})

      expect_raises(Prometheus::Client::LabelSetValidator::InvalidLabelSetError) do
        validator.validate({:method => "get", :exception => "NoMethodError"})
      end
    end
  end
end
