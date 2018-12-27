require File.expand_path('../../../lib/skylab.rb', __dir__)

RSpec.describe Skylab::APIRequest do
  before(:each) do
    @client = Skylab::Client.new
    @config = Skylab::Config.new

    @api_request = Skylab::APIRequest.new(@config)
  end

  subject { @api_request }

  describe '#post' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @api_request.post(:jobs, {}).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @api_request.post(:jobs, {}) }.to raise_error(Skylab::ClientInvalidEndpoint)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @api_request.post(:jobs, {}) }.to raise_error(Skylab::ClientInvalidKey)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @api_request.post(:jobs, {}) }.to raise_error(Skylab::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @api_request.post(:jobs, {}) }.to raise_error(Skylab::ClientUnknownError)
    end
  end

  describe '#get' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @api_request.get(:jobs, {}).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @api_request.get(:jobs, {}) }.to raise_error(Skylab::ClientInvalidEndpoint)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @api_request.get(:jobs, {}) }.to raise_error(Skylab::ClientInvalidKey)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @api_request.get(:jobs, {}) }.to raise_error(Skylab::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @api_request.get(:jobs, {}) }.to raise_error(Skylab::ClientUnknownError)
    end
  end

  describe '#delete' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @api_request.delete(:jobs).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @api_request.delete(:jobs) }.to raise_error(Skylab::ClientInvalidEndpoint)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @api_request.delete(:jobs) }.to raise_error(Skylab::ClientInvalidKey)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @api_request.delete(:jobs) }.to raise_error(Skylab::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @api_request.delete(:jobs) }.to raise_error(Skylab::ClientUnknownError)
    end
  end

  describe '#put' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @api_request.put(:jobs, {}).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @api_request.put(:jobs, {}) }.to raise_error(Skylab::ClientInvalidEndpoint)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @api_request.put(:jobs, {}) }.to raise_error(Skylab::ClientInvalidKey)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @api_request.put(:jobs, {}) }.to raise_error(Skylab::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @api_request.put(:jobs, {}) }.to raise_error(Skylab::ClientUnknownError)
    end
  end

  describe '#patch' do
    it 'should return success' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPSuccess.new(1.0, 200, 'OK'))

      @api_request.patch(:jobs, {}).should be_instance_of(Net::HTTPSuccess)
    end

    it 'should raise error on 404' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPNotFound.new(1.0, 404, 'Error'))

      expect { @api_request.patch(:jobs, {}) }.to raise_error(Skylab::ClientInvalidEndpoint)
    end

    it 'should raise error on 403' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPForbidden.new(1.0, 403, 'Error'))

      expect { @api_request.patch(:jobs, {}) }.to raise_error(Skylab::ClientInvalidKey)
    end

    it 'should raise error on 422' do
      Net::HTTP.any_instance.stub(:request).and_return(Net::HTTPBadRequest.new(1.0, 422, 'Error'))

      expect { @api_request.patch(:jobs, {}) }.to raise_error(Skylab::ClientBadRequest)
    end

    it 'should raise error on unknown response' do
      Net::HTTP.any_instance.stub(:request).and_return(false)

      expect { @api_request.patch(:jobs, {}) }.to raise_error(Skylab::ClientUnknownError)
    end
  end
end
