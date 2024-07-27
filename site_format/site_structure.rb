require 'cgi'
require 'json'
require 'nokogiri'
require 'selenium-webdriver'

module SiteFormat
  class SiteStructure
    def initialize(url: nil, result_path: nil, generate_file: true)
      @url = url
      @result_path = result_path

      @base_url = nil
      @element_css = nil
      @name_css = nil
      @extensions_css = nil
      @link_css = nil
      @image_css = nil
      @doc_html = nil
      @generate_file = generate_file
      raise('Must set @base_url, @element_css, @name_css, @extensions_css, @link_css, @image_css, @doc_html')
    end

    def generate_json
      begin
        result = create_result

        if @generate_file
          File.open(@result_path, 'w') do |f|
            f.write(JSON.dump(result))
            puts "JSON file from #{@url}\nCreated at: #{@result_path}\n\n"
          end
        end

        result.to_json
      rescue StandardError => e
        puts "An error occurred: #{e.class} - #{e.message}"
      end
    end

    def create_result
      elements = get_elements
      result = []

      elements.each do |element|
        hash = {}

        hash[:name] = get_name_from_element(element) unless @name_css.nil?
        hash[:extensions] = get_extensions_from_element(element) unless @extensions_css.nil?
        hash[:link] = get_link_from_element(element) unless @link_css.nil?
        hash[:image] = get_image_from_element(element) unless @image_css.nil?

        result << hash
      end

      { 'result': result }
    end

    def get_elements
      get_page_in_driver

      @doc_html = CGI.unescapeHTML(driver.page_source)
      doc = Nokogiri::HTML(@doc_html)

      elements = doc.css(@element_css)
    ensure
      driver.quit
    end

    def get_page_in_driver
      driver.manage.window.maximize
      driver.get(@url)
      wait_for_page_load
    end

    def wait_for_page_load
      wait = Selenium::WebDriver::Wait.new(timeout: 10)
      wait.until { driver.execute_script('return document.readyState') == 'complete' }
    end

    def get_name_from_element(element)
      name_element = element.at_css(@name_css)
      return nil if name_element.nil?

      name_element.text.strip
    end

    def get_extensions_from_element(element)
      extensions_element = element.at_css(@extensions_css)
      return nil if extensions_element.nil?

      [extensions_element.text.strip]
    end

    def get_link_from_element(element)
      link_element = element.at_css(@link_css)
      return nil if link_element.nil?

      "#{@base_url}#{link_element['href']}"
    end

    def get_image_from_element(element)
      image_element = element.at_css(@image_css)

      return nil if image_element.nil?

      image_element['src']
    end

    def driver
      @driver ||= create_driver
    end

    def create_driver
      driver_options = Selenium::WebDriver::Options.chrome(args: ['--headless=new'])
      driver = Selenium::WebDriver.for :chrome, options: driver_options
      driver
    end
  end
end
