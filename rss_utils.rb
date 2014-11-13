require 'simple-rss'
require 'open-uri'

def rss_entries
  entries = []
  RSS_FEEDS.each do |feed|
    rss = SimpleRSS.parse open(feed)
    entries << rss.items
  end
  entries.flatten!
end