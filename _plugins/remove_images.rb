module Jekyll
  module RemoveImagesFilter
    def remove_images(input)
      input.to_s.gsub(/<img[^>]*>/i, '').gsub(/<p><\/p>/i, '')
    end
  end
end

Liquid::Template.register_filter(Jekyll::RemoveImagesFilter)