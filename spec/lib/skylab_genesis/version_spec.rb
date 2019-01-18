RSpec.describe SkylabGenesis::VERSION do
  it 'provides the current version number' do
    SkylabGenesis::VERSION.nil?.should eq(false)
  end
end
