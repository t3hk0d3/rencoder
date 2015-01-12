module Rencoder
  class Coder
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    include Rencoder::Encoder
    include Rencoder::Decoder
  end
end
