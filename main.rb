require 'debug'

Dir.new('./site_format').children.each do |file|
  next unless file.end_with?('.rb') && file != 'site_structure.rb'

  require_relative "./site_format/#{file}"
end

path_to_json_result = './expected_arrays'

serp_api_challenge_link = 'https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.html'
bing_link = 'https://www.bing.com/search?q=Leonardo+da+Vinci+paintings&form=QBLH&sp=-1&ghc=2&lq=0&pq=leonardo+da+vinci+paintings&sc=10-27&qs=n&sk=&cvid=68B9840A12034429B78D07B9A775AD1E&ghsh=0&ghacc=0&ghpl='
google_link = 'https://www.google.com/search?q=claude+monet+paintings&sca_esv=53114e91519e1d18&sxsrf=ADLYWILH6eITGfJVb_-oMrwGEjpoUl0y0g%3A1721957729830&source=hp&ei=Yf2iZrLnL8miptQPifOz0Ao&iflsig=AL9hbdgAAAAAZqMLcentss0hb4MKFq4bBmctQQ85aisV&ved=0ahUKEwjym7W2yMOHAxVJkYkEHYn5DKoQ4dUDCBc&uact=5&oq=claude+monet+paintings&gs_lp=Egdnd3Mtd2l6IhZjbGF1ZGUgbW9uZXQgcGFpbnRpbmdzMggQABiABBixAzIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMggQABiABBjJA0iZClDPBFjPBHABeACQAQCYAW2gAW2qAQMwLjG4AQPIAQD4AQL4AQGYAgKgAnioAgrCAgcQIxgnGOoCmAMIkgcDMS4xoAfhBQ&sclient=gws-wiz'

SiteFormat::SerpApiChallenge.new(
  url: serp_api_challenge_link,
  result_path: "#{path_to_json_result}/serp_api.json"
).generate_json

SiteFormat::Bing.new(
  url: bing_link,
  result_path: "#{path_to_json_result}/bing.json"
).generate_json

SiteFormat::Google.new(
  url: google_link,
  result_path: "#{path_to_json_result}/google.json"
).generate_json
