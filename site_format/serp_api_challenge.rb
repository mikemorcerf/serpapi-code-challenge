require_relative './site_structure'

module SiteFormat
  class SerpApiChallenge < SiteStructure
    def initialize(url: nil, result_path: nil, generate_file: true)
      @url = url
      @result_path = result_path

      @base_url = 'https://www.google.com'
      @element_css = 'div.MiPcId.klitem-tr.mlo-c'
      @name_css = 'div.kltat'
      @extensions_css = 'div.ellip.klmeta'
      @link_css = 'a.klitem'
      @image_css = 'img.rISBZc.M4dUYb'
      @doc_html = nil
      @generate_file = generate_file
    end

    def get_name_from_element(element)
      name = ''
      element.at_css(@name_css).children.each do |child|
        name += child.text
      end
      return nil if name.empty?

      name.strip
    end

    def get_image_from_element(element)
      image_element = element.at_css(@image_css)

      return nil if image_element.nil?

      id = image_element.attribute('id').value
      regex = /\(function\(\)\{var s='((?:(?!\(function\(\)\{var s=).)*?)';var ii=\['#{id}'\];/

      matches = @doc_html.scan(regex)

      if matches.empty?
        image_element['src']
      else
        matches.first.first.gsub('\\x3d', '')
      end
    end
  end
end
