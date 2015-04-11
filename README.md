This is Imperilment!

[![Code Climate](https://codeclimate.com/github/freerunningtech/imperilment.png)](https://codeclimate.com/github/freerunningtech/imperilment)
[![Dependency Status](https://gemnasium.com/freerunningtech/imperilment.png)](https://gemnasium.com/freerunningtech/imperilment)

It's the triva game where you get the answers, and need to respond with the questions!

## Requirements

* ruby >= 1.9.3
* Some database (sqlite3/mysql/postgresql should all work)
* [A day-to-day Jeopardy calendar](http://www.amazon.com/Jeopardy-2015-Day-Day-Calendar/dp/1449451942/)

## Getting Started

 - `$ bundle install`
 - `$ sh bootstrap`
 - `$ rails server`

## Development

### Styles

#### Icons

We are using a custom build of [Fontello](http://fontello.com/) which is
described by [config.json][1]. We are using [railslove/fontello_rails_converter][2]
to update/convert the fontello assets to SCSS.

The current glyph set can be seen at http://localhost:3000/fontello-demo.html

#### To Update Fontello

1. `bundle exec fontello open` to open our custom glyph set in the Fontello web app.
2. Change selected glyphs as needed and save your session.
3. `bundle exec fontello convert --stylesheet-extension=.scss` to fetch those changes and update vendor assets.

### Admin

http://localhost:3000/users/sign_in to login without using acutal gmail auth,
 **Email:** `admin@example.com` **Password:** `test123`

[1]: https://github.com/freerunningtech/imperilment/blob/master/vendor/assets/fonts/config.json
[2]: https://github.com/railslove/fontello_rails_converter
