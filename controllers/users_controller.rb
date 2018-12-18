require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/user.rb' )
also_reload( '../models/*' )

get '/users' do
  @user = User.all.first
  erb(:"users/index")
end


get '/users/edit' do
  @user = User.find(params['id'])
  erb(:"users/edit")
end

get '/users/:id' do
  @user = User.find(params['id'].to_i)
  erb(:"users/index")
end

post '/users/:id' do
  user = User.new(params)
  user.update
  redirect to "/users"
end
