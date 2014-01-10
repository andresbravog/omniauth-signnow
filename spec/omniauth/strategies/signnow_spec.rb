require 'spec_helper'

describe OmniAuth::Strategies::Signnow do
  def app; lambda{|env| [200, {}, ["Hello."]]} end

  let(:fresh_strategy){ Class.new(OmniAuth::Strategies::Signnow) }

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe '#client' do
    subject{ fresh_strategy }

    it 'should be initialized with correct authorize url' do
      instance = subject.new(app)
      expect(instance.client.options[:authorize_url]).to eql 'https://signnow.com/proxy/index.php/authorize'
    end

    it 'should be initialized with correct token url' do
      instance = subject.new(app)
      expect(instance.client.options[:token_url]).to eql 'https://api.signnow.com/oauth2/token'
    end
  end

  describe '#authorize_params' do
    subject { fresh_strategy }

    it 'should include :client_id option' do
      instance = subject.new('abc', 'def')
      expect(instance.authorize_params).to include('client_id')
      expect(instance.authorize_params['client_id']).to eql('def')
    end

    it 'should include :response_type option' do
      instance = subject.new('abc', 'def')
      expect(instance.authorize_params).to include('response_type')
      expect(instance.authorize_params['response_type']).to eql('code')
    end

    it 'should include random state in the authorize params' do
      instance = subject.new('abc', 'def')
      expect(instance.authorize_params).to include('state')
      instance.session['omniauth.state'].should_not be_empty
    end
  end

  describe '#token_params' do
    subject { fresh_strategy }
  end
end
