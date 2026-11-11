class GalleryController < ApplicationController
  def index
    @photos = GalleryPhoto.all
  end

  def show
    @photo = GalleryPhoto.find(params[:slug])
    @previous_photo = @photo.previous
    @next_photo = @photo.next
  end
end
