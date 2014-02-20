require 'sinatra'
require 'sqlite3'

def get_homepage
  erb :index
end

get '/' do
  get_homepage
end

post '/' do
  unless params[:sms_db] &&(tmpfile = params[:sms_db][:tempfile])
    return get_homepage
  end
  
  erb :result
end