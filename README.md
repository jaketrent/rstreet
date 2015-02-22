# Rstreet

Smart Uploader for AWS S3 buckets

Ruby port of [tgroshon's](https://github.com/tgroshon) [street.js](https://github.com/tgroshon/street.js)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rstreet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rstreet

## Setup AWS Access Policies

Make sure that the credentials that you're providing to the tool have sufficient access to read and write to the bucket you're attempting to access.

For an easy default, attach the managed access control policy "AmazonS3FullAccess" to your user/group.

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[jaketrent]/rstreet/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
