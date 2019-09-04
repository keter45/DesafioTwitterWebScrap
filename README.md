# README

Exemple:

<iframe src="https://giphy.com/embed/RgnFCKJNZGIwBc6jj8" width="480" height="309" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/RgnFCKJNZGIwBc6jj8">via GIPHY</a></p>

Ruby version:

    $ ruby '2.5.3'

To run this project execute:

    $ bundle install

And to generate Users table:

    $ rails db:migrate

And then:

    $ rails s

This project uses:

- rails '~> 5.2.0'
- sqlite3
- rails-i18n : to translate some messages
- httparty : to get the entiry html page
- nokogiri : as a webscrap
- kaminari : to paginate
