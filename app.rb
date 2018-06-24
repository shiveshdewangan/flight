require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, "secret"
end

before do
  session[:flights] ||= []
end

def valid_airline?(airline_value)
  arr = ("a".."z").to_a << " "
  airline_value.chars.each do |char|
    return false if !arr.include?(char.downcase)
  end
end

def valid_flight_number?(flight_number_value)
  flight_number_value.to_s.chars.each do |char|
    return false if !("0".."9").to_a.include?(char.downcase)
  end
end

def valid_destination?(destination_value)
  destination_value.chars.each do |char|
    return false if !("a".."z").to_a.include?(char.downcase)
  end
end

def valid_departure_time?(departure_time)
  return false if !departure_time.include?(":")
  hours, mins = departure_time.split(":")
  return false if !(0..23).cover?(hours.to_i) || !(0..59).cover?(mins.to_i)
end

get "/search" do
  erb :search
end

post "/search" do
  airline = params[:airline].to_s
  flight_number = params[:flight_number].to_s
  destination = params[:destination].to_s
  departure_time = params[:departure_time].to_s

  if valid_airline?(airline) == false
    session[:error] = "Invalid Airline entered. Please try again."
    erb :search
  elsif valid_flight_number?(flight_number) == false
    session[:error] = "Invalid Flight Number entered. Please try again."
    erb :search
  elsif valid_destination?(destination) == false
    session[:error] = "Invalid Destination entered. Please try again."
    erb :search
  elsif valid_departure_time?(departure_time) == false
    session[:error] = "Time must be in vaid format. E.g - 03:30"
    erb :search
  else
    session[:success] = "Thank you!!"
    session[:flights] << { "airline" => airline,
                           "flight_number" => flight_number,
                           "destination" => destination,
                           "departure_time" => departure_time }
    redirect "/"
  end
end

get "/" do
  erb :home
end
