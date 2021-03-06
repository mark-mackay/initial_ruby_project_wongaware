require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative( '../models/transaction.rb' )
require_relative( '../models/tag.rb' )
require_relative( '../models/merchant.rb' )
require_relative( '../models/user.rb' )
also_reload( '../models/*' )

get '/transactions/new' do
  @tags = Tag.all
  @merchants = Merchant.all
  erb(:"transactions/new")
end

get '/transactions' do
  @transactions = Transaction.all
  erb ( :"transactions/index" )
end

get '/transactions/srtdate' do
  # Transactions sorted by date
  @transactions = Transaction.all.sort_by {|transaction| transaction.date_time}
  erb ( :"transactions/index" )
end

get '/transactions/srtamount' do
  # Transactions sorted by amount
  @transactions = Transaction.all.sort_by {|transaction| transaction.amount}
  # Show largest 1st
  @transactions = @transactions.reverse
  erb ( :"transactions/index" )
end

get '/transactions/bymonth' do
  @transactions = Transaction.bymonth(params['yearmonth'].to_s)
  @transaction_type = "month & year"
  erb(:"transactions/show")
end

get '/transactions/:id' do
  @transactions = Transaction.find(params['id'].to_i)
  erb( :"transactions/show" )
end


post '/transactions/:id' do
  transaction = Transaction.new(params)
  transaction.update
  redirect to "/transactions"
end

get '/transactions/:id/edit' do
  @tags = Tag.all
  @merchants = Merchant.all
  @transaction = Transaction.find(params['id'])
  erb(:"transactions/edit")
end

post '/transactions' do
  transaction = Transaction.new(params)
  transaction.save
  redirect to("/transactions")
end

post '/transactions/:id/delete' do
  Transaction.delete(params[:id])
  redirect to("/transactions")
end
