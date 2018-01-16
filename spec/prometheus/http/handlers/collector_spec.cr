require "spec"
require "http/server"
require "../../../../src/prometheus/http/handlers/collector"

describe Prometheus::HTTP::Handlers::Collector do
  describe ".new" do
    it "should use the default registry" do
      handler = Prometheus::HTTP::Handlers::Collector.new

      handler.registry.should eq(Prometheus::Client.registry)
    end

    it "should allow a custom registry" do
      registry = Prometheus::Client::Registry.new
      handler = Prometheus::HTTP::Handlers::Collector.new(registry: registry)
      handler.registry.should eq(registry)
      handler.registry.should_not eq(Prometheus::Client.registry)
    end

    it "should create an HTTP request counter named http_requests_total" do
      registry = Prometheus::Client::Registry.new
      handler = Prometheus::HTTP::Handlers::Collector.new(registry: registry)
      registry.get(:http_requests_total).should be_a(Prometheus::Client::Counter)
    end

    it "should create an exceptions counter named http_exceptions_total" do
      registry = Prometheus::Client::Registry.new
      handler = Prometheus::HTTP::Handlers::Collector.new(registry: registry)
      registry.get(:http_exceptions_total).should be_a(Prometheus::Client::Counter)
    end

    it "should create an HTTP request durations histogram named http_request_duration_total_milliseconds" do
      registry = Prometheus::Client::Registry.new
      handler = Prometheus::HTTP::Handlers::Collector.new(registry: registry)
      handler.registry.should eq(registry)
      handler.registry.should_not eq(Prometheus::Client.registry)
      registry.get(:http_request_duration_total_milliseconds).should be_a(Prometheus::Client::Histogram)
    end
  end

  it "should return the app response" do
    io = IO::Memory.new
    request = HTTP::Request.new("GET", "/")
    response = HTTP::Server::Response.new(io)
    context = HTTP::Server::Context.new(request, response)

    called = false
    handler = Prometheus::HTTP::Handlers::Collector.new(registry: Prometheus::Client::Registry.new)
    handler.next = ->(ctx : HTTP::Server::Context) do
      called = true
      ctx.response.status_code = 201
      ctx.response.print "OK"
    end
    handler.call(context)

    called.should be_true
    context.response.status_code.should eq(201)
  end

  it "traces request information" do
    io = IO::Memory.new
    request = HTTP::Request.new("GET", "/foo")
    response = HTTP::Server::Response.new(io)
    context = HTTP::Server::Context.new(request, response)
    registry = Prometheus::Client::Registry.new

    handler = Prometheus::HTTP::Handlers::Collector.new(registry: registry)
    handler.next = ->(ctx : HTTP::Server::Context) do
      ctx.response.status_code = 201
      ctx.response.print "OK"
    end
    handler.call(context)

    registry.get(:http_requests_total)
            .get({:method => "GET", :path => "/foo", :code => "201"})
            .should eq(1.0)
  end
end
