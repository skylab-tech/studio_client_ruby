require File.expand_path('../../../lib/skylab_studio.rb', __dir__)

RSpec.describe SkylabStudio::Request do
  before(:each) do
    @client = SkylabStudio::Client.new
    @config = SkylabStudio::Config.new

    @request = SkylabStudio::Request.new(@config)
  end

  subject { @request }

  describe '#post' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @request.post(:jobs, {}).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 401' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPUnauthorized.new(1.0, 401, 'Error'))

      expect { @request.post(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @request.post(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @request.post(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidEndpoint)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @request.post(:jobs, {}) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on 429' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPTooManyRequests.new(1.0, 429, 'Error'))

      expect { @request.post(:jobs, {}) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @request.post(:jobs, {}) }.to raise_error(SkylabStudio::ClientUnknownError)
    end

    it 'should raise error on connection refused' do
      Net::HTTP.any_instance.stub(:request).and_raise(Errno::ECONNREFUSED)

      expect { @request.post(:jobs, {}) }.to raise_error(SkylabStudio::ClientConnectionRefused)
    end
  end

  describe '#get' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @request.get(:jobs, {}).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 401' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPUnauthorized.new(1.0, 401, 'Error'))

      expect { @request.get(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @request.get(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @request.get(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidEndpoint)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @request.get(:jobs, {}) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on 429' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPTooManyRequests.new(1.0, 429, 'Error'))

      expect { @request.get(:jobs, {}) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @request.get(:jobs, {}) }.to raise_error(SkylabStudio::ClientUnknownError)
    end

    it 'should raise error on connection refused' do
      Net::HTTP.any_instance.stub(:request).and_raise(Errno::ECONNREFUSED)

      expect { @request.get(:jobs, {}) }.to raise_error(SkylabStudio::ClientConnectionRefused)
    end
  end

  describe '#delete' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @request.delete(:jobs).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 401' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPUnauthorized.new(1.0, 401, 'Error'))

      expect { @request.delete(:jobs) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @request.delete(:jobs) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @request.delete(:jobs) }.to raise_error(SkylabStudio::ClientInvalidEndpoint)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @request.delete(:jobs) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on 429' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPTooManyRequests.new(1.0, 429, 'Error'))

      expect { @request.delete(:jobs) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @request.delete(:jobs) }.to raise_error(SkylabStudio::ClientUnknownError)
    end

    it 'should raise error on connection refused' do
      Net::HTTP.any_instance.stub(:request).and_raise(Errno::ECONNREFUSED)

      expect { @request.delete(:jobs) }.to raise_error(SkylabStudio::ClientConnectionRefused)
    end
  end

  describe '#put' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @request.put(:jobs, {}).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 401' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPUnauthorized.new(1.0, 401, 'Error'))

      expect { @request.put(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @request.put(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @request.put(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidEndpoint)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @request.put(:jobs, {}) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on 429' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPTooManyRequests.new(1.0, 429, 'Error'))

      expect { @request.put(:jobs, {}) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @request.put(:jobs, {}) }.to raise_error(SkylabStudio::ClientUnknownError)
    end

    it 'should raise error on connection refused' do
      Net::HTTP.any_instance.stub(:request).and_raise(Errno::ECONNREFUSED)

      expect { @request.put(:jobs, {}) }.to raise_error(SkylabStudio::ClientConnectionRefused)
    end
  end

  describe '#patch' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @request.patch(:jobs, {}).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 401' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPUnauthorized.new(1.0, 401, 'Error'))

      expect { @request.patch(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @request.patch(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidKey)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @request.patch(:jobs, {}) }.to raise_error(SkylabStudio::ClientInvalidEndpoint)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @request.patch(:jobs, {}) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on 429' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPTooManyRequests.new(1.0, 429, 'Error'))

      expect { @request.patch(:jobs, {}) }.to raise_error(SkylabStudio::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @request.patch(:jobs, {}) }.to raise_error(SkylabStudio::ClientUnknownError)
    end

    it 'should raise error on connection refused' do
      Net::HTTP.any_instance.stub(:request).and_raise(Errno::ECONNREFUSED)

      expect { @request.patch(:jobs, {}) }.to raise_error(SkylabStudio::ClientConnectionRefused)
    end
  end
end
