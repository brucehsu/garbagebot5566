$LOAD_PATH << '.'
require 'config'
require 'rss_utils'
require 'rest-core'
require 'rest-more'

client = RC::Facebook.new(app_id: FACEBOOK_APP_KEY, secret: FACEBOOK_APP_SECRET)

if FACEBOOK_ACCESS_TOKEN.empty?
  # redirect user to get access token
  fb_url = 'https://www.facebook.com/connect/login_success.html'
  auth_url = client.authorize_url(redirect_uri: fb_url, scope: 'public_profile, publish_actions')
  puts "Please use your web browser to visit: #{auth_url}"
  puts "Please input code: "
  code = gets.rstrip
  client.authorize!(redirect_uri: fb_url, code: code)
  puts "Please remember this access token and run again: #{client.access_token}"
  exit
end

client.access_token = FACEBOOK_ACCESS_TOKEN
uid = client.me['id']
post_id = nil

rss_entries.each do |entry|
  KEYWORDS.each do |keyword|
    if entry.title.downcase.include? keyword.downcase
      if post_id
        client.post("/#{post_id}/comments", message: entry.link)
      else
        post_id = client.post("/#{uid}/feed", link: entry.link)['id'].split('_')[1]
      end
      break
    end
  end
end
# example: p client.post("/#{uid}/feed", message: 'kerker')