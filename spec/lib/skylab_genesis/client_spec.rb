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

  describe '#create_job' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:post).and_return(true)

      @client.create_job(
        job: {
          profile_id: 1
        }
      ).should eq(true)
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

  describe '#update_job' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:patch).and_return(true)

      @client.update_job(
        id: 1,
        job: {
          profile_id: 2
        }
      ).should eq(true)
    end
  end

  describe '#delete_job' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:delete).and_return(true)

      @client.delete_job(
        id: 1
      ).should eq(true)
    end
  end

  describe '#process_job' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:post).and_return(true)

      @client.process_job(
        id: 1
      ).should eq(true)
    end
  end

  describe '#cancel_job' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:post).and_return(true)

      @client.cancel_job(
        id: 1
      ).should eq(true)
    end
  end

  describe '#list_profiles' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:get).and_return(true)

      @client.list_profiles.should eq(true)
    end
  end

  describe '#create_profile' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:post).and_return(true)

      @client.create_profile(
        profile: {
          name: 'Foo'
        }
      ).should eq(true)
    end
  end

  describe '#get_profile' do
    it 'should raise error with no id' do
      expect { @client.get_profile }.to raise_error(SkylabGenesis::ClientNilArgument)
    end

    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:get).and_return(true)

      @client.get_profile(id: 123).should eq(true)
    end
  end

  describe '#update_profile' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:patch).and_return(true)

      @client.update_profile(
        id: 1,
        profile: {
          name: 'Bar'
        }
      ).should eq(true)
    end
  end

  describe '#delete_profile' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:delete).and_return(true)

      @client.delete_profile(
        id: 1
      ).should eq(true)
    end
  end

  describe '#list_photos' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:get).and_return(true)

      @client.list_photos.should eq(true)
    end
  end

  describe '#create_photo' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:post).and_return(true)

      @client.create_photo(
        photo: {
          name: 'Foo'
        }
      ).should eq(true)
    end
  end

  describe '#get_photo' do
    it 'should raise error with no id' do
      expect { @client.get_photo }.to raise_error(SkylabGenesis::ClientNilArgument)
    end

    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:get).and_return(true)

      @client.get_photo(id: 123).should eq(true)
    end
  end

  describe '#update_photo' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:patch).and_return(true)

      @client.update_photo(
        id: 1,
        photo: {
          name: 'Bar'
        }
      ).should eq(true)
    end
  end

  describe '#delete_photo' do
    it 'should return response' do
      SkylabGenesis::Request.any_instance.stub(:delete).and_return(true)

      @client.delete_photo(
        id: 1
      ).should eq(true)
    end
  end
end
