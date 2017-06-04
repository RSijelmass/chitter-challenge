ENV['RACK_ENV'] ||= 'development'
require 'sinatra/base'

require_relative 'datamapper_setup'

class Critter < Sinatra::Base
	enable :sessions
	set :session_secret, 'super secret'

	helpers do
		def current_user
			@current_user ||= User.get(session[:user_id])
		end
	end

	get '/' do
	 	erb :index	
	end
	
	post '/signup' do
		user = User.create(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
		session[:user_id] = user.id
		redirect '/creets'
	end

	get '/creets' do
		@messages = Message.all
		@messages.each { |message| 
			p "Message: #{message}"
			p "User: #{message.user.username}" }
		erb :creets
	end

	post '/messages' do
		message = Message.create(text: params[:message], time: Message.set_time)
		message.user = current_user 
		message.save!
		redirect '/creets'
	end
end
