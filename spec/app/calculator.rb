require 'call_logger'

class Calculator
  include CallLogger

  log def times(a, b)
    a*b
  end

  log def div(a, b)
    a/b
  end
end
