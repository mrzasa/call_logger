# CallLogger

A debugging tool that lets you log method usage.

```
class Calculator
  include CallLogger

  log def times(a, b)
    a*b
  end

  log def div(a, b)
    a/b
  end
end

Calculator.new.times(3,4)
# times(3, 4)
# times => 6
# => 7

Calculator.new.div(3,0)
# div(3, 0)
# div !! divided by 0
# ZeroDivisionError: divided by 0
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'call_logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install call_logger

## Usage

Include it to a class being debugged and the prepend a method definition with `log`:

```
class Calculator
  include CallLogger

  log def times(a, b)
    a*b
  end
end
```

`.log` accepts method name, so you can pass it explicitly:

```
class Calculator
  include CallLogger

  def times(a, b)
    a*b
  end

  log :times
end
```

### Configuration

There are two pluggable components: `Logger` and `Formatter`. `Formatter` preperes messages to be printed and `Logger` sents them to the
output stream (whatever it is). This documentation uses default ones, but they can be easily configured:

```
::CallLogger.configure do |config|
  config.logger = CustomLogger.new
  config.formatter = CustomFormatter.new
end
```

* `Logger` should provide a `#call` method accepting a single paramter.
* `Formatter` should provide following methods:
  * `#before(method, args)` - accepting method name and it's arguments; called before method execution
  * `#after(method, result)` - accepting method name and it's result; called after method execution
  * `#error(method, exception)` - accepting method name and an exception; called when error is raised

## TODO

* [] class methods
* [] multiple method names
* [] handle blocks
* [] logging all methods defined in the class
* [] doc: Rails integration

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/call_logger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
