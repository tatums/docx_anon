module DocxAnon
  module Sanitizers

    module App

      FILE_HANDLER = "docProps/app.xml"

      def self.call(entry)
        puts "SANITIZING #{entry.name}" if DocxAnon.config.verbose
        doc = Nokogiri::XML(entry.get_input_stream.read)
        element = doc.at_css("Company")
        if element
          element.inner_html = ""
        end
        doc.to_xml
      end
    end
  end
end
