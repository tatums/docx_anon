require 'zip'
require 'nokogiri'
require 'fileutils'
require "docx_anon/version"
require "docx_anon/config"
require "docx_anon/sanitizers/app"
require "docx_anon/sanitizers/core"
require "docx_anon/sanitizers/comments"
require "docx_anon/document"

module DocxAnon


  def self.clean(file, options={})
    Document.clean(file, options)
  end

end
