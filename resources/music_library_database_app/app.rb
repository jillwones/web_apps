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

  get '/albums' do 
    @album_repository = AlbumRepository.new 
    return erb(:all_albums)
  end

  post '/albums' do 
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]

    album = Album.new 
    album.title = title 
    album.release_year = release_year
    album.artist_id = artist_id

    album_repository = AlbumRepository.new 
    album_repository.create(album)
  end

  get '/artists' do 
    artist_repository = ArtistRepository.new 
    artist_repository.all.map(&:name).join(', ')
  end

  post '/artists' do 
    artist = Artist.new 
    artist_repository = ArtistRepository.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    artist_repository.create(artist)
  end

  get '/albums/:id' do 
    album_repository = AlbumRepository.new 
    album = album_repository.find(params[:id])
    artist_id = album.artist_id

    artist_repository = ArtistRepository.new 
    artist = artist_repository.find(artist_id)

    @album_name = album.title
    @artist_name = artist.name 
    @release_year = album.release_year

    return erb(:individual_albums)
  end
end