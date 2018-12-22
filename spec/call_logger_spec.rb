RSpec.describe CallLogger do
  class TestClass
    include CallLogger

    log def times(a, b)
      a*b
    end

    log def div(a, b)
      a/b
    end
  end

  before do
    ::CallLogger.configure {}
  end


  context "with default config" do
    it 'does not change return type' do
      expect(TestClass.new.times(2,3)).to eq(6)
    end
  end

  context "with test config" do
    let(:logger) { double(:logger)}
    let(:formatter_class) do
      Class.new do
        def before(method, args)
          "#{method}: #{args.join(',')}"
        end

        def after(method, result)
          "#{method}=#{result}"
        end

        def error(method, exception)
          "#{method}!#{exception}"
        end
      end
    end

    before do
      ::CallLogger.configure do |config|
        config.logger = logger
        config.formatter = formatter_class.new
      end
    end

    it 'calls logger before and after excution' do
      expect(logger).to receive(:call).with("times: 2,3")
      expect(logger).to receive(:call).with("times=6")

      expect(TestClass.new.times(2,3)).to eq(6)
    end

    it 'calls logger when exception occured' do
      expect(logger).to receive(:call).with("div: 3,0")
      expect(logger).to receive(:call).with("div!divided by 0")

      expect { TestClass.new.div(3,0) }.to raise_error ZeroDivisionError
    end
  end
end
