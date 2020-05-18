class RelatedImagesController < ApplicationController
  before_action :logged_in_user

  def destroy
    related_image = RelatedImage.find(params[:id])
    @id = related_image.id
    related_image.destroy
  end
end
