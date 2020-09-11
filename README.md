# Rencoder

Rencoder is a pure Ruby implementation of Rencode serialization format encoding/decoding.

Rencoder is a *FULLY* compliant with Python implementation, and uses all optimizations (by-type-offset integers, strings, arrays, hashes) both for encoding and decoding.

Rencoder have no runtime dependencies. Everything done in a pure Ruby.

More about Rencode format:
- <https://github.com/aresch/rencode>
- <http://barnesc.blogspot.ru/2006/01/rencode-reduced-length-encodings.html>
- <https://mail.python.org/pipermail/python-announce-list/2006-January/004643.html>

## Usage

### Serialization

```ruby
require 'rencoder'

Rencoder.dump("Hello World") # Strings

Rencoder.dump(100) # Integer

Rencoder.dump(1.0001) # Floats

Rencoder.dump({ hello: "world" }) # Hashes

Rencoder.dump(["hello", :world, 123]) # Arrays
```

**Float precion notice**
Rencoder uses a 64-bit precision by default.
It's recommended to stay this way.
If there is a strong reason to use 32-bit precision, then please specify
``float32: true`` option in a ``Rencoder.dump`` call:

```ruby
Rencoder.dump(1.000001, float32: true)
```
***Using 32-bit precision is NOT recommended***

### Deserialization

```ruby
require 'rencoder'

Rencoder.load(hash_data)
# => { 'hello': 'world' }

Rencoder.load(string_data)
# => "Hello World"
```

**Rencoder can read data from any IO object directly, without using any buffers**
```ruby
socket = TCPSocket.new('example.com', 8814)
Rendcoder.load(socket)
# => "Example!"
```

### ActiveRecord

Rencoder is compliant with the ActiveSupport's ``serialize`` interface:

```ruby
class MyModel < ActiveRecord::Base
    serialize :data, Rencoder
end

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

