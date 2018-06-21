require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
	enable :sessions
	set :session_secret, "secret"
end

get "/search" do

	# unless validate_airline(params[:airline]) 
	# if !validate_airline(params[:airline])
	# 	redirect "/"
	# end

	session[:airline] = params[:airline]
	session[:flight_number] = params[:flight_number]
	session[:destination] = params[:destination]
	session[:departure_time] = params[:departure_time]

	# if [session[:airline], session[:flight_number], 
	# 	session[:destination], session[:departure_time]].all? {|el| el == ""}
	# 	session[:message] = "You have not entered any of the values."
	# end

	if (session[:airline] && session[:flight_number] && 
		session[:destination] && session[:departure_time]) == ""
		session[:message] = "You have not entered any of the values."
		redirect "/search"
	end

	if session[:airline] == ""
		session[:message] = "Airline field can not blank."
		erb :search
	elsif session[:flight_number] == ""
		session[:message] = "Flight Number field can not be blank."
		erb :search
	elsif session[:destination] == ""
		session[:message] = "Destination can not be blank."
		erb :search
	elsif session[:departure_time] == ""
		session[:message] = "Departure Time can not be blank."
		erb :search
	else
		# session[:success] = "Your details are as below"
		# redirect "/details"
	end



	# if ![String].include?(session[:airline])
	# 	session[:error] = "You have entered an invalid airline - #{session[:airline]}. 
	# 					   Please enter the correct value"
	# end

	erb :search
end

get "/details" do
	erb :details
end

get "/" do
	erb :home
end

# get "/payments/create" do
# 	erb :search
# end

# get "/search" do

# 	session[:details] = {
# 		"firstname" => params[:firstname],
# 		"lastname" => params[:lastname],
# 		"cardno" => params[:cardno],
# 		"expirydate" => params[:expirydate],
# 		"ccv" => params[:ccv]
# 	}

# 	session[:missing_values] = session[:details].keys.select do |k|
# 		session[:details][k] == ""
# 	end.join(", ")

# 	if session[:details].values.include?("")
# 		session[:error] = "#{session[:missing_values]} are missing"
# 		erb :search
# 	elsif (session[:details]["cardno"].size < 16)
# 		session[:error] = "Card No must be greater than 16 digits"
# 		erb :search
# 	else
# 		session[:details]["cardno"] = session[:details]["cardno"][0..11].split("")
# 										.map{|c|c="*"}.each_slice(4).to_a
# 										.map{|arr| arr.join}.join("-") + "-" + session[:details]["cardno"][-4..-1]
# 		session[:details]["created_time"] = Time.new
# 		session[:success] = "Thank you for your payment."

# 		session["payment_count"] = 0

# 		redirect "/payments"
# 	end

# end
