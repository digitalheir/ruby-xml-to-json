# XML to JSON
This Ruby gem adds a `to_hash` and `to_json` method to Nokogiri XML nodes, allowing us to serialize arbitrary XML nodes to JSON.

This gem also picks up attributes, processing instructions and doctype declarations. The result is wordy, but complete.

As an added bonus, line numbers are included where possible.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xml-to-json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xml-to-json

## Usage

```ruby
include 'xml/to/json'

xml_string = STR_XML = <<-EOS
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

xml = Nokogiri::XML STR_XML
puts JSON.pretty_generate(xml.root) # Use xml for information about the document, like DTD and stuff
```

produces

```json
{
  "type": "element",
  "name": "myRoot",
  "attributes": [
    {
      "type": "attribute",
      "name": "id",
      "content": "root",
      "line": 17,
      "namespace": {
        "href": "http://www.w3.org/XML/1998/namespace",
        "prefix": "xml"
      }
    },
    {
      "type": "attribute",
      "name": "lang",
      "content": "en",
      "line": 17,
      "namespace": {
        "href": "http://www.w3.org/XML/1998/namespace",
        "prefix": "xml"
      }
    }
  ],
  "line": 17,
  "children": [
    {
      "type": "text",
      "content": "\n                             some text\n                             ",
      "line": 19
    },
    {
      "type": "comment",
      "content": "\n                             In comments we can use ]]>\n                             <\n                             &,\n                       ',\n                       and \",\n                       but %MyParamEntity; will not be expanded",
      "line": 25
    },
    {
      "type": "text",
      "content": "\n                             ",
      "line": 26
    },
    {
      "type": "cdata",
      "name": "#cdata-section",
      "content": "\n                             Character Data block <!-- <,\n                       & ' \" -->  *and* %MyParamEntity;\n                             ",
      "line": 26
    },
    {
      "type": "text",
      "content": "\n                             ",
      "line": 30
    },
    {
      "type": "pi",
      "name": "linebreak",
      "line": 30
    },
    {
      "type": "text",
      "content": "\n                             ",
      "line": 31
    },
    {
      "type": "element",
      "name": "deeper",
      "attributes": [
        {
          "type": "attribute",
          "name": "how-deep",
          "content": "very-deep",
          "line": 31
        }
      ],
      "line": 31,
      "namespace": {
        "href": "lol://some-namespace"
      },
      "children": [
        {
          "type": "text",
          "content": "☠☠☠randomtext☠☠☠\n                             ",
          "line": 32
        },
        {
          "type": "element",
          "name": "even",
          "attributes": [
            {
              "type": "attribute",
              "name": "my-attr",
              "content": "just an attribute",
              "line": 34,
              "namespace": {
                "href": "lol://my.name.space/",
                "prefix": "lol"
              }
            },
            {
              "type": "attribute",
              "name": "deeper",
              "content": "true",
              "line": 34
            }
          ],
          "line": 34,
          "namespace": {
            "href": "lol://some-namespace"
          },
          "children": [
            {
              "type": "text",
              "content": "&",
              "line": 34
            }
          ]
        }
      ]
    },
    {
      "type": "text",
      "content": "\n                       ",
      "line": 35
    }
  ]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/digitalheir/ruby-xml-to-json. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

