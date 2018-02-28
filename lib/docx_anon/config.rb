module DocxAnon

  class Config
    attr_accessor :verbose, :output_dir

    def initialize
      @verbose = false
    end
  end


  class << self
    attr_writer :config
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end


end
