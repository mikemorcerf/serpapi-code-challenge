require_relative './site_structure'

module SiteFormat
  class Google < SiteStructure
    def initialize(url: nil, result_path: nil, generate_file: true)
      @url = url
      @result_path = result_path

      @base_url = 'https://www.google.com'
      @element_css = 'div.iELo6'
      @name_css = 'div.pgNMRc'
      @extensions_css = 'div.cxzHyb'
      @link_css = 'a'
      @image_css = 'img.taFZJe'
      @doc_html = nil
      @generate_file = generate_file
    end
  end
end
