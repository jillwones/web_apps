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

  get '/albums/new' do 
    return erb(:new_album)
  end

  get '/artists/new' do 
    return erb(:new_artist)
  end

  get '/albums' do 
    @album_repository = AlbumRepository.new 
    return erb(:all_albums)
  end

  post '/albums' do 
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]

    if (title != nil) and (release_year.to_i.digits.length == 4) and (artist_id =~ /^[0-9]*$/)
      album = Album.new 
      album.title = title 
      album.release_year = release_year
      album.artist_id = artist_id

      album_repository = AlbumRepository.new 
      album_repository.create(album)
      return erb(:album_success)
    else
      status 400
      return erb(:album_failure)
    end
  end

  get '/artists' do 
    @artist_repository = ArtistRepository.new 
    return erb(:all_artists)
  end

  post '/artists' do 
    if !params[:name].empty? and !params[:genre].empty?
      artist = Artist.new 
      artist_repository = ArtistRepository.new
      artist.name = params[:name]
      artist.genre = params[:genre]
      artist_repository.create(artist)
      return erb(:artist_success)
    else 
      status 400
      return erb(:artist_failure)
    end
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

  get '/artists/:id' do 
    artist_repository = ArtistRepository.new 
    artist = artist_repository.find(params[:id])
    @artist_name = artist.name 
    @artist_genre = artist.genre
    return erb(:individual_artists)
  end
end