# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/all_albums' do # SELECT all albums
    repo = AlbumRepository.new
    albums = repo.all
    return albums.map(&:title).join(", ")
  end

  post '/all_albums' do # CREATE album
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)
    return ""
  end

  get '/albums' do # returns an array object of all the album objects
    repo = AlbumRepository.new
    albums = repo.all
    @album_info = albums.map{ |album| [album.title, album.release_year, album.id]}

    return erb(:albums)
  end

  get '/albums/' do # returns an array object of all the album objects
    repo = AlbumRepository.new
    albums = repo.all
    @album_info = albums.map{ |album| [album.title, album.release_year, album.id]}

    return erb(:albums)
  end

  get '/albums/:id' do # returns webpage of a single album info
    album_id = params[:id]
    album_repo = AlbumRepository.new
    artist_repo = ArtistRepository.new
    album = album_repo.find(album_id)
    artist = artist_repo.find(album.artist_id)
    @title = album.title
    @release_year = album.release_year
    @artist = artist.name
    return erb(:album)
  end

  get '/all_artists' do # Returns a list of artists names
    repo = ArtistRepository.new
    artists = repo.all
    artists.map(&:name).join(", ")
  end

  post '/all_artists' do # Returns a list of album titles
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    repo.create(new_artist)
    return ""
  end

  get '/test' do # Just testing erb for the first time!
    @names = ['Pablo', 'Sabina', 'Gurutze']
    @title = "Names list"
    return erb(:test) 
  end

  get "/albums/new/form" do
    return erb(:new_album_form)
  end

  post "/albums/new" do
    if invalid_album_parameters?()
      status 400
      return ''
    end
    @artist = params[:artist]
    @release_year = params[:release_year]
    @title = params[:title]
    album_repo = AlbumRepository.new
    new_album = Album.new
    artist_repo = ArtistRepository.new
    artists = artist_repo.all
    new_album.artist_id = 0
    artists.each { |item| new_album.artist_id = item.id if @artist == item.name }
    new_album.title = @title
    new_album.release_year = @release_year.to_i
    album_repo.create(new_album)
    return erb(:new_album)
  end

  get '/artists/new/form' do
    return erb(:new_artist_form)
  end

  post '/artists/new' do
    @name, @genre = params[:name], params[:genre]
    new_artist = Artist.new
    new_artist.name, new_artist.genre = @name, @genre
    ArtistRepository.new.create(new_artist)
    return erb(:new_artist)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:artists)
  end 

  get '/artists/:id' do
    artist_id = params[:id]
    repo = ArtistRepository.new
    @artist = repo.find(artist_id)
    return erb(:artist)
  end


  def  invalid_album_parameters?
    return true if params[:title] == nil || params[:release_year] == nil || params[:artist] == nil
    return true if params[:title] == '' || params[:release_year] == '' || params[:artist] == ''
    return false
  end



end