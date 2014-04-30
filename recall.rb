require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required =>true
  property :complete, Boolean, :required =>true, :default =>false
  property :created_at, DateTime
  property :updated_at, DateTime
end
DataMapper.finalize.auto_upgrade!

get '/' do
  @notes = Note.all :order => :id.desc
  @title = 'All Notes'
  erb :home
end

post '/' do
  n=Note.new
  n.content=params[:content]
  n.complete=params[:complete] ? 1 : 0
  n.created_at=Time.now
  n.updated_at=Time.now
  n.save
  redirect '/'
end

delete '/:id' do
  n=Note.get params[:id]
  n.destroy
  redirect '/'
end


get '/:id/complete' do 
  n=Note.get params[:id]
  n.complete = n.complete ? 0 : 1 
  n.updated_at = Time.now
  n.save
  redirect '/'
end

put '/:id' do
  note = Note.get params[:id]
  note.content=params[:content]
  note.save
  redirect '/'
end










