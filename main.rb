require './sinatra/head_includes'
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
    recieved_totals = db.execute("SELECT h.id, count(m.ROWID) AS count FROM message AS m 
    INNER JOIN handle AS h ON m.handle_id = h.ROWID WHERE m.is_from_me = 0 GROUP BY h.id ORDER BY count DESC")

    sent_totals = db.execute("SELECT h.id, count(m.ROWID) AS count FROM message AS m INNER JOIN chat_message_join
    AS cmj ON m.ROWID = cmj.message_id INNER JOIN chat_handle_join AS chj ON cmj.chat_id = chj.chat_id INNER JOIN
    handle AS h ON chj.handle_id = h.ROWID WHERE m.is_from_me = 1 GROUP BY h.id ORDER BY count DESC")

    @result = Hash.new{ |hash, key| hash[key] = {:recieved => 0, :sent => 0, :total => 0}}
    recieved_totals.each do |row|
      @result[row["id"]][:recieved] = @result[row["id"]][:total] = row["count"]
    end
    sent_totals.each do |row|
      @result[row["id"]][:sent] = row["count"]
      @result[row["id"]][:total] += row["count"]
    end

  ensure
    db.close
    tmpfile.close!
  end

  @result = @result.sort_by { |k, v| v[:total] }.reverse

  js :jquery
  erb :result
end

not_found do
  erb "That's not a valid page"
end

error do
  erb "Error: " + env['sinatra.error'].message
end

error SQLite3::Exception do
  erb "Error: Please ensure you are uploading a valid database from ios7"
end