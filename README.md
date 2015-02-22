# Rstreet

Smart Uploader for AWS S3 buckets.

Generates a manifest file upon first upload;
subsequent uploads only send changed files.  Especially useful as a deploy tool
for uploading static websites to S3. Benefits of using Street:

* Upload only changed files; reduces **PUT** requests.
* GZip Compressed **manifest** file stored on S3 is very small.
* Mime-type lookup on upload to facilitate proper browser handling.
* Non-destructive *(mostly)*.  Works with existing buckets and data. See *Manifest
  File* section below for more details.

Ruby port of [tgroshon's](https://github.com/tgroshon) [street.js](https://github.com/tgroshon/street.js)

## tl;dr

* Install with `gem install rstreet` to get the `rstreet` cli tool.
* Export **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY** to your environment.
* Run `rstreet -e -b <Target S3 Bucket> path/to/upload/dir`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rstreet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rstreet

## Command Line Options

A helpful interface into Street is using the command line tool `rstreet`.  The
command line tool requires a path to a directory that you want to upload to S3 as
the last argument.
Run `rstreet --help` to see a list of options.

#### -e, --load-env, Load Environment Variables ####

Rstreet can load environment variables declared in a `.env` file of the current
working directory.  With this option, Rstreet searches for 3 AWS variables:

1. **AWS_ACCESS_KEY_ID**
2. **AWS_SECRET_ACCESS_KEY**
3. **S3_BUCKET**

Instead of using Environment Variables, you can some or all of these through
the command line options `--aws-key`, `--aws-secret`, and `--bucket`
respectively.

*Example*: `rstreet -e path/to/upload/dir`

#### -b, --bucket [bucket], S3 Destination Bucket ####

The Amazon S3 bucket to be the destination of your uploaded files.

*Example*: `rstreet -b <S3 bucket name> path/to/upload/dir`

#### -k, --aws-key [key], AWS Access Key Id ####

The AWS Access Key Id to be used for authenticating the S3 session.  User must
have `PUT` and `GET` permissions on the bucket.

*Example*: `street -k <AWS Access Key Id> path/to/upload/dir`

#### -s, --aws-secret [secret], AWS Secret Access Key ####

The AWS Secret Access Key associated with the AWS Access Key Id you are using.

*Example*: `rstreet -s <AWS Secret Key> path/to/upload/dir`

#### -v, --verbose, Run with expanded messages ####

Shows the number of files uploaded, but not much else.  This option will do more
in the future.

*Example*: `rstreet -v /path/to/upload/dir`

#### -n, --dry-run, Run but do not upload ####

Best if used in conjuction with the `--verbose` option.

*Example*:

`rstreet -n path/to/upload/dir`

`rstreet -nv path/to/upload/dir`

`rstreet -n path/to/upload/dir`

## Run Programmatically

If you want to incorporate the Rstreet uploader into another program, that's
also possible.  Perhaps you'd like to use it as a part of an API that can upload
to S3 or your own build script.  Usage is simple.  It takes a hash of options that
 match the commandline interface.  However, note that the names of the options are slightly
 different.

```ruby
require "rstreet"

options = {
  src: 'path/to/upload/dir',      # Path to directory to upload.
  dry_run: false,                 # Disable upload mechanism.
  s3_bucket: 'bucketname.com',    # Name of S3 Bucket to upload to.
  aws_key: 'AWS Access Key Id',   # AWS Access Key Id for authentication w/ S3.
  aws_secret: 'AWS Secret Key',   # AWS Secret Key for authentication w/ S3.
  load_env: true,                 # Load Environment Variables with 'dotenv'.
  verbose: true,                  # Trigger extra messages.
}

Rstreet::Uploader.new(options).run
```

You can make this part of a [Grunt](http://gruntjs.com/) task or your own,
standalone deploy script.  Dealer's choice!

## Manifest File

The `manifest.json.gz` file is a GZipped JSON file that maps S3 Object Keys (file
names) to MD5 Hashes.

The `manifest.json.gz` file is generated each time Street is run.  On the first run
of Street on a specific directory, the `manifest.json.gz` file is written to that
directory (called the *upload directory*), and all files it found are uploaded to
S3.  The next time Street is run, a **new manifest** is generated locally, the
**old manifest** is pulled down from S3, and the two files are compared to
search for differences.  The **new manifest** is only written if files have
been changed.  If files have been changed, the new `manifest.json.gz` and changed
files are then uploaded to S3 where they replace the objects of the same name.

This approach has two important effects that you should be aware of:

1. **\*IMPORTANT\*** Upon first run of Street, all files in the directory
   and a new `manifest.json.gz` file will be uploaded and replace S3 objects with
   the same name.

2. A `manifest.json.gz` file on S3 does *not* hold information on all the objects in
   that bucket; only on objects that Street has specifically uploaded.

Keep these in mind as you work.

## Setup AWS Access Policies

Make sure that the credentials that you're providing to the tool have sufficient access to read and write to the bucket you're attempting to access.

For an easy default, attach the managed access control policy "AmazonS3FullAccess" to your user/group.

## Contributing

1. Fork it ( https://github.com/[jaketrent]/rstreet/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
