class ImageAnnotateJob < ApplicationJob
  queue_as :second

  def perform(target,image_url)
 
    tempfile = image_url
    # tempfile = target.image.attachment.service.send(:object_for, target.image.key).public_url

    require "google/cloud/vision"
    image_annotator = Google::Cloud::Vision::ImageAnnotator.new
    response = image_annotator.safe_search_detection image: tempfile
    response.responses.each do |res|
    safe_search = res.safe_search_annotation
      if safe_search.adult.to_s == "VERY_LIKELY" || safe_search.adult.to_s == "LIKELY"
        target.destroy
        return
      elsif safe_search.violence.to_s == "VERY_LIKELY" || safe_search.violence.to_s == "LIKELY"
        target.destroy
        return
      elsif safe_search.medical.to_s == "VERY_LIKELY" || safe_search.medical.to_s == "LIKELY"
        target.destroy
        return
      end
    end

  end

end
