require 'sinatra'
require 'sqlite3'

get '/' do
  erb :index
end

post '/' do
  unless params[:sms_db] &&(tmpfile = params[:sms_db][:tempfile])
    raise "no file"
  end


  begin
    db = SQLite3::Database::new(tmpfile.path)
    db.results_as_hash = true
    @result = db.execute("select h.ROWID, h.service, h.id, count(m.ROWID) as ct from message as m 
    inner join handle as h on m.handle_id = h.ROWID GROUP BY h.id order by ct desc")
  ensure
    db.close
    tmpfile.close!
  end

  erb :result
end

not_found do
  erb "That's not a valid page"
end

error do
  erb "Error: " + env['sinatra.error'].message
end

error SQLite3::Exception do
  erb "Database Error: Please ensure you are uploading a valid database from ios7"
end