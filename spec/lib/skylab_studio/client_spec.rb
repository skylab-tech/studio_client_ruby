# frozen_string_literal: true

require File.expand_path('../../../lib/skylab_studio.rb', __dir__)

RSpec.describe SkylabStudio::Client do
  let(:client) { SkylabStudio::Client.new }

  subject { client }

  it { should respond_to(:list_jobs) }
  it { should respond_to(:get_job) }

  describe '#configuration' do
    it 'should return a configuration object' do
      SkylabStudio::Client.configuration.settings.empty?.should eq(false)
    end
  end

  describe '#configure' do
    it 'should return a configuration object' do
      SkylabStudio::Client.configure do |config|
        config.settings.empty?.should eq(false)
      end
    end
  end

  describe '#initialize' do
    it 'should set configuration' do
      SkylabStudio::Client.new(protocol: 'foo').configuration.protocol.should eq('foo')
    end
  end

  describe '#list_jobs' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:get).and_return(true)

      subject.list_jobs.should eq(true)
    end
  end

  describe '#create_job' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:post).and_return(true)

      subject.create_job(
        job: {
          profile_id: 1
        }
      ).should eq(true)
    end
  end

  describe '#get_job' do
    it 'should raise error with no id' do
      expect { subject.get_job }.to raise_error(SkylabStudio::ClientNilArgument)
    end

    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:get).and_return(true)

      subject.get_job(id: 123).should eq(true)
    end
  end

  describe '#update_job' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:patch).and_return(true)

      subject.update_job(
        id: 1,
        job: {
          profile_id: 2
        }
      ).should eq(true)
    end
  end

  describe '#delete_job' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:delete).and_return(true)

      subject.delete_job(
        id: 1
      ).should eq(true)
    end
  end

  describe '#queue_job' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:post).and_return(true)

      subject.queue_job(
        id: 1
      ).should eq(true)
    end
  end

  describe '#cancel_job' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:post).and_return(true)

      subject.cancel_job(
        id: 1
      ).should eq(true)
    end
  end

  describe '#list_profiles' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:get).and_return(true)

      subject.list_profiles.should eq(true)
    end
  end

  describe '#create_profile' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:post).and_return(true)

      subject.create_profile(
        profile: {
          name: 'Foo'
        }
      ).should eq(true)
    end
  end

  describe '#get_profile' do
    it 'should raise error with no id' do
      expect { subject.get_profile }.to raise_error(SkylabStudio::ClientNilArgument)
    end

    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:get).and_return(true)

      subject.get_profile(id: 123).should eq(true)
    end
  end

  describe '#update_profile' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:patch).and_return(true)

      subject.update_profile(
        id: 1,
        profile: {
          name: 'Bar'
        }
      ).should eq(true)
    end
  end

  describe '#upload_job_photo' do
    before do
      stub_request(:post, 'https://studio.skylabtech.ai/api/public/v1/photos')
        .to_return(status: 200, body: { id: 1, photo: {} }.to_json, headers: {})

      stub_request(:get, 'https://studio.skylabtech.ai/api/public/v1/photos/upload_url')
        .to_return(status: 200, body: '', headers: {})

      stub_request(:get, 'https://studio.skylabtech.ai/api/public/v1/jobs/1')
        .to_return(status: 200, body: '', headers: {})

      stub_request(:delete, 'https://studio.skylabtech.ai/api/public/v1/photos/1')
        .to_return(status: 200, body: { id: 1 }.to_json, headers: {})
    end

    it 'should return response' do
      photo_path = "#{File.expand_path('../../', File.dirname(__FILE__))}/test-portrait-1.JPG"

      puts "RESPONSE: #{subject.upload_job_photo(photo_path, 1)}"

      id = 1

      expected_response = { photo: { id: id, photo: {} }, upload_response: nil }.as_json

      subject.upload_job_photo(photo_path, id).should eq(expected_response)
    end
  end

  describe '#upload_profile_photo' do
    it 'should return response' do
      photo_path = "#{File.expand_path('../../', File.dirname(__FILE__))}/test-portrait-1.JPG"

      subject.upload_profile_photo(photo_path, 1).should eq(true)
    end
  end

  describe '#get_photo' do
    it 'should raise error with no id' do
      expect { subject.get_photo }.to raise_error(SkylabStudio::ClientNilArgument)
    end

    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:get).and_return(true)

      subject.get_photo(id: 123).should eq(true)
    end
  end

  describe '#update_photo' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:patch).and_return(true)

      subject.update_photo(
        id: 1,
        photo: {
          name: 'Bar'
        }
      ).should eq(true)
    end
  end

  describe '#delete_photo' do
    it 'should return response' do
      SkylabStudio::Request.any_instance.stub(:delete).and_return(true)

      subject.delete_photo(
        id: 1
      ).should eq(true)
    end
  end
end
