RSpec.describe CallLogger do
  class TestClass
    include CallLogger

    log def times(a, b)
      a*b
    end
  end

  it 'does not change return type' do
    expect(TestClass.new.times(2,3)).to eq(6)
  end
end
