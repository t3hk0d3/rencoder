require 'spec_helper'

describe Rencoder::Encoder do
  include_context 'serialization_values'

  subject { Rencoder::Coder.new }

  describe '#encode' do
    it 'encode string' do
      expect(subject.encode('Test')).to eq(serialized_string)
    end

    it 'encode symbol' do
      expect(subject.encode(:test)).to eq(serialized_symbol)
    end

    it 'encode integer' do
      expect(subject.encode(100)).to eq(serialized_integer)
    end

    it 'encode float' do
      expect(subject.encode(100.0001)).to eq(serialized_float)
    end

    it 'encode boolean' do
      expect(subject.encode(false)).to eq(serialized_false)
    end

    it 'encode nil' do
      expect(subject.encode(nil)).to eq(serialized_nil)
    end

    it 'encode array' do
      expect(subject.encode(["Test", 100, 100.0001, nil])).to eq(serialized_array)
    end

    it 'encode hash' do
      expect(subject.encode({ test: 123, hello: 'world' })).to eq(serialized_hash)
    end

    it 'raise exception for non-serializable object' do
      expect { subject.encode(Object.new) }.to raise_error(Rencoder::Encoder::EncodingError)
    end
  end

  describe '#encode_string' do
    it 'encode small strings' do
      expect(subject.encode_string('Test')).to eq(serialized_string)
    end

    it 'encode big strings' do
      expect(subject.encode_string('a' * 100)).to eq(serialized_long_string)
    end
  end

  describe '#encode_integer' do
    it 'encode small positive number' do
      expect(subject.encode_integer(10)).to eq(serialized_positive_integer)
    end

    it 'encode small negative number' do
      expect(subject.encode_integer(-10)).to eq(serialized_negative_integer)
    end

    it 'encode 8-bit integer' do
      expect(subject.encode_integer(100)).to eq(serialized_8bit_integer)
    end

    it 'encode 16-bit integer' do
      expect(subject.encode_integer(5000)).to eq(serialized_16bit_integer)
    end

    it 'encode 32-bit integer' do
      expect(subject.encode_integer(50000)).to eq(serialized_32bit_integer)
    end

    it 'encode 64-bit integer' do
      expect(subject.encode_integer(5000000000)).to eq(serialized_64bit_integer)
    end

    it 'encode big integer as ascii' do
      expect(subject.encode_integer(50000000000000000000)).to eq(serialized_big_integer)
    end

    it 'raise error for super-big integers' do
      expect do
        subject.encode_integer(128.times.map { '9' }.join.to_i)
      end.to raise_error(Rencoder::Encoder::EncodingError)
    end
  end

  describe '#encode_float' do
    it 'encode 64-bit float' do
      expect(subject.encode_float(100.0001)).to eq(serialized_float)
    end
  end

  describe '#encode_boolean' do
    it 'encode true boolean' do
      expect(subject.encode_boolean(true)).to eq(serialized_true)
    end

    it 'encode false boolean' do
      expect(subject.encode_boolean(false)).to eq(serialized_false)
    end
  end

  describe '#encode_nil' do
    it 'encode nil' do
      expect(subject.encode_nil(nil)).to eq(serialized_nil)
    end
  end

  describe '#encode_array' do
    it 'encode small-sized array' do
      expect(subject.encode_array(["Test", 100, 100.0001, nil])).to eq(serialized_array)
    end

    it 'encode big-sized array' do
      expect(subject.encode_array(100.times.to_a)).to eq(serialized_big_array)
    end
  end

  describe '#encode_hash' do
    it 'encode small-sized hash' do
      expect(subject.encode_hash({ test: 123, hello: 'world' })).to eq(serialized_hash)
    end

    it 'encode big-sized hash' do
      hash = Hash[100.times.map { |i| [i, i.chr] }]

      expect(subject.encode_hash(hash)).to eq(serialized_big_hash)
    end
  end
end
