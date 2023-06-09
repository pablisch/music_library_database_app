require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_tables
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  before(:each) do 
    reset_tables
  end
  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "get all albums" do
    it "returns a list of all albums" do
      response = get('/all_albums')

      albums_list = "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"

      expect(response.status).to eq 200
      expect(response.body).to eq albums_list
    end
  end

  context "creates an album" do
    it "creates a new resource (album) and returns nothing #1" do
      response = post('/all_albums', title: 'OK Computer', release_year: '1997', artist_id: '1')

      expect(response.status).to eq 200
      expect(response.body).to eq ''

      response = get('/all_albums')
      expect(response.body).to include('OK Computer')
    end

    it "creates a new resource (album) and returns nothing #2" do
      response = post('/all_albums', title: 'Voyage', release_year: '2022', artist_id: '2')

      expect(response.status).to eq 200
      expect(response.body).to eq ''

      response = get('/all_albums')
      expect(response.body).to include('Voyage')
    end
  end

  it "creates a new artist and returns nothing" do
    response = post('/all_artists', name: 'Wild nothing', genre: 'Indie')
    expect(response.status).to eq 200
    expect(response.body).to eq ""
    response = get('./all_artists')
    expect(response.body).to include 'Wild nothing'
  end

  context "returns HTML content displaying dteails for a single album" do
    it "returns album 1 details from albums" do
      response = get('/albums/1')
      expect(response.body).to include '<h1>Doolittle</h1>'
      expect(response.body).to include 
      '<p>Release year: 1989 Astist: Pixies</p>'
    end

    it "returns album 1 details from albums" do
      response = get('/albums/2')
      expect(response.body).to include '<h1>Surfer Rosa</h1>'
      expect(response.body).to include 
      '<p>Release year: 1988 Artist: Pixies</p>'
    end
  end

  context "returns HTML content displaying details for all albums" do
    it "returns all albums as a list with detials" do
      response = get('/albums')
      expect(response.body).to include '<h1>Albums</h1>'
      expect(response.body).to include 
      '<p>Title: Doolittle Realease year: 1989</p>'
      expect(response.body).to include 
      '<p>Title: Surfer Rosa Realease year: 1988</p>'
    end
  end

  it "returns all artist as a list with details" do
    response = get('/artists')
    expect(response.body).to include '<h1>Artists</h1>'
    expect(response.body).to include 
    'Artist name: Pixies'
    expect(response.body).to include 
    'Genre: Pop'
    expect(response.body).to include 
    'Genre: Rock'
  end

  it "returns a single artist with details" do
    response = get('/artists/3')
    expect(response.status).to eq 200
    expect(response.body).to include '<h1>Taylor Swift</h1>'
    expect(response.body).to include 'Genre: Pop'
  end

  it "returns a form for a new album to be created" do
    response = get('albums/new/form')
    expect(response.status).to eq 200
    expect(response.body).to include 'form method="POST"'
    expect(response.body).to include "</form>"
    expect(response.body).to include 'input type="text"'
  end

  context "POST /albums/new" do
    it "creates a new album and returns a confirmation page" do
      response = post('albums/new', title: 'First Take', artist: 'Roberta Flack', release_year: '1969')
      expect(response.status).to eq 200
      expect(response.body).to include "<h2>'First Take' has been added to the album database</h2>"
      album = AlbumRepository.new.find(13)
      expect(album.title).to eq 'First Take'
      expect(album.release_year).to eq '1969'
    end

    it "creates a new album and returns a confirmation page" do
      response = post('albums/new', title: 'Prophecy', artist: 'The Comet is Coming', release_year: '2015')
      expect(response.status).to eq 200
      expect(response.body).to include "<h2>'Prophecy' has been added to the album database</h2>"
    end

    it "returns nothing when a nil value is given" do
      response = post('albums/new', title: 'Prophecy', artist: 'The Comet is Coming')
      expect(response.status).to eq 400
    end

    it "returns nothing when an empty value is given" do
      response = post('albums/new', title: '', artist: 'The Comet is Coming', release_year: '2015')
      expect(response.status).to eq 400
    end
  end

  context "GET artists/new/form" do
    it "returns a new artist form" do
      response = get('artists/new/form')
      expect(response.status).to eq 200
      expect(response.body).to include '<form method="POST" action="/artists/new"'
    end
  end

  context "POST artists/new" do
    it "creates a new artist and returns a confirmation page" do
      response = post('artists/new', name: 'The Comet is Coming', genre: 'Modern Jazz')
      expect(response.status).to eq 200
      expect(response.body).to include '<h2>The Comet is Coming has been added to the Artist database.</h2>'
      artist = ArtistRepository.new.find(5)
      expect(artist.name).to eq 'The Comet is Coming'
      expect(artist.genre).to eq 'Modern Jazz'
    end

    it "creates a new artist and returns a confirmation page" do
      response = post('artists/new', name: 'Derrick Harriot', genre: 'Reggae')
      expect(response.status).to eq 200
      expect(response.body).to include '<h2>Derrick Harriot has been added to the Artist database.</h2>'
      artist = ArtistRepository.new.find(5)
      expect(artist.name).to eq 'Derrick Harriot'
      expect(artist.genre).to eq 'Reggae'
    end

    it "returns a 400 status when a nil value is passed" do
      response = post('artists/new', name: 'Derrick Harriot')
      expect(response.status).to eq 400
    end

    it "returns a 400 status when an empty value is passed" do
      response = post('artists/new', name: 'Derrick Harriot', genre: '')
      expect(response.status).to eq 400
    end
  end 
end
