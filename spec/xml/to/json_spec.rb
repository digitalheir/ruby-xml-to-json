# noinspection RubyResolve
require 'spec_helper'

describe Xml::To::Json do
  XML = Nokogiri::XML(STR_XML)

  it 'has a version number' do
    expect(Xml::To::Json::VERSION).not_to be nil
  end

  it 'generate a to_hash method on Nokogiri::XML::Node' do
    expect(Nokogiri::XML::Node.method_defined? :to_json).to eq(true)
  end

  it 'generate JSON as in the example' do
    expect(JSON.pretty_generate(XML).length > 0).to eq(true)
    expect(JSON.pretty_generate(XML).length).to eq(STR_JSON.length)
  end

  it 'handles notations' do
    notation = Nokogiri::XML::Notation.new(name='name',public_id='pub_id',system_id='syst_id')
    expect(notation.to_json).to eq('{"name":"name","public_id":"pub_id","system_id":"syst_id"}')
  end

  it 'handles namespace' do
    node = Nokogiri::XML '<root xmlns:pref="schema://path" pref:attr= "attr-value">'
    namespace = node.root.attributes['attr'].namespace
    expect(namespace.to_json).to eq('{"href":"schema://path","prefix":"pref"}')
  end
  it 'handles ElementContent' do
    node = XML.children[0].elements['photo'].content
    expect(node.to_json).to eq('{"name":"hello","occur":"once","type":"element"}')
  end

end
