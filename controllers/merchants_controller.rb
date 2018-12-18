require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/merchant.rb' )
also_reload( '../models/*' )

get '/merchants' do
  @merchants = Merchant.all()
  erb ( :"merchants/index" )
end

get '/merchants/transactions/:id' do
  @transactions = Transaction.transactions_by_merchant(params['id'].to_i)
  @transaction_type = "merchants"
  erb ( :"transactions/show")
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
  redirect to "/merchants"
end

post '/merchants' do
  merchant = Merchant.new(params)
  merchant.save
  redirect to("/merchants")
end

post '/merchants/:id/delete' do
  if Transaction.transactions_by_merchant(params[:id]) == nil
      Merchant.delete(params[:id])
      redirect to("/merchants")
  else
    @message = "Cannot delete merchant, it has associated transactions"
    redirect to("/merchants/transactions/#{params[:id]}")
  end
end
