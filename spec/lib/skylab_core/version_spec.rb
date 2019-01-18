RSpec.describe SkylabCore::VERSION do
  it 'provides the current version number' do
    SkylabCore::VERSION.nil?.should eq(false)
  end
end
