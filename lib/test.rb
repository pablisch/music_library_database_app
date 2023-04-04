require_relative './album_repository'
require_relative './database_connection'

DatabaseConnection.connect
repo = AlbumRepository.new
albums = repo.all
# albums.each{ |i| p i }
p albums.map{ |album| [album.title, album.release_year]}