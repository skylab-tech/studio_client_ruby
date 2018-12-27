RSpec.describe Skylab::VERSION do
  it 'provides the current version number' do
    Skylab::VERSION.nil?.should eq(false)
  end
end
