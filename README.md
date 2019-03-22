# geocode_rails

Ruby on Rails example API for geocoding based on google maps api data

[![Build Status](https://travis-ci.com/skamsie/rails_geocode.svg?branch=master)](https://travis-ci.com/skamsie/rails_geocode/branches)


### Requirements

```
PostgreSQL
Ruby v 2.5.1 (with bundler)
```

### Setup

```bash
# Create .env file for development
# GOOGLE_API_KEY needs to be added
$ cp .env.sample .env

$ bundle install
$ bundle exec rake db:create # create db
$ bundle exec rake db:migrate db:test:prepare # setup db

# Create a user for testing
$ echo 'User.create(email: "jake@example.com", password: "pass123")' | bundle exec rails c
```

### Use

```bash
# Start the server
$ bundle exec rails server
```


####  GET /authenticate

Get an authentication token to use with the geocoding endpoint
```bash
$ curl -H "Content-Type: application/json" -X POST -d \
    '{"email":"jake@example.com", "password":"pass123"}' \
    http://localhost:3000/authenticate

{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2LCJleHAiOjE1NTMyODQ2MjZ9.xmAvR42Z-KNINRKBB0VTX",
  "expires_at": "2019-03-22T20:57:06.000+01:00"
}
```

#### GET /geocode

Get geocoding data.  
With every successful request to the google api, the result is cached to avoid subsequent requests to google for identical queries. To get data again from google and not from the cache, pass the parameter `cache=false`
```bash
$ curl -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2LCJleHAiOjE1NTMyODQ2MjZ9.xmAvR42Z-KNINRKBB0VTX" \
    http://localhost:3000/geocode\?address\=statue+of+liberty

{
  "query": "statue of liberty",
  "latitude": "40.6892494",
  "longitude": "-74.0445004",
  "address": "Statue of Liberty National Monument, New York, NY 10004, USA"
}

$ curl -H "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2LCJleHAiOjE1NTMyODQ2MjZ9.xmAvR42Z-KNINRKBB0VTX" \
    http://localhost:3000/geocode\?address\=Oranienstra%C3%9Fe%2020,%20Berlin\&cache\=false

{
  "query": "oranienstraße 20, berlin",
  "latitude": "52.5007108",
  "longitude": "13.4220421",
  "address": "Oranienstraße 20, 10999 Berlin, Germany"
}

```
