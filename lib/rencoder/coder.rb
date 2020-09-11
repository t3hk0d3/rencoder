# frozen_string_literal: true

module Rencoder
  # Rencode format encoder/decoder class
  class Coder
    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    include Rencoder::Encoder
    include Rencoder::Decoder
  end
end
