require 'spec_helper'

describe Rencoder::Decoder do
  include_context 'serialization_values'

  subject { Rencoder::Coder.new }

  describe '#decode' do
    it 'raises EOFError on EOF' do
      expect {
        subject.decode(StringIO.new)
      }.to raise_error(EOFError)
    end

    describe 'string' do
      it 'decode string' do
        expect(subject.decode(serialized_string)).to eq('Test')
      end

      it 'decode empty string' do
        expect(subject.decode(serialized_empty_string)).to eq('')
      end

      it 'decode maximum embedded-length type string' do
        expect(subject.decode(serialized_63byte_string)).to eq('a' * 63)
      end

      it 'decode long string' do
        expect(subject.decode(serialized_long_string)).to eq('a' * 100)
      end
    end

    describe 'integer' do
      it 'decode positive small integer' do
        expect(subject.decode(serialized_positive_integer)).to eq(10)
      end

      it 'decode negative small integer' do
        expect(subject.decode(serialized_negative_integer)).to eq(-10)
      end

      it 'decode 8-bit integer' do
        expect(subject.decode(serialized_8bit_integer)).to eq(100)
      end

      it 'decode 16-bit integer' do
        expect(subject.decode(serialized_16bit_integer)).to eq(5000)
      end

      it 'decode 32-bit integer' do
        expect(subject.decode(serialized_32bit_integer)).to eq(50000)
      end

      it 'decode 64-bit integer' do
        expect(subject.decode(serialized_64bit_integer)).to eq(5000000000)
      end

      it 'decode big ascii integer' do
        expect(subject.decode(serialized_big_integer)).to eq(50000000000000000000)
      end
    end

    describe 'float' do
      it 'decode 32-bit float' do
        expect(subject.decode(serialized_32bit_float)).to eq(100.0)
      end

      it 'decode 64-bit float' do
        expect(subject.decode(serialized_float)).to eq(100.0001)
      end
    end

    describe 'boolean' do
      it 'decode true boolean' do
        expect(subject.decode(serialized_true)).to eq(true)
      end

      it 'decode false boolean' do
        expect(subject.decode(serialized_false)).to eq(false)
      end
    end

    describe 'nil' do
      it 'decode nil' do
        expect(subject.decode(serialized_nil)).to eq(nil)
      end
    end

    describe 'array' do
      it 'decode empty array' do
        expect(subject.decode(serialized_empty_array)).to eq([])
      end

      it 'decode small array' do
        expect(subject.decode(serialized_array)).to eq(['Test', 100, 100.0001, nil])
      end

      it 'decode maximum embedded length type array' do
        expect(subject.decode(serialized_63_element_array)).to eq(63.times.to_a)
      end

      it 'decode big array' do
        expect(subject.decode(serialized_big_array)).to eq(100.times.to_a)
      end
    end

    describe 'hash' do
      it 'decode small hash' do
        expect(subject.decode(serialized_hash)).to eq({ 'test' => 123, 'hello' => 'world' })
      end

      it 'decode big hash' do
        expect(subject.decode(serialized_big_hash)).to eq(Hash[100.times.map { |i| [i, i.chr] }])
      end
    end
  end
end
