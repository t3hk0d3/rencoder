require 'rencoder/version'

module Rencoder
  # Rencoder Constants
  MAX_INT_LENGTH = 64

  # Type constants
  CHR_LIST    = 59
  CHR_DICT    = 60
  CHR_INT     = 61
  CHR_INT1    = 62
  CHR_INT2    = 63
  CHR_INT4    = 64
  CHR_INT8    = 65
  CHR_FLOAT32 = 66
  CHR_FLOAT64 = 44
  CHR_TRUE    = 67
  CHR_FALSE   = 68
  CHR_NONE    = 69
  CHR_TERM    = 127

  # Dictionaries with length embedded in typecode.
  DICT_FIXED_START = 102
  DICT_FIXED_COUNT = 25
  DICT_FIXED = (DICT_FIXED_START...DICT_FIXED_START + DICT_FIXED_COUNT)

  # Positive integers with value embedded in typecode.
  INT_POS_FIXED_START = 0
  INT_POS_FIXED_COUNT = 44
  INT_POS_FIXED = (INT_POS_FIXED_START...INT_POS_FIXED_START + INT_POS_FIXED_COUNT)

  # Negative integers with value embedded in typecode.
  INT_NEG_FIXED_START = 70
  INT_NEG_FIXED_COUNT = 32
  INT_NEG_FIXED = (INT_NEG_FIXED_START...INT_NEG_FIXED_START + INT_NEG_FIXED_COUNT)

  # String length header
  STR_HEADER = ('0'.ord..'9'.ord)

  # Strings with length embedded in typecode.
  STR_FIXED_START = 128
  STR_FIXED_COUNT = 64
  STR_FIXED = (STR_FIXED_START...STR_FIXED_START + STR_FIXED_COUNT)

  # Lists with length embedded in typecode.
  LIST_FIXED_START = STR_FIXED_START+STR_FIXED_COUNT
  LIST_FIXED_COUNT = 64
  LIST_FIXED = (LIST_FIXED_START...LIST_FIXED_START + LIST_FIXED_COUNT)

  require_relative 'rencoder/encoder'
  require_relative 'rencoder/decoder'
  require_relative 'rencoder/coder'

  def load(buffer, options = {})
    Rencoder::Coder.new(options).decode(buffer)
  end

  def dump(object, options = {})
    Rencoder::Coder.new(options).encode(object)
  end

  module_function :dump, :load
end
