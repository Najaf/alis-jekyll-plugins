require 'yaml'
module Jekyll
    class ImageTag < Liquid::Tag
        def initialize(name, text, tokens)
            super
            @name = name
            @text = text.strip
            @tokens = tokens
        end

        def render(context)
            base_dir = File.dirname(__FILE__) + '/../../'
            img_path_base = "images" + context['page']['id'] + "/" + @text

            # determine if a jpg/png exists, set img_path if it does
            if File.exist?(base_dir + img_path_base + '.png')
                img_path = img_path_base + '.png'
            elsif File.exist?(base_dir + img_path_base + '.jpg')
                img_path = img_path_base + '.jpg'
            else
                raise "No image: #{base_dir + img_path_base}.[png|jpg] found"
            end

            #determine alt/title text
            alt_title = @text.split('-').select { |w| w.capitalize! || w }.join(' ')

            output  = "<img src=\"#{img_path}\" alt=\"#{alt_title}\" title=\"#{alt_title}\" />"
        end
    end
end

Liquid::Template.register_tag('img', Jekyll::ImageTag)
