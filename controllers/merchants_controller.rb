require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/merchant.rb' )
also_reload( '../models/*' )

get '/merchants' do
  @merchants = Merchant.all()
  erb ( :"merchants/index" )
end

get '/merchants/new' do
  erb(:"merchants/new")
end

get '/merchants/:id' do
  @merchant = Merchant.find(params['id'].to_i)
  erb(:"merchants/show")
end

get '/merchants/:id/edit' do
  @merchant = Merchant.find(params['id'])
  erb(:"merchants/edit")
end

post '/merchants/:id' do
  merchant = Merchant.new(params)
  merchant.update
  redirect to "/merchants/#{params['id']}"
end

post '/merchants' do
  merchant = Merchant.new(params)
  merchant.save
  redirect to("/merchants")
end

post '/merchants/:id/delete' do
  Merchant.delete(params[:id])
  redirect to("/merchants")
end
