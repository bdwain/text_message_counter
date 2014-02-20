require 'sinatra'
require 'sqlite3'

get '/' do
  erb :index
end

post '/' do
  unless params[:sms_db] &&(tmpfile = params[:sms_db][:tempfile])
    return erb "<br />Error"
  end

  
  erb :result
end