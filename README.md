# Prometheus Ruby Client

A suite of instrumentation metric primitives for Ruby that can be exposed through a HTTP interface. Intended to be used together with a [Prometheus server][prometheus].

[![Build Status](https://travis-ci.org/inkel/crystal-prometheus-client.svg?branch=master)](https://travis-ci.org/inkel/crystal-prometheus-client)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  prometheus:
    github: inkel/crystal-prometheus-client
```

## Usage

### Overview

```crystal
require "prometheus/client"

# returns a default registry
prometheus = Prometheus::Client.registry

# create a new counter metric
http_requests = Prometheus::Client::Counter.new(:http_requests, "A counter of HTTP requests made")
# register the metric
prometheus.register(http_requests)

# start using the counter
http_requests.increment
```
## Metrics

The following metric types are currently supported.

### Counter

Counter is a metric that exposes merely a sum or tally of things.

```ruby
counter = Prometheus::Client::Counter.new(:service_requests_total, "...")

# increment the counter for a given label set
counter.increment({ :service => "foo" })

# increment by a given value
counter.increment({ :service => "bar" }, 5)

# get current value for a given label set
counter.get({ :service => "bar" })
# => 5
```

### Gauge

Gauge is a metric that exposes merely an instantaneous value or some snapshot
thereof.

```ruby
gauge = Prometheus::Client::Gauge.new(:room_temperature_celsius, "...")

# set a value
gauge.set({ :room => "kitchen" }, 21.534)

# retrieve the current value for a given label set
gauge.get({ :room => "kitchen" })
# => 21.534
```

Also you can use gauge as the bi-directional counter:

```ruby
gauge = Prometheus::Client::Gauge.new(:concurrent_requests_total, "...")

gauge.increment({ :service => "foo" })
# => 1.0

gauge.decrement({ :service => "foo" })
# => 0.0
```

### Histogram

A histogram samples observations (usually things like request durations or
response sizes) and counts them in configurable buckets. It also provides a sum
of all observed values.

```ruby
histogram = Prometheus::Client::Histogram.new(:service_latency_seconds, "...")

# record a value
histogram.observe({ :service => "users" }, Benchmark.realtime { service.call(arg) })

# retrieve the current bucket values
histogram.get({ :service => "users" })
# => { 0.005 => 3, 0.01 => 15, 0.025 => 18, ..., 2.5 => 42, 5 => 42, 10 = >42 }
```

### Summary
TODO

## Caveats
* Currently it only supports `Float64`
* No `HTTP::Handler` middleware (yet)
* No [`Pushgateway`][pushgateway] support

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/inkel/crystal-prometheus-client/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [inkel](https://github.com/inkel) Leandro López - creator, maintainer

[prometheus]: https://prometheus.io/
[pushgateway]: https://github.com/prometheus/pushgateway
