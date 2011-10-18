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
	  	n.apikey =  ENV["PROWL_KEY"]
	  	n.application = "News Pusher"
	    n.event = "Alert"
	    n.description = latest_title
	    n.url = latest_url
	  end
	  return latest_title
	else
		return "Sleeping"
	end
end