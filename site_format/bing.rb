require_relative './site_structure'

module SiteFormat
  class Bing < SiteStructure
    def initialize(url: nil, result_path: nil, generate_file: true)
      @url = url
      @result_path = result_path

      @base_url = 'https://www.bing.com'
      @element_css = 'div.card'
      @name_css = 'div.tit'
      @extensions_css = 'div.subtit'
      @link_css = 'a.cardToggle'
      @image_css = 'img.rms_img'
      @doc_html = nil
      @generate_file = generate_file
    end

    def wait_for_page_load
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      wait.until { driver.execute_script('return document.readyState') == 'complete' }
      wait.until { driver.find_elements(css: @element_css).any? }
    end
  end
end
