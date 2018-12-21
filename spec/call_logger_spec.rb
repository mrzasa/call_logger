RSpec.describe CallLogger do
  class TestClass
    include CallLogger

    log def times(a, b)
      a*b
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
        def begin_message(method, args)
          "#{method}: #{args.join(',')}"
        end

        def end_message(method, result)
          "#{method}=#{result}"
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
  end
end
