RSpec.describe CallLogger do

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

  context "with single method" do
    class TestClass
      include CallLogger

      log def times(a, b)
        a*b
      end

      log def div(a, b)
        a/b
      end


      log_class def self.info(a)
        "#{self} #{a}"
      end
    end

    context "with default config" do
      it 'does not change return type' do
        expect(TestClass.new.times(2,3)).to eq(6)
      end
    end

    context "with test config" do
      before do
        ::CallLogger.configure do |config|
          config.logger = logger
          config.formatter = formatter_class.new
        end
      end

      it 'calls logger before and after excution' do
        expect(logger).to receive(:call).with("TestClass#times: 2,3")
        expect(logger).to receive(:call).with("TestClass#times=6")

        expect(TestClass.new.times(2,3)).to eq(6)
      end

      it 'calls logger when exception occured' do
        expect(logger).to receive(:call).with("TestClass#div: 3,0")
        expect(logger).to receive(:call).with("TestClass#div!divided by 0")

        expect { TestClass.new.div(3,0) }.to raise_error ZeroDivisionError
      end

      it 'calls logger on class methods' do
        expect(logger).to receive(:call).with("TestClass.info: a")
        expect(logger).to receive(:call).with("TestClass.info=TestClass a")

        expect(TestClass.info('a')).to eq("TestClass a")
      end
    end
  end

  context "with multiple methods" do
    before do
      ::CallLogger.configure do |config|
        config.logger = logger
        config.formatter = formatter_class.new
      end
    end

    class TestClassMulti
      include CallLogger

      log :times, :div
      #log_class :info, :calc_name

      def times(a, b)
        a*b
      end

      def div(a, b)
        a/b
      end

      def add(a, b)
        a+b
      end

      def self.info(a)
        "#{self} #{a}"
      end

      def self.calc_name
        "multi"
      end

      def self.pi
        3.141592
      end
    end

    it 'logs calls on multiple instance method names' do
      expect(logger).to receive(:call).with("TestClassMulti#times: 2,3")
      expect(logger).to receive(:call).with("TestClassMulti#times=6")

      expect(TestClassMulti.new.times(2,3)).to eq(6)

      expect(logger).to receive(:call).with("TestClassMulti#div: 3,0")
      expect(logger).to receive(:call).with("TestClassMulti#div!divided by 0")

      expect { TestClassMulti.new.div(3,0) }.to raise_error ZeroDivisionError

      expect(logger).not_to receive(:call)

      expect(TestClassMulti.new.add(3,1)).to eq(4)
    end

    it 'logs calls on multiple class method names'
  end
end
