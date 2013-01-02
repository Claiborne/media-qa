require 'rspec'
require 'nokogiri'
require 'pathconfig'
require 'rest_client'
require 'json'

%w(http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/506322a0f22faa4156981832
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/50632832f22faa4156981834
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/50632a7ff22faa4156981836
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/50632b27f22faa4156981838
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/50633966f22faa415698183a
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/506341fdf22faa415698183c
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/5063a28bf22faa4156981843
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/5063a37cf22faa4156981844
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/5063a9a1f22faa4156981846
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/5063aa3cf22faa4156981848
http://media-article-stg-services-01.sfdev.colo.ignops.com:8080/article/v3/articles/506a2257f22faa4156981872).each do |article|

res = RestClient.get(article)
data = JSON.parse(res.body)
File.open("/Users/wclaiborne/Desktop/review_articles/#{data['metadata']['slug']}.json", 'w') {|f| f.write(data.to_json) }
  end