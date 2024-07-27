require 'spec_helper'

RSpec.describe SiteFormat::Bing do
  let!(:name) { Faker::Name.name }
  let!(:date) { Faker::Date.between(from: '1900-01-01', to: '2100-12-31').year.to_s }
  let!(:link) { URI.parse(Faker::Internet.url).path }
  let!(:img_link) { Faker::Internet.url }
  let!(:img_link_id) { Faker::Number.unique.number(digits: 2) }
  let!(:template_path) { File.expand_path('../../support/templates/bing_template.html.erb', __FILE__) }
  let!(:base_url) { 'https://www.bing.com' }

  let!(:params) do
    {
      name: name,
      date: date,
      link: link,
      img_link: img_link,
      img_link_id: img_link_id
    }
  end

  subject do
    described_class.new(
      url: 'fake_test_url',
      generate_file: false
    ).generate_json
  end

  before do
    allow_any_instance_of(described_class).to receive(:get_page_in_driver).and_return(nil)
    allow_any_instance_of(Selenium::WebDriver::Driver).to receive(:page_source).and_return(render_template(template_path, params))
  end

  it 'returns correct name' do
    result = subject
    expect(JSON.parse(result)['result'].first['name']).to eq(name)
  end

  it 'returns correct extensions' do
    result = subject
    expect(JSON.parse(result)['result'].first['extensions']).to eq([date])
  end

  it 'returns correct link' do
    result = subject
    expect(JSON.parse(result)['result'].first['link']).to eq("#{base_url}#{link}")
  end

  it 'returns correct img src address' do
    result = subject
    expect(JSON.parse(result)['result'].first['image']).to eq(img_link)
  end

  context 'when generate file is set to true' do
    subject do
      described_class.new(
        url: 'fake_test_url',
        result_path: result_path
      ).generate_json
    end

    after do
      File.delete(result_path) if File.exist?(result_path)
    end

    it 'creates a json file at result_path' do
      subject
      expect(File.exist?(result_path)).to be true
    end
  end
end
