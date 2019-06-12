# Net::HTTP::Persistent Adapter

This Adapter uses the [net-http-persistent][rdoc] gem to make HTTP requests.

```ruby
conn = Faraday.new(...) do |f|
  f.adapter :net_http_persistent, pool_size: 5 do |http|
    # yields Net::HTTP::Persistent
    http.idle_timeout = 100
    http.retry_change_requests = true
  end
end
```

## Links

* [Gem RDoc][rdoc]
* [Gem source][src]
* [Adapter RDoc][adapter_rdoc]

[rdoc]: https://www.rubydoc.info/gems/net-http-persistent
[src]: https://github.com/drbrain/net-http-persistent
[adapter_rdoc]: https://www.rubydoc.info/gems/faraday/Faraday/Adapter/NetHttpPersistent
