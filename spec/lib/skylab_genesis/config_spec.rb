require File.expand_path('../../../lib/skylab_genesis.rb', __dir__)

RSpec.describe SkylabGenesis::Config do
  before(:each) do
    @config = SkylabGenesis::Config.new
  end

  subject { @config }

  it { should respond_to(:api_key) }
  it { should respond_to(:api_version) }
  it { should respond_to(:client_stub) }
  it { should respond_to(:debug) }
  it { should respond_to(:host) }
  it { should respond_to(:port) }
  it { should respond_to(:protocol) }
  it { should respond_to(:url) }

  # Class methods
  describe '#defaults' do
    it 'return the proper default config' do
      SkylabGenesis::Config.defaults.empty?.should eq(false)
      SkylabGenesis::Config.defaults[:protocol].should eq('https')
    end
  end

  describe '#initialize' do
    it 'return override default config' do
      SkylabGenesis::Config.new(protocol: 'proto').protocol.should eq('proto')
    end
  end

  # Instance methods
  describe '#method_missing' do
    it 'should allow the assignment of a config key' do
      expect { @config.url = 'http://google.com' }.to_not raise_error
    end

    it 'should allow the fetch of a config key' do
      expect { @config.url }.to_not raise_error
    end

    it 'should raise error on missing method' do
      expect { @config.bad }.to raise_error(StandardError)
    end

    it 'should raise error on missing method assignment' do
      expect { @config.bad = '123' }.to raise_error(StandardError)
    end
  end
end
