# Fortuna Luca

[![Build Status](https://travis-ci.org/fanolug/fortuna_luca.svg?branch=master)](https://travis-ci.org/fanolug/fortuna_luca)
[![Code Climate](https://codeclimate.com/github/fanolug/fortuna_luca/badges/gpa.svg)](https://codeclimate.com/github/fanolug/fortuna_luca)

## The Telegram bot of the Fortunae Lug, also known as FanoLUG

### Setup

    bundle


### Running locally

You must have a complete `.env` file with all the required credentials.

    DEVELOPMENT=true bundle exec bin/bot

WARNING: if you use production credentials this will disconnect the production
bot!

### Test

    bundle exec rake


Powered by [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby)

Copyright (c) 2017 FanoLUG, released under the MIT License.
