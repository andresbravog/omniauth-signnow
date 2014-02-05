require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Signnow < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "signnow"

      option :provider_ignores_state, true

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        site: 'https://api.signnow.com',
        authorize_url: 'https://signnow.com/proxy/index.php/authorize',
        token_url: 'https://api.signnow.com/oauth2/token'
      }

      option :authorize_params, {
        response_type: 'code'
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['id'] }

      info do
        {
          :name => [ raw_info['first_name'], raw_info['last_name'] ].join(' '),
          :email => (raw_info['emails'] || []).first
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://api.signnow.com/user').parsed
      end

      def build_access_token
        verifier = request.params['code']
        new_params = { :redirect_uri => callback_url }.merge(auth_options)
        params = new_params.merge(token_params.to_hash(:symbolize_keys => true))
        opts = deep_symbolize(options.auth_token_params || {})
        client.auth_code.get_token(verifier, params, opts)
      end

      def auth_options
        { headers: { Authorization: "Basic #{encoded_credentials}" } }
      end

      def encoded_credentials
        return unless client and client.id and client.secret
        Base64.strict_encode64( client.id + ':' + client.secret)
      end
    end
  end
end
