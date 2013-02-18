class PhotosController < ApplicationController
  load_and_authorize_resource
  
  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new
    @photo.image = params[:Filedata]
    @photo.user_id = current_user.id
    @photo.save
    render :text => @photo.image.url
  end
end
