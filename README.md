# Dronetrack API

This is a simple ruby gem for integrating with the Dronetrack  API

# Pre-Requisites and Installation
## Prerequisites

You will need to create an account on Dronetrack and get clientId, clientSecret and redirect url to receive access token value.
Also you need bundler to install gems.
If you are going to run tests you have to install [PhantomJS](http://phantomjs.org/) too.

## Installation 

Add to your project gem file line

```
gem 'dronetrack'

```

and run then 

```shell
bundle

```

---

---

# Using Dronetrack Client

```
require 'dronetrack'
```

## Drone

Type Drone allows user to manage user's drones

```
drone_api = Dronetrack::Drone.new('baseUrl', 'accessToken') # you can get accessToken with Dronetrack::OAuthHelper

```

### Getting drones
```
drones = drone_api.all()
```

### Getting drone by id
```
drone = drone_api.get(id)
```

### Creating drone
```
drone = drone_api.create('name' => name})
```

### Updating drone
```
data = {'id' => id, 'name' => name}
drone = drone_api.update(data)
```

### Removing drone
```
drone_api.remove(id)
```

### Adding points to new or exisiting track of drone
```
# Adding points to new track
res = drone_api.add_points(id, [{latitude: latitude, longitude: longitude, timestamp: timestamp}, ...]) 
# res.trackId will be contain id of created track 

# Adding points to exisiting track
drone_api.add_points(id, trackId, [{latitude: latitude, longitude: longitude, timestamp: timestamp }, ...]) 

```

### Import points from CSV or KML files to new tracks of drone

```
# Import points to new tracks from csv files
# New track will be created for each file. File name  without extension will be used as track name.
drone_api.import_points_from_files(id, ['/path/to/file1', ...], :csv) 

# Import points to new tracks from kml files
drone_api.import_points_from_files(id, ['/path/to/file1', ...], :kml) 


```


## Track

Type Track allows user to manage tracks tracks

```
track_api = Dronetrack::Track.new('baseUrl', 'accessToken'); # you can get accessToken with Dronetrack::OAuthHelper

```

### Getting tracks
```
tracks = track_api.all()
```

### Getting track by id
```
track = track_api.get(id)
```

### Creating track
```
data = {'name' => name, 'deviceId' => droneId}
track = track_api.create(data)
```

### Updating track
```
data = {'id' => id, 'name' => name}
track_api.update(data)
```

### Removing track
```
track_api.remove(id)
```

### Getting points
```
points = track_api.get_points(id)
```

### Adding points to track
```
points = track_api.add_points(id, [{latitude: latitude, longitude: longitude, timestamp: timestamp}, ...]) 

```

### Import points from CSV or KML files to  track

```
# Import points to new tracks from csv files
# All exisiting points will be overwriten
track_api.import_points_from_files(id, ['/path/to/file1', ...], :csv) 

# Import points to new tracks from kml files
track_api.import_points_from_files(id, ['/path/to/file1', ...], :kml) 


```

## OAuthHelper

Dronetrack API uses OAuth 2.0 to authorize user. To get access token you can use type  OAuthHelper

```
auth = Dronetrack::OAuthHelper.new('baseUrl', 'clientId', 'clientSecret', 'redirectUrl') # you must receive clientId, clientSecret and redirectUrl from Dronetrack site
```

### Getting OAuth 2.0 access token

```
auth.getAccessToken lambda { |url, callback|
    # You should redirect to this 'url' (for web apps) or open this 'url' in browser (for other apps)
    # User will sign in on Dronetrack site (if need) and confirm decision to allow your app to work with Dronetrack API.
    # Then Dronetrack site will redirect user to 'redirectUrl' putting pin code value as query parameter 'code' (for web apps)
    # If your 'redirectUrl' is 'http://localhost' (for non-web apps) pin code will be shown to user. You should promt to enter this value by user.
    # Anyway you should pass this code as first parameter of callback function (like callback(code))
} do |accessToken|
    # use access token
end

# You should save accessToken value to use it in future.

```

