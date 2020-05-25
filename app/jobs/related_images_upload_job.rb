class RelatedImagesUploadJob < ApplicationJob
  queue_as :default

  def perform(related_image:, image_url:)
    related_image.upload_large_image(image_url)
  end
end
