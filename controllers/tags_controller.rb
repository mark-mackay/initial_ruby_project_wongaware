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
  redirect to "/tags"
end

post '/tags' do
  tag = Tag.new(params)
  tag.save
  redirect to("/tags")
end

post '/tags/:id/delete' do
  if Transaction.transactions_by_tag(params[:id]) == nil
    Tag.delete(params[:id])
    redirect to("/tags")
  else
    @message = "Cannot delete tag, it has associated transactions"
    redirect to("/tags/transactions/#{params[:id]}")
  end
end
