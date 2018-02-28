module DocxAnon
  module Sanitizers
    module Core

      FILE_HANDLER = "docProps/core.xml"

      def self.call(entry)
        puts "SANITIZING #{entry.name}" if DocxAnon.config.verbose
        doc = Nokogiri::XML(entry.get_input_stream.read)
        doc.search("//cp:lastModifiedBy").remove
        doc.search("//dc:creator").remove
        doc.to_xml
      end

    end
  end
end
