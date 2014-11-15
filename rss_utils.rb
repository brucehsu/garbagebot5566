require 'simple-rss'
require 'open-uri'

def rss_entries
  entries = []
  RSS_FEEDS.each do |feed|
    rss = SimpleRSS.parse open(feed)
    entries << rss.items
  end
  now = Time.now
  entries.flatten!.map do |entry|
    published = entry.pubDate || entry.published
    (now - published) <= 86400 ? entry : nil
  end.compact
end