# {{ METHOD }} {{ PATH}} Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

 
   Method:    |  GET
    Path:     |  /albums
Query params: |  
Body params:  |  
--------------------------
  Response:   |  List of all album titles

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

Response:
```
Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring
```

## 3. Write Examples

_Replace these with your own design._

```
# Request:
GET /hello?name=Pablo

# Expected response:
Hello Pablo!
```

```
# Request:
GET /hello?name=Leo

# Expected response:
Hello Leo!
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /" do
    it 'returns 200 OK with correct content' do
      response = get('/hello?name=Pablo')
      expect(response.status).to eq(200)
      expect(response.body).to eq "Hello Pablo!"
    end

    it 'returns 200 OK with correct content' do
      response = get('/hello?name=Leo')
      expect(response.status).to eq(200)
      expect(response.body).to eq "Hello Leo!"
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.