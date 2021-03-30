require 'spec_helper'

describe(JekyllJsConverter) do
  let(:site) do
    make_site({ 'theme' => 'minima' })
  end

  context 'Jekyll::Theme' do
    it 'gets javascript_path method' do
      expect(site.theme.respond_to?(:javascript_path)).to be_truthy
    end
  end
end
