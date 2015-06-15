# noinspection RubyResolve
require 'spec_helper'

describe Xml::To::Json do
  it 'has a version number' do
    expect(Xml::To::Json::VERSION).not_to be nil
  end

  it 'generate a to_hash method on Nokogiri::XML::Node' do
    expect(Nokogiri::XML::Node.method_defined? :to_json).to eq(true)
  end

  it 'generate JSON as in the example' do
    expect(JSON.pretty_generate(Nokogiri::XML(STR_XML)).length > 0).to eq(true)
    expect(JSON.pretty_generate(Nokogiri::XML(STR_XML)).length).to eq(STR_JSON.length)
  end
end
