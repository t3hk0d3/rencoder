# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'rspec'
require 'rencoder'

require 'base64'

shared_context 'with serialization_values' do # rubocop:disable RSpec/MultipleMemoizedHelpers
  # Values encoded using original Python code

  # Integers
  # 100
  let(:serialized_integer) { '>d' }

  # 10
  let(:serialized_positive_integer) { "\n" }

  # -10
  let(:serialized_negative_integer) { 'O' }

  # 100
  let(:serialized_8bit_integer) { serialized_integer }

  # 5000
  let(:serialized_16bit_integer) { Base64.decode64('PxOI') }

  # 50000
  let(:serialized_32bit_integer) { Base64.decode64('QAAAw1A=') }

  # 5000000000
  let(:serialized_64bit_integer) { Base64.decode64('QQAAAAEqBfIA') }

  # 50000000000000000000
  let(:serialized_big_integer) { "=50000000000000000000\x7f" }

  # Strings
  # 'Test'
  let(:serialized_string) { Base64.decode64('hFRlc3Q=') }

  # :test (symbol)
  let(:serialized_symbol) { Base64.decode64('hHRlc3Q=') }

  # ''
  let(:serialized_empty_string) { Base64.decode64("gA==\n") }

  # maximum embedded-length string type ('a' * 63)
  let(:serialized_63byte_string) { "\xBF#{'a' * 63}" }

  # 'a' * 100
  let(:serialized_long_string) { "100:#{'a' * 100}" }

  # Booleans
  # true
  let(:serialized_true) { 67.chr }

  let(:serialized_false) { 68.chr }

  # Floats
  # 100.0001
  let(:serialized_float) { Base64.decode64('LEBZAAGjbi6y') }

  # 100.0001 (single-precision)
  let(:serialized_32bit_float) { Base64.decode64('QkLIAAA=') }

  # NULL
  let(:serialized_nil) { 69.chr }

  # Array
  # []
  let(:serialized_empty_array) { "\xC0" }

  # ["Test", 100, 100.0001, nil]
  let(:serialized_array) { Base64.decode64('xIRUZXN0PmQsQFkAAaNuLrJF') }

  # maximum embedded-length array type (63.times.to_a)
  let(:serialized_63_element_array) do
    Base64.decode64("/z4APgE+Aj4DPgQ+BT4GPgc+CD4JPgo+Cz4MPg0+Dj4PPhA+ET4SPhM+FD4V\nPhY+Fz4YPhk+Gj4bPhw+HT4ePh8+ID4hPiI+Iz4kPiU+Jj4nPig+KT4qPis+\nLD4tPi4+Lz4wPjE+Mj4zPjQ+NT42Pjc+OD45Pjo+Oz48Pj0+Pg==\n") # rubocop:disable Layout/LineLength
  end

  # big array (100.times.to_a)
  let(:serialized_big_array) do
    Base64.decode64('OwABAgMEBQYHCAkKCwwNDg8QERITFBUWFxgZGhscHR4fICEiIyQlJicoKSorPiw+LT4uPi8+MD4xPjI+Mz40PjU+Nj43Pjg+OT46Pjs+PD49Pj4+Pz5APkE+Qj5DPkQ+RT5GPkc+SD5JPko+Sz5MPk0+Tj5PPlA+UT5SPlM+VD5VPlY+Vz5YPlk+Wj5bPlw+XT5ePl8+YD5hPmI+Y38=') # rubocop:disable Layout/LineLength
  end

  # Hash
  # { test: 123, hello: "world" }
  let(:serialized_hash) { Base64.decode64('aIR0ZXN0PnuFaGVsbG+Fd29ybGQ=') }

  # big hash (Hash[100.times.map { |i| [i, i.chr] }])
  let(:serialized_big_hash) do
    Base64.decode64('PACBAAGBAQKBAgOBAwSBBAWBBQaBBgeBBwiBCAmBCQqBCguBCwyBDA2BDQ6BDg+BDxCBEBGBERKBEhOBExSBFBWBFRaBFheBFxiBGBmBGRqBGhuBGxyBHB2BHR6BHh+BHyCBICGBISKBIiOBIySBJCWBJSaBJieBJyiBKCmBKSqBKiuBKz4sgSw+LYEtPi6BLj4vgS8+MIEwPjGBMT4ygTI+M4EzPjSBND41gTU+NoE2PjeBNz44gTg+OYE5PjqBOj47gTs+PIE8Pj2BPT4+gT4+P4E/PkCBQD5BgUE+QoFCPkOBQz5EgUQ+RYFFPkaBRj5HgUc+SIFIPkmBST5KgUo+S4FLPkyBTD5NgU0+ToFOPk+BTz5QgVA+UYFRPlKBUj5TgVM+VIFUPlWBVT5WgVY+V4FXPliBWD5ZgVk+WoFaPluBWz5cgVw+XYFdPl6BXj5fgV8+YIFgPmGBYT5igWI+Y4Fjfw==') # rubocop:disable Layout/LineLength
  end
end
