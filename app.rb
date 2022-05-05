require 'slim'
require 'sinatra'
require 'sqlite3'
require 'bcrypt'

get('/')  do
    slim(:start)
end

get('/albums') do
  db = SQLite3::Database.new("db/slutprojekt_2022.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM Albums")
  p result
  slim(:"/music/index",locals:{albums:result})



end

post('/ta_bort') do
  albumid = params[:album_id].to_i
  db = SQLite3::Database.new("db/slutprojekt_2022.db")
  db.execute('DELETE FROM Albums WHERE album_id =?', albumid)
  redirect ('/albums')
end



get('/edit_item') do
  db = SQLite3::Database.new("db/slutprojekt_2022.db")
  db.results_as_hash = true
  albumid = params[:album_id].to_i 
  result = db.execute("SELECT * FROM Albums WHERE album_id = ?", albumid).first
  slim(:"edit",locals:{album:result,album_id:albumid})
end

post('/edited') do
  genre_id = params[:id].to_i
  title = params[:title]
  album_id = params[:ArtistId].to_i
  db = SQLite3::Database.new("db/slutprojekt_2022.db")
  db.execute("UPDATE albums SET Title=?,genre_id=? WHERE genre_id=?",title,album_id,genre_id)
  redirect('/albums')
end


get('/albums/new') do
     slim(:"albums/new")
end

post('/albums/new') do
  title = params[:title]
  album_id = params[:album_id].to_i
  genre_id = params[:genre_id]
  p "Vi fick in datan #{title} och #{album_id}"
  db = SQLite3::Database.new"db/slutprojekt_2022.db")
  db.execute("INSERT INTO Albums (genre_id, album_id, title ) VALUES (?,?,?)",genre_id, album_id, title)
  redirect('/albums')
end

post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]

    if (password == password_confirm)
        redirect('/albums')
      else
        redirect('/')
    end
end 


    # if (password == password_confirm)
    #   password_digest = BCrypt::Password.create(password)
    #   db = SQLite3::Database.new('db/slutprojekt_2022')
    #   db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
    #   redirect('music/index.slim')
    # else
  
    #   "lösenorden stämmer inte överens"
    # end

# get('/music') do
#   db = SQLite3::Database.new("db/slutprojekt_2022.db")
#   db.results_as_hash = true
#   result = db.execute("SELECT * FROM albums")
#   p result
#   slim(:"music/index",locals:{albums:result})






# end

# before do
#     p "Before KÖRS, session_user_id är #{session[:user_id]}."
#     if (session[:user_id] ==  nil) && (request.path_info != '/')
#       session[:error] = "You need to log in to see this"
#       redirect('/error')
#     end
# end

# get('/albums') do
#     db = SQLite3::Database.new("db/slutprojekt_2022.db")
#     db.results_as_hash = true
#     result = db.execute("SELECT * FROM albums")
#     p result
#     slim(:"albums/index",locals:{albums:result})
  
  
  
# end