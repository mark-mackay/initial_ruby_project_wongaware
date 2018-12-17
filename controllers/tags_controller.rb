require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative( '../models/tag.rb' )
also_reload( '../models/*' )

get '/tags' do
  @tags = Tag.all()
  erb ( :"tags/index" )
end

get '/tags/transactions/:id' do
  @transactions = Transaction.transactions_by_tag(params['id'].to_i)
  @transaction_type = "tags"
  erb ( :"transactions/show")
end

get '/tags/new' do
  erb(:"tags/new")
end

get '/tags/:id' do
  @tag = Tag.find(params['id'].to_i)
  erb( :"tags/show" )
end

get '/tags/:id/edit' do
  @tag = Tag.find(params['id'])
  erb(:"tags/edit")
end

post '/tags/:id' do
  tag = Tag.new(params)
  tag.update
  redirect to "/tags/#{params['id']}"
end

post '/tags' do
  tag = Tag.new(params)
  tag.save
  redirect to("/tags")
end

post '/tags/:id/delete' do
  Tag.delete(params[:id])
  redirect to("/tags")
end
