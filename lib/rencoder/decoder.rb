module Rencoder
  module Decoder
    INTEGER_DECODING_MAP = {
      CHR_INT1 => [1, 'c'],
      CHR_INT2 => [2, 's>'],
      CHR_INT4 => [4, 'l>'],
      CHR_INT8 => [8, 'q>']
    }

    def decode(buffer)
      buffer = StringIO.new(buffer) unless buffer.respond_to?(:read) # IO object

      type = buffer.readbyte

      case type
      when STR_HEADER, STR_FIXED
        decode_string(buffer, type)
      when CHR_INT, CHR_INT1, CHR_INT2, CHR_INT4, CHR_INT8, INT_POS_FIXED, INT_NEG_FIXED
        decode_integer(buffer, type)
      when CHR_FLOAT32, CHR_FLOAT64
        decode_float(buffer, type)
      when CHR_TRUE, CHR_FALSE
        decode_boolean(buffer, type)
      when CHR_NONE
        decode_nil(buffer, type)
      when CHR_LIST, LIST_FIXED
        decode_array(buffer, type)
      when CHR_DICT, DICT_FIXED
        decode_hash(buffer, type)
      when CHR_TERM
        :rencode_term
      else
        raise "Unknown type '#{type.inspect}'"
      end
    end

    private

    def decode_integer(buffer, type)
      case type
      when CHR_INT
        read_till(buffer).to_i
      when CHR_INT1, CHR_INT2, CHR_INT4, CHR_INT8
        size, template = INTEGER_DECODING_MAP[type]

        buffer.read(size).unpack(template).first
      when INT_POS_FIXED
        type - INT_POS_FIXED_START
      when INT_NEG_FIXED
        -1-(type - INT_NEG_FIXED_START)
      end
    end

    def decode_float(buffer, type)
      case type
      when CHR_FLOAT32
        buffer.read(4).unpack('g')
      when CHR_FLOAT64
        buffer.read(8).unpack('G')
      end.first
    end

    def decode_string(buffer, type)
      case type
      when STR_FIXED
        buffer.read(type - STR_FIXED_START)
      when STR_HEADER
        length = type.chr + read_till(buffer, ':')

        buffer.read(length.to_i)
      end
    end

    def decode_boolean(buffer, type)
      type == CHR_TRUE
    end

    def decode_array(buffer, type)
      case type
      when CHR_LIST
        result = []

        while (item = decode(buffer)) != :rencode_term
          result << item
        end

        result
      when LIST_FIXED
        size = type - LIST_FIXED_START

        size.times.map do |i|
          decode(buffer)
        end
      end
    end

    def decode_hash(buffer, type)
      case type
      when CHR_DICT
        result = {}

        while (key = decode(buffer)) != :rencode_term
          result[key] = decode(buffer)
        end

        result
      when DICT_FIXED
        size = type - DICT_FIXED_START

        Hash[size.times.map { [decode(buffer), decode(buffer)] }]
      end
    end

    def decode_nil(buffer, type)
      nil
    end

    def read_till(buffer, separator = CHR_TERM.chr)
      buffer.gets(separator).chomp(separator)
    end
  end
end
