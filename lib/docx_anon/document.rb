module DocxAnon
  class Document

    # This lets each sanitizer tell us the files they handle and allow this library
    # to be easily extended.
    #
    # {
    #  "docProps/app.xml" => DocxAnon::Sanitizers::App,
    #  "word/comments.xml" => DocxAnon::Sanitizers::Comments
    # }
    #
    SANITIZERS = Hash[
      DocxAnon::Sanitizers.constants.map { |const|
        [ DocxAnon::Sanitizers.const_get(const).const_get("FILE_HANDLER"),
          DocxAnon::Sanitizers.const_get(const)
        ]
      }
    ]

    # Handles processing files that need no changes they pass right through
    #
    NOOP = Proc.new { |entry|
      entry.get_input_stream.read
    }

    def self.clean(file, options={})

      input_path = File.expand_path(file)
      dirname = File.dirname(file)

      base_dir = DocxAnon.config.output_dir || File.dirname(file)
      sanitized_dir = FileUtils.mkdir_p("#{base_dir}/sanitized")
      out = options.fetch(:file_path, "#{sanitized_dir.last}/#{File.basename(file)}")
      output_path = File.expand_path(out)


      puts "reading file from: #{input_path}" if DocxAnon.config.verbose
      puts "will write file to: #{output_path}" if DocxAnon.config.verbose

      @zip = Zip::File.open(file)
      buffer = Zip::OutputStream.write_buffer do |out|
                 @zip.entries.each do |entry|

                   out.put_next_entry(entry.name)
                   unless entry.ftype == :directory
                     sanitizer = enabled_sanitizers.fetch(entry.name, NOOP)
                     body = sanitizer.call(entry)
                     out.write(body)
                   end
                 end
               end

      File.open(output_path, "wb") { |f| f.write(buffer.string) }
      @zip.close

      output_path
    end

    private

    def self.enabled_sanitizers
      SANITIZERS.reject { |key,val|
        DocxAnon.config.disabled_sanitizers.include?(key)
      }
    end

  end
end
