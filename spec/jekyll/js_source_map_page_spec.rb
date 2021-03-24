require 'spec_helper'

describe(Jekyll::JsSourceMapPage) do
  let(:js_source_map_page) do
    site = Jekyll::Site.new(site_configuration)
    page = Jekyll::PageWithoutAFile.new(site, 'base', 'dir', 'name')
    Jekyll::JsSourceMapPage.new(page)
  end

  it 'can have its content set' do
    js_source_map_page.source_map('here is the content')
    expect(js_source_map_page.content).to eq('here is the content')
  end

  it 'gets proper ext' do
    expect(js_source_map_page.ext).to eq('.map')
  end

  it 'is an asset file' do
    expect(js_source_map_page.asset_file?).to be_truthy
  end

  it 'inspect shows class and name' do
    expect(js_source_map_page.inspect).to eq('#<Jekyll::JsSourceMapPage @name="name.js.map">')
  end
end
