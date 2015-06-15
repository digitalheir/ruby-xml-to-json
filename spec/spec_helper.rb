$LOAD_PATH.unshift File.expand_path('../../lib',
                                    __FILE__)
require 'xml/to/json'

STR_XML = <<-EOS
<!DOCTYPE dtd-name [
   <!ENTITY entity_1 "Has been ëxpÄnded">
   <!ENTITY entity_system SYSTEM "mt_cook1.jpg">
   <!ENTITY name_public PUBLIC "entity_public_id" "URI">
   <!NOTATION notation-system SYSTEM "notation-id-system">
   <!NOTATION NoTaTiOn-PuBLiC PUBLIC "notation-id-public">
   <!ELEMENT div1 (head,
(p | list | note)*,
div2*)>
   <!ELEMENT photo (hello)>
   <!ATTLIST photo some-attribute CDATA #REQUIRED>
   <!ATTLIST
     photo photo_att ENTITY #IMPLIED
     photo NOTATION (notation-system | NoTaTiOn-PuBLiC | notation-system) #IMPLIED>
]>

<myRoot xml:id="root" xml:lang="en">
      some text
      <!--
      In comments we can use ]]>
      <
      &,
',
and ",
but %MyParamEntity; will not be expanded-->
      <![CDATA[
      Character Data block <!-- <,
& ' " -->  *and* %MyParamEntity;
      ]]>
      <?linebreak?>
      <deeper xmlns="lol://some-namespace" how-deep="very-deep">☠☠☠randomtext☠☠☠
      <even
        lol:my-attr="just an attribute"
        xmlns:lol=\'lol://my.name.space/\' deeper="true">&amp;</even></deeper>
</myRoot>
EOS

FULL_DOC_HASH = {:type => :document, :children => [{:type => :dtd, :elements => [{:type => :element_declaration, :name => 'div1', :element_type => 4, :content => {:occur => :once, :type => :seq, :children => [{:name => 'head', :occur => :once, :type => :element}, {:occur => :once, :type => :seq, :children => [{:occur => :mult, :type => :or, :children => [{:name => 'p', :occur => :once, :type => :element}, {:occur => :once, :type => :or, :children => [{:name => 'list', :occur => :once, :type => :element}, {:name => 'note', :occur => :once, :type => :element}]}]}, {:name => 'div2', :occur => :mult, :type => :element}]}]}}, {:type => :element_declaration, :name => 'photo', :element_type => 4, :content => {:name => 'hello', :occur => :once, :type => :element}, :attributes => [{:type => :attribute_declaration, :name => 'some-attribute', :attribute_type => 1, :enumeration => []}, {:type => :attribute_declaration, :name => 'photo_att', :attribute_type => 5, :enumeration => []}, {:type => :attribute_declaration, :name => 'photo', :attribute_type => 10, :enumeration => %w(notation-system NoTaTiOn-PuBLiC)}]}], :entities => [{:type => :entity_declaration, :original_content => 'Has been ëxpÄnded', :name => 'entity_1', :entity_type => 1, :content => 'Has been ëxpÄnded'}, {:type => :entity_declaration, :name => 'name_public', :external_id => 'entity_public_id', :entity_type => 2, :system_id => 'URI'}, {:type => :entity_declaration, :name => 'entity_system', :entity_type => 2, :system_id => 'mt_cook1.jpg'}], :notations => [{:name => 'notation-system', :system_id => 'notation-id-system'}, {:name => 'NoTaTiOn-PuBLiC', :public_id => 'notation-id-public'}], :name => 'dtd-name'}, {:type => :element, :name => 'myRoot', :attributes => [{:type => :attribute, :name => 'id', :content => 'root', :line => 17, :namespace => {:href => 'http://www.w3.org/XML/1998/namespace', :prefix => 'xml'}}, {:type => :attribute, :name => 'lang', :content => 'en', :line => 17, :namespace => {:href => 'http://www.w3.org/XML/1998/namespace', :prefix => 'xml'}}], :line => 17, :children => [{:type => :text, :content => "\n      some text\n      ", :line => 19}, {:type => :comment, :content => "\n      In comments we can use ]]>\n      <\n      &,\n',\nand \",\nbut %MyParamEntity; will not be expanded", :line => 25}, {:type => :text, :content => "\n      ", :line => 26}, {:type => :cdata, :name => '#cdata-section', :content => "\n      Character Data block <!-- <,\n& ' \" -->  *and* %MyParamEntity;\n      ", :line => 26}, {:type => :text, :content => "\n      ", :line => 30}, {:type => :pi, :name => 'linebreak', :line => 30}, {:type => :text, :content => "\n      ", :line => 31}, {:type => :element, :name => 'deeper', :attributes => [{:type => :attribute, :name => 'how-deep', :content => 'very-deep', :line => 31}], :line => 31, :namespace => {:href => 'lol://some-namespace'}, :children => [{:type => :text, :content => "☠☠☠randomtext☠☠☠\n      ", :line => 32}, {:type => :element, :name => 'even', :attributes => [{:type => :attribute, :name => 'my-attr', :content => 'just an attribute', :line => 34, :namespace => {:href => 'lol://my.name.space/', :prefix => 'lol'}}, {:type => :attribute, :name => 'deeper', :content => 'true', :line => 34}], :line => 34, :namespace => {:href => 'lol://some-namespace'}, :children => [{:type => :text, :content => '&', :line => 34}]}]}, {:type => :text, :content => "\n", :line => 35}]}]}
STR_JSON = JSON.pretty_generate(FULL_DOC_HASH)


