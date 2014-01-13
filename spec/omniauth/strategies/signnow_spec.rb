require 'spec_helper'

describe OmniAuth::Strategies::Signnow do
  let(:app) do
    lambda do |env|
      [200, {}, ["Hello."]]
    end
  end
  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}) }
  let(:fresh_strategy){ Class.new(OmniAuth::Strategies::Signnow) }

  let(:signnow_strategy) do
    fresh_strategy.new(app, '_your_app_id_', '_your_app_secret_', @options || {}).tap do |strategy|
      strategy.stub(:request) {
        request
      }
    end
  end

  subject { signnow_strategy }

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe '#client_options' do

    it 'should be initialized with correct authorize url' do
      expect(subject.client.options[:authorize_url]).to eql 'https://eval.signnow.com/proxy/index.php/authorize'
    end

    it 'should be initialized with correct token url' do
      expect(subject.client.options[:token_url]).to eql 'https://capi-eval.signnow.com/api/oauth2/token'
    end

    describe "overrides" do
      it 'should allow overriding the site' do
        @options = {:client_options => {'site' => 'https://example.com'}}
        subject.client.site.should == 'https://example.com'
      end

      it 'should allow overriding the authorize_url' do
        @options = {:client_options => {'authorize_url' => 'https://example.com'}}
        subject.client.options[:authorize_url].should == 'https://example.com'
      end

      it 'should allow overriding the token_url' do
        @options = {:client_options => {'token_url' => 'https://example.com'}}
        subject.client.options[:token_url].should == 'https://example.com'
      end
    end
  end

  describe '#authorize_params' do

    it 'should include any authorize params passed in the :authorize_params option' do
      @options = {:authorize_params => {:request_visible_actions => 'something', :foo => 'bar', :baz => 'zip'}, :bad => 'not_included'}
      subject.authorize_params['request_visible_actions'].should eq('something')
      subject.authorize_params['foo'].should eq('bar')
      subject.authorize_params['baz'].should eq('zip')
      subject.authorize_params['bad'].should eq(nil)
    end

    it 'should include :response_type option' do
      expect(subject.authorize_params).to include('response_type')
      expect(subject.authorize_params['response_type']).to eql('code')
    end

    it 'should include random state in the authorize params' do
      expect(subject.authorize_params).to include('state')
      subject.session['omniauth.state'].should_not be_empty
    end
  end

  describe '#token_params' do
    it 'should include any token params passed in the :token_params option' do
      @options = {:token_params => {:foo => 'bar', :baz => 'zip'}}
      subject.token_params['foo'].should eq('bar')
      subject.token_params['baz'].should eq('zip')
    end
  end

  describe "#token_options" do
    it 'should include top-level options that are marked as :token_options' do
      @options = {:token_options => [:scope, :foo], :scope => 'bar', :foo => 'baz', :bad => 'not_included'}
      subject.token_params['scope'].should eq('bar')
      subject.token_params['foo'].should eq('baz')
      subject.token_params['bad'].should eq(nil)
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      subject.callback_path.should eq('/auth/signnow/callback')
    end
  end

  describe '#auth_options' do
    let(:base64_client_key) {
      Base64.encode64(subject.client.id + ':' + subject.client.secret).gsub(/[\n=]/,'')
    }
    it  'is protected' do
      expect(subject.auth_options).to raise_error(NoMethodError)
    end
    it 'returns a hash with the Autorization header' do
      expect(subject.send(:auth_options).class).to eql(Hash)
      expect(subject.send(:auth_options)).to include(:headers)
      expect(subject.send(:auth_options)[:headers]).to include('Authorization')
      expect(subject.send(:auth_options)[:headers]['Authorization']).to match(/Basic/)
      expect(subject.send(:auth_options)[:headers]['Authorization']).to match(/#{base64_client_key}/)
    end
  end

end
