require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
	enable :sessions
	set :session_secret, "secret"
end

get "/flight/find" do
	erb :search
end

def is_valid_airline?(airline_value)
	airline_value.chars.each do |char|
		if !("a".."z").to_a.include?(char)
			return false
		end
	end
end

def is_valid_flight_number?(flight_number_value)
	flight_number_value.chars.each do |char|
		if !("0".."9").to_a.include?(char)
			return false
		end
	end
end

def is_valid_destination?(destination_value)
	destination_value.chars.each do |char|
		if !("a".."z").to_a.include?(char)
			return false
		end
	end
end

def is_valid_departure_time?(departure_time)
  
  return false if !departure_time.include?(":")
  
  hours, mins = departure_time.split(":")
  
  if (0..23).cover?(hours.to_i)
    return true
  elsif (0..59).cover?(mins.to_i)
    return true
  else
    return false
  end

end

get "/search" do

	session[:details] = {
		"airline" => params[:airline],
		"flight_number" => params[:flight_number],
		"destination" => params[:destination],
		"departure_time" => params[:departure_time]
	}

	@airline = session[:details]["airline"]
	@flight_number = session[:details]["flight_number"]
	@destination = session[:details]["destination"]
	@departure_time = session[:details]["departure_time"]

	if !is_valid_airline?(@airline)
		session[:error] = "Invalid Airline entered. Please try again." 
	elsif !is_valid_flight_number?(@flight_number)
		session[:error] = "Invalid Flight Number entered. Please try again."
	elsif !is_valid_destination?(@destination)
		session[:error] = "Invalid Destination entered. Please try again."
	elsif !is_valid_departure_time?(@departure_time)
		session[:error] = "You have entered either invalid time or time in an invalid format. Please try again.
						  Time must be in vaid format. E.g - 03:30"		
	else
		session[:success] = "Thank you!!"
		redirect "/details"
	end

	if ((!is_valid_airline?(@airline)) && 
		(!is_valid_flight_number?(@flight_number)) && 
		(!is_valid_destination?(@destination)) && 
		(!is_valid_departure_time?(@departure_time)))
			session[:error] = "You have entered invalid values. Please enter correct values."
	end

	erb :search
end

get "/details" do
	erb :details
end

get "/" do
	session[:details]["airline"] = ""
	session[:details]["flight_number"] = ""
	session[:details]["destination"] = ""
	session[:details]["departure_time"]  = ""

	erb :home
end