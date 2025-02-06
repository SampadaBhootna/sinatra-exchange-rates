# /app.rb

require "sinatra"
require "sinatra/reloader"
require "dotenv/load"


# Pull in the HTTP class
require "http"

# define a route for the homepage
get("/") do

  # Assemble the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch('EXCHANGE_KEY')}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  #fetch the currencies key 

  @currencies = @parsed_data.fetch("currencies")
  
  @currency_initials = @currencies.keys
  # Render a view template
  erb(:homepage)

end

get("/:first_symbol") do
  @the_symbol=params.fetch("first_symbol").to_s

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch('EXCHANGE_KEY')}"

  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  #fetch the currencies key 

  @currencies = @parsed_data.fetch("currencies")
  
  @currency_initials = @currencies.keys
  
  erb(:step_one)
end

get("/:first_symbol/:second_symbol") do
  # Assemble the API url, including the API key in the query string
  @first_symbol=params.fetch("first_symbol").to_s
  @second_symbol=params.fetch("second_symbol").to_s
  api_url = "https://api.exchangerate.host/convert?from=#{@first_symbol}&to=#{@second_symbol}&amount=1&access_key=#{ENV.fetch('EXCHANGE_KEY')}"


  # Use HTTP.get to retrieve the API data
  @raw_response = HTTP.get(api_url)

  # Get the body of the response as a string
  @raw_string = @raw_response.to_s

  # Convert the string to JSON
  @parsed_data = JSON.parse(@raw_string)

  #fetch the conversion value key 

  @value=@parsed_data.fetch("result")
  erb(:result)
end
