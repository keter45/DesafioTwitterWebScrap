# README

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
- rails-i18n to translate some messages
- httparty to get the entiry html page
- nokogiri as a webscrap
- kaminari to paginate
