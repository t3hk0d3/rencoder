# frozen_string_literal: true

module Rencoder
  # Rencode format encoder module
  module Encoder
    class EncodingError < StandardError; end

    def encode(object)
      case object
      when String, Symbol then encode_string(object)
      when Integer then encode_integer(object)
      when Float then encode_float(object)
      when TrueClass, FalseClass then encode_boolean(object)
      when NilClass then encode_nil(object)
      when Array then encode_array(object)
      when Hash then encode_hash(object)
      else
        raise EncodingError, "Unable to serialize '#{object.class}'"
      end
    end

    def encode_integer(object) # rubocop:disable Metrics/AbcSize
      case object
      when (0...INT_POS_FIXED_COUNT) # predefined positive intger
        [INT_POS_FIXED_START + object].pack('C')
      when (-INT_NEG_FIXED_COUNT...0) # predefined negative integer
        [INT_NEG_FIXED_START - 1 - object].pack('C')
      when (-128...128)
        [CHR_INT1, object].pack('Cc') # 8-bit signed
      when (-32_768...32_768)
        [CHR_INT2, object].pack('Cs>') # 16-bit signed
      when (-2_147_483_648...2_147_483_648)
        [CHR_INT4, object].pack('Cl>') # 32-bit signed
      when (-9_223_372_036_854_775_808...9_223_372_036_854_775_808)
        [CHR_INT8, object].pack('Cq>') # 64-bit signed
      else # encode as ASCII
        bytes = object.to_s.bytes

        raise EncodingError, "Unable to serialize Integer #{object} due to overflow" if bytes.size >= MAX_INT_LENGTH

        [CHR_INT, *bytes, CHR_TERM].pack('C*')
      end
    end

    def encode_float(object)
      # Always serialize floats as 64-bit, since single-precision serialization is a poo
      # If you don't believe me try this:
      #
      # [1.1].pack('F').unpack('F').first
      # => 1.100000023841858
      #
      if options[:float32] # not recommended
        [CHR_FLOAT32, object].pack('Cg')
      else
        [CHR_FLOAT64, object].pack('CG')
      end
    end

    def encode_string(object)
      bytes = object.to_s

      if bytes.size < STR_FIXED_COUNT
        (STR_FIXED_START + bytes.size).chr + bytes
      else
        "#{bytes.bytesize}:#{bytes}"
      end
    end

    def encode_boolean(object)
      [object ? CHR_TRUE : CHR_FALSE].pack('C')
    end

    def encode_array(object)
      array_data = object.map { |item| encode(item) }.join

      if object.size < LIST_FIXED_COUNT
        (LIST_FIXED_START + object.size).chr + array_data
      else
        CHR_LIST.chr + array_data + CHR_TERM.chr
      end
    end

    def encode_hash(object)
      hash_data = object.map { |key, value| encode(key) + encode(value) }.join

      if object.size < DICT_FIXED_COUNT
        (DICT_FIXED_START + object.size).chr + hash_data
      else
        CHR_DICT.chr + hash_data + CHR_TERM.chr
      end
    end

    def encode_nil(_object)
      [CHR_NONE].pack('C')
    end
  end
end
