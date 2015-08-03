# Drafting

This Ruby gem enhances `ActiveRecord::Base` to save a draft version of the current instance.

[![Build Status](https://travis-ci.org/ledermann/drafting.svg?branch=master)](https://travis-ci.org/ledermann/drafting)
[![Coverage Status](https://coveralls.io/repos/ledermann/drafting/badge.svg?branch=master)](https://coveralls.io/r/ledermann/drafting?branch=master)

Remarkable:

* The gem stores all the data in **one** separate table and does not need to modify the existing tables
* It handles drafts for different models
* It allows saving draft for an object which does not pass the validations
* It uses marshaling, so associations and virtual attributes are saved, too
* A draft is optionally linked to a given user, so every user can manage his own drafts (invisible for the other users)
* A draft is optionally linked to a parent object. This helps showing existing drafts in a context (e.g. message drafts for a given topic)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'drafting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drafting


## Usage

```ruby
class Message < ActiveRecord::Base
  has_drafts
end

m = Message.new title: 'World domination', content: 'First step: Get some coffee.'
m.save_draft(current_user)

# Time passes ...

draft = Message.drafts(current_user).first
m = Message.from_draft(draft)
m.save
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ledermann/drafting. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Based on some code from the outdated gem [drafts](https://rubygems.org/gems/drafts). Used with kind permission of Alexey Kuznetsov (@lxkuz).
