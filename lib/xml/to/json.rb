require 'xml/to/hash'
require 'xml/to/json/version'
require 'json'

module Xml
  # noinspection RubyClassModuleNamingConvention
  module To
    module Json

    end
  end
end

module Nokogiri
  module XML
    class Notation
      def to_json(*a)
        to_hash.to_json(*a)
      end
    end
    class Namespace
      def to_json(*a)
        to_hash.to_json(*a)
      end
    end
    class ElementContent
      def to_json(*a)
        to_hash.to_json(*a)
      end
    end
    class Node
      def to_json(*a)
        to_hash.to_json(*a)
      end
    end
  end
end
