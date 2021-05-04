RSpec.describe SkylabStudio::VERSION do
  it 'provides the current version number' do
    SkylabStudio::VERSION.nil?.should eq(false)
  end
end
