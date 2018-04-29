RSpec.describe DocxAnon do

  describe(".clean") do

    DocxAnon.configure { |c| c.output_dir = "/tmp/docx_anon" }

    context "given a source file with metadata" do
      before { described_class.clean(file) }
      let(:file) {"spec/fixtures/out_of_the_box_double_spaced.docx"}
      let(:orig_meta_data) {
        e = Exiftool.new(file)
        e.to_hash
      }

      subject(:meta_data) {
        e = Exiftool.new("#{DocxAnon.config.output_dir}/sanitized/out_of_the_box_double_spaced.docx")
        e.to_hash
      }

      it "removes Company field" do
        expect(orig_meta_data[:company]).to eq("Indiana University")
        expect(meta_data[:company]).to eq("")
      end
    end

    context "given a source file with metadata" do
      before(:all) do
        `rm -rf #{DocxAnon.config.output_dir}`
        described_class.clean("spec/fixtures/word_2010_comments.docx")
      end

      subject(:meta_data) {
        e = Exiftool.new("#{DocxAnon.config.output_dir}/sanitized/word_2010_comments.docx")
        e.to_hash
      }

      it "removes creator field" do
        expect(meta_data[:creator]).to be_falsy
      end

      it "removes LastModifiedBy field" do
        expect(meta_data[:creator]).to be_falsy
      end

    end

    context "given a file with comments" do

      before(:all) do
        `rm -rf #{DocxAnon.config.output_dir}`
        described_class.clean("spec/fixtures/word_with_comments.docx")
      end

      #
      subject(:xml) {
        document "#{DocxAnon.config.output_dir}/sanitized/word_with_comments.docx"
      }

      it "will retain the comment" do
        expect(
          xml.xpath("//w:comment").text
        ).to include("Problem with pronouns")

        expect(
          xml.xpath("//w:comment").text
        ).to include("Something wrong with quotations in this sentence")
      end

      it "will remove Author name" do
        # Make sure the source file had the expected Author
        original_xml_doc = document("spec/fixtures/word_with_comments.docx")
        expect(
          original_xml_doc.xpath("//w:comment").attr("author").text
        ).to eq("rob")

        expect(
          xml.xpath("//w:comment").attr("author")
        ).to be_nil
      end

      it "will remove Author initials" do
        original_xml_doc = document "spec/fixtures/word_with_comments.docx"
        expect(
          original_xml_doc.xpath("//w:comment").attr("initials").text
        ).to eq("r")

        expect(
          xml.xpath("//w:comment").attr("initials")
        ).to be_nil
      end
    end

    context "given you want to specify where the file is written" do

      let(:file) {"spec/fixtures/out_of_the_box_double_spaced.docx"}

      let(:file_path) {
        "/tmp/#{Time.now.strftime("%Y-%m-%d-%T")}"
      }

      subject {
        described_class.clean(file, file_path: file_path)
        File.exists?(file_path)
      }
      it { is_expected.to be(true) }
    end

    context "given a file without a company field" do
      let(:file) {"spec/fixtures/without_company.docx"}
      let(:file_path) { "/tmp/#{Time.now.strftime("%Y-%m-%d-%T")}" }
      subject {
        described_class.clean(file, file_path: file_path)
        File.exists?(file_path)
      }
      it { is_expected.to be(true) }
    end

    context "given you want to disable the comments sanitizer" do
      before do
        DocxAnon.configure { |c| c.disabled_sanitizers = [ "word/comments.xml" ] }
      end
      subject(:xml) {
        sanitized_path = described_class.clean("spec/fixtures/word_with_comments.docx")
        document(sanitized_path)
      }
      it "lets you disable sanitizers" do
        expect( xml.xpath("//w:comment").attr("author").text ).to eq("rob")
      end
    end

  end

  def document(path)
    zip = Zip::File.open(path)
    comments_entry = zip.entries.find { |entry|
                       entry.name == "word/comments.xml"
                     }
    document = Nokogiri::XML(comments_entry.get_input_stream.read)
    zip.close
    document
  end

end
