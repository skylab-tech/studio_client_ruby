require File.expand_path('../../../lib/skylab_genesis.rb', __dir__)

RSpec.describe SkylabGenesis::Client do
  before(:each) do
    @client = SkylabGenesis::Client.new
  end

  subject { @client }

  it { should respond_to(:list_jobs) }
  it { should respond_to(:get_job) }

  describe '#configuration' do
    it 'should return a configuration object' do
      SkylabGenesis::Client.configuration.settings.empty?.should eq(false)
    end
  end

  describe '#configure' do
    it 'should return a configuration object' do
      SkylabGenesis::Client.configure do |config|
        config.settings.empty?.should eq(false)
      end
    end
  end

  describe '#initialize' do
    it 'should set configuration' do
      SkylabGenesis::Client.new(protocol: 'foo').configuration.protocol.should eq('foo')
    end
  end

  describe '#list_jobs' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:get).and_return(true)

      @client.list_jobs.should eq(true)
    end
  end

  describe '#get_job' do
    it 'should raise error with no id' do
      expect { @client.get_job }.to raise_error(SkylabGenesis::ClientNilArgument)
    end

    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:get).and_return(true)

      @client.get_job(id: 123).should eq(true)
    end
  end
end
