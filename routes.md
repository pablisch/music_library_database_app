# REST routing (REST)

# Albums resource

## List all albums
```
Request:
GET /albums
Rsponse (200 OK):
A list of albums
```
## Find a specific album
```
Request:
GET /albums/:id e.g. GET /albums/1
Response (200 OK):
A single album
```
## Create a new album
```
Request:
POST /albums
with body parameters:
  title= "OK Computer"
  release_year="1997"
  artist_id="5"
Response (200 OK):
No content, just creates a new resource (album)
```


