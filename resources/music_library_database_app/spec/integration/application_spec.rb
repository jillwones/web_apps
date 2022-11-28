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

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  before(:each) do 
    reset_tables
  end

  context 'POST /albums' do 
    it 'creates a new album record' do
       response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)

       repo = AlbumRepository.new 
      
       expect(response.status).to eq(200)
       expect(repo.all.last.title).to eq('Voyage')
       expect(repo.all.last.release_year).to eq('2022')
    end
  end

  context 'GET /albums' do 
    it 'lists all albums' do 
      response = get('/albums')

      expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context 'GET /artists' do 
    it 'lists all artists' do 
      response = get('/artists')

      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone'
      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context 'POST /artists' do 
    it 'creates a new artist record' do 
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')

      repo = ArtistRepository.new 
      expect(response.status).to eq(200)
      expect(repo.all.last.name).to eq('Wild nothing')
      expect(repo.all.last.genre).to eq('Indie')
    end
  end
end
