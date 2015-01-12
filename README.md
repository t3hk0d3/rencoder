# Rencoder

Rencoder is pure Ruby implementation of Rencoder serialization format encoding/decoding.

Rencoder is *FULLY* compliant with Python implementation, and uses all optimizations (by-type-offset integers, strings, arrays, hashes) both in encoding and decoding.

## Usage

### Serialization

```ruby
require 'rencoder'

Rencode.dump("Hello World") # Strings

Rencode.dump(100) # Integer

Rencoder.dump(1.0001) # Floats

Rencoder.dump({ hello: "world" }) # Hashes

Rencoder.dump(["hello", :world, 123]) # Arrays
```

**Float precion notice**
Rencoder uses 64-bit precision by default.
It's highly recommended to stay that way.
If there is strong reason to use 32-bit precision, then please specify 
``float32: true`` option for ``Rencoder.dump``:

```ruby
Rencoder.dump(1.000001, float32: true)
```
***Using 32-bit precision is highly NOT recommended***

### Deserialization

```ruby
require 'rencoder'

Rencoder.load(hash_data)
# => { 'hello': 'world' }

Rencoder.load(string_data)
# => "Hello World"

# etc
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rencoder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rencoder

