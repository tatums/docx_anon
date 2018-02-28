module DocxAnon
  module Sanitizers
    module Comments

      FILE_HANDLER = "word/comments.xml"

      def self.call(entry)
        puts "SANITIZING #{entry.name}" if DocxAnon.config.verbose
        doc = Nokogiri::XML(entry.get_input_stream.read)
        Array(doc.xpath("//w:comment")).each do |elem|
          elem.remove_attribute("author")
          elem.remove_attribute("initials")
        end
        doc.to_xml
      end
    end
  end
end
