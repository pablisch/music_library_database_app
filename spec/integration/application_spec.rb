require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  before(:each) do 
    reset_albums_table
  end
  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "get all albums" do
    it "returns a list of all albums" do
      response = get('/albums')

      albums_list = "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"

      expect(response.status).to eq 200
      expect(response.body).to eq albums_list
    end
  end

  context "creates an album" do
    it "creates a new resource (album) and returns nothing #1" do
      response = post('/albums', title: 'OK Computer', release_year: '1997', artist_id: '1')

      expect(response.status).to eq 200
      expect(response.body).to eq ''

      response = get('/albums')
      expect(response.body).to include('OK Computer')
    end

    it "creates a new resource (album) and returns nothing #2" do
      response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: '2')

      expect(response.status).to eq 200
      expect(response.body).to eq ''

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end
  end

  it "creates a new artist and returns nothing" do
    response = post('/artists', name: 'Wild nothing', genre: 'Indie')
    expect(response.status).to eq 200
    expect(response.body).to eq ""
    response = get('./artists')
    expect(response.body).to include 'Wild nothing'
  end
end
