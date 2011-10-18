require "prowly"
require 'feed-normalizer'
require 'open-uri'
require 'sinatra'

get '/' do
  "News Push!"
end

get '/push' do
	push_latest_news
end

def push_latest_news

	feed = FeedNormalizer::FeedNormalizer.parse open('http://news.google.com/?output=rss')
	entry = feed.entries[0]
	latest_title = entry.title
	latest_url = entry.url

	if Time.now.hour >= 8
	  Prowly.notify do |n|
	  	n.apikey =  "2962a6694798b52f045ac3453a60480eca43ac67"
	  	n.application = "News Pusher"
	    n.event = "Alert"
	    n.description = latest_title
	    n.url = latest_url
	    return latest_title
	  end
	else
		return "Sleeping"
	end
end