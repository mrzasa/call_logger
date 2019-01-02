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

  log_class def self.info(msg)
    "Showing: #{msg}"
  end
end

Calculator.new.times(3,4)
# Calculator#times(3, 4)
# Calculator#times => 6
# => 6

Calculator.new.div(3,0)
# Calculator#div(3, 0)
# Calculator#div !! divided by 0
# ZeroDivisionError: divided by 0

Calculator.info("hello!")
# Calculator.info(hello)
# Calculator.info => "Showing: hello"
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

### Wrapping a single method

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

If you want to log class method calls, prepend them with `.log_class`:

```
class Calculator
  include CallLogger

  log_class def self.times(a, b)
    a*b
  end
end
```
### Wrapping multiple methods

You can also pass multiple method names to `.log` and `.log_class` to wrap them all:

```
class Calculator
  include CallLogger

  log :times, :div

  def times(a, b)
    a*b
  end

  def div(a, b)
    a/b
  end
end
```

```
class Calculator
  include CallLogger

  log_class :times, :div

  def self.times(a, b)
    a*b
  end

  def self.div(a, b)
    a/b
  end
end
```

### Wrapping a block

You can wrap a block of code using `#log_block` (in instance methods) or `.log_block` (in class methods). Block parameters will not be logged though:

```
class Calculator
  include CallLogger

  def times(a, b)
    log_block('multiply')
      a*b
    end
  end
end

Calculator.new.times(3,4)
# multiply
# multiply => 6
# => 6
```

Block calls may be also logged without including `CallLogger` module with `CallLogger.log_block`:

```
log_block('multiply')
  a*b
end
Calculator.new.times(3,4)
# multiply
# multiply => 6
# => 6
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

* [+] class methods
* [+] multiple method names
* [+] handle blocks
* [] logging all methods defined in the class
* [] doc: Rails integration
* [] doc: API docs
* [] infra: travis

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/call_logger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
