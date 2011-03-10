require 'yaml'
module Jekyll
    # Nice easy image tags with cdn caching spiciness
    #     Images are expected in /images/:slug/:file.[png|jpg]
    #     where :file is passed into the tag as text
    #
    # Usage:
    #     In 2010-11-26-ochanomizu.markdown:
    #
    #         {%img kanda-myoujin%}
    #
    #     Will generate:
    #
    #         <img src='/images/ochanomizu/kanda-myoujin.[png|jpg]' alt='Kanda Myoujin' title='Kanda Myoujin' />
    #
    #     Prefers pngs to jpgs, and will error if it doesn't find at least one in the expected directory
    #
    #     With config.cdn_images == true and config.cdn_host = 'http://cdn.host.com' and ENV['JEKYLL_ENV'] = 'production'
    #     (best to set that in rakefile when you're actually deploying rather than just developing/writing)
    #
    #         <img src='http://cdn.host.com/images/ochanomizu/kanda-myoujin.[png|jpg]' alt='Kanda Myoujin' title='Kanda Myoujin' />
    #
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

            # prepend cdn host if config/env values set up for it
            config = context.registers[:site].config
            if config['cdn_images'] and config['cdn_host'] != '' and ENV['JEKYLL_ENV'] == 'production'
                img_path = config['cdn_host'] + '/' + img_path
            end

            #determine alt/title text
            alt_title = @text.split('-').select { |w| w.capitalize! || w }.join(' ')

            output  = "<img src=\"#{img_path}\" alt=\"#{alt_title}\" title=\"#{alt_title}\" />"
        end
    end
end

Liquid::Template.register_tag('img', Jekyll::ImageTag)
