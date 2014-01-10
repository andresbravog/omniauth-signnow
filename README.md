# OmniAuth Signow.com

[![Build Status](https://travis-ci.org/andresbravog/omniauth-signnow.png)](https://travis-ci.org/andresbravog/omniauth-signnow)

An unofficial OmniAuth strategy for authenticating to Signnow.com using OAuth. To use it, you'll
need to have a Signow.com [developer account](https://www.signow.com/developer).

## Installation

Add to your `Gemfile`:

```ruby
gem "omniauth-signnow"
```

Then `bundle install`.

## Usage

Here's an example for adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :signnow, ENV['SIGNNOW_APP_KEY'], ENV['SIGNNOW_APP_SECRET']
end
```

You can now access the OmniAuth Google OAuth2 URL: `/auth/signnow`
