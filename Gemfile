source "https://rubygems.org"

gem "rails", "~> 7.1.0"
gem "mysql2"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "annotate"
gem "rack-cors"
gem "devise", "~> 4.8"
gem "devise_token_auth", "~> 1.2.4"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", "6.2.1", require: false
  gem "rubocop-rails-omakase", require: false
  gem "letter_opener_web"
end
