require 'spec_helper'

describe(Jekyll::Converters::Js) do
  let(:content) do
    <<~JS
      //= import_directory some_vendor
      //= import some_file

      console.log('This file has been converted by jekyll-js-converter!')
    JS
  end

  let(:site) do
    make_site
  end

  def converter(overrides = {})
    js_converter_instance(site).dup.tap do |obj|
      obj.instance_variable_get(:@config)['javascript'] = overrides
    end
  end

  context('javascript_config') do
    it 'returns an empty hash' do
      expect(converter.javascript_config).to eq({})
    end

    it 'returns the given config' do
      expect(converter({ 'uglifier' => { 'harmony' => true } }).javascript_config).to eq({ :uglifier => { :harmony => true } })
    end
  end

  context('javascript_dir') do
    it 'returns the default' do
      expect(converter.javascript_dir).to eq('_javascript')
    end

    it 'returns the given config option' do
      expect(converter({ 'javascript_dir' => 'test' }).javascript_dir).to eq('test')
    end
  end

  context('load_paths') do
    it 'includes the _javascript dir' do
      expect(converter.load_paths).to include(/\/spec\/source\/_javascript$/)
    end

    it 'includes additional load_path config' do
      expect(converter({ 'load_paths' => ['vendors'] }).load_paths).to include(/\/spec\/source\/vendors$/)
    end
  end

  context('matches') do
    it 'returns true if ext is .js' do
      expect(converter.matches('.js')).to be_truthy
    end
    it 'returns false if ext is not .js' do
      expect(converter.matches('.css')).to be_falsey
    end
  end

  context('output_ext') do
    it 'returns .js' do
      expect(converter.output_ext).to eq('.js')
    end
  end

  context('safe?') do
    it 'returns jekyll safe option' do
      expect(converter.safe?).to be_falsey
      expect(js_converter_instance(make_site({ 'safe' => true })).safe?).to be true
    end
  end

  context('convert') do
    it 'import directive works' do
      expect(converter.convert(content)).to eq('console.log("included some file!"),console.log("This file has been converted by jekyll-js-converter!");')
    end

    it 'import_directory directive works' do
      expect(converter({ 'load_paths' => ['vendors'] }).convert(content)).to eq('console.log("included a vendor file!"),console.log("included some file!"),console.log("This file has been converted by jekyll-js-converter!");')
    end
  end
end
