require 'sinatra'
require "sinatra/reloader" if development?
require 'pry'

require_relative 'lib/twit.rb'
require_relative 'lib/user.rb'

@@users = [User.new("jake", "12345"), User.new("pepe", "12345")]
@@twits = [Twit.new("Solo lechugas #vegetariano", "jake"), Twit.new("Solo tomate #vegetariano", "jake")]

enable(:sessions)

before '/profile' do
   redirect to('/') unless session[:logged_in] 
end

get '/' do
  erb(:index)
end

post '/register' do
	@user = User.new(params[:username], params[:password])
	@@users << @user
	session[:username] = params[:username]
	session[:logged_in] = true
	redirect to('/profile')
end

post '/login' do
	user_valid = @@users.find {|user| user.name == params[:username] && user.password == params[:password] }
	if user_valid
		session[:username] = params[:username]
		session[:logged_in] = true
		redirect to('/profile')
	else
		redirect to('/')
	end
end

get '/profile' do
	@twits_to_print = @@twits.select { |twit| twit.user == session[:username]}
	erb(:profile)
end

get '/timeline' do
	@twits_to_print = @@twits
	erb(:timeline)
end

get '/logout' do
	session[:logged_in] = false
	redirect to("/")
end

post '/crear_twit' do
  @@twits << Twit.new(params[:message], session[:username])
  redirect to("/profile")
end


