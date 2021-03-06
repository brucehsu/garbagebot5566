def format_and_post(entry)
  text = "#{random_quote} #{hash_tags}"
  if @post_id
    p @client.post("/#{@post_id}/comments", message: "#{entry.link} #{text}")
  else
    @post_id = @client.post("/#{@uid}/feed", link: entry.link, message: text)['id'].split('_')[1]
    puts "Facebook post id: #{@post_id}"
  end
end

def random_quote
  @quotes = IO.readlines 'dict.txt' if @quotes.nil?
  has_quote = rand(10000) % 2
  has_quote == 1 ? @quotes.sample : ''
end

def hash_tags
  HASHTAGS.map { |tag| "\##{tag}"}.join ' '
end

def post_fallback
  fallback = FALLBACKS.sample
  @post_id = @client.post("/#{@uid}/feed", link: fallback[0], message: fallback[1])
  puts "Facebook post id: #{@post_id}"
  puts "Using fallback: #{p fallback}"
end