require 'json'
require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

# Non concurrent
base_url = 'https://jsonplaceholder.typicode.com'
conn = Faraday.new(url: base_url, headers: {'Content-Type': 'application/json'})
post_comments = []

# 3.times do
#   100.times do |i|
#     post = conn.get("/posts/#{i + 1}")
#     post_comments << JSON.parse(post.body)
#   end
# end

# p post_comments


# Concurrent
t_conn = Faraday.new(url: base_url, headers: {'Content-Type': 'application/json'}) do |f|
  f.adapter :typhoeus
end

t_conn.in_parallel do
  20.times do
    100.times do |i|
      post_comments << t_conn.get("/posts/#{i + 1}")
    end
  end
end

p post_comments.map{|po| JSON.parse(po.body)}.count