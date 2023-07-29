# LAB Geospatial

## Geo 1

### Exercise 1

```javascript
db.states.createIndex({'loc': '2dsphere'})
db.states.getIndexes()
db.states.dropIndex({'loc': '2dsphere'})
db.states.getIndexes()
```

### Exercise 2

```javascript
var z = db.small_zips.find({'_id': '10044'})
var ny = db.states.findOne({'code': z['state']})

db.airports.find({'loc': {'$geoWithin': {'$geometry': ny['loc']}}, 'type': 'International'}, {'name': 1, '_id': 0}).sort({'name': 1})
```


### Exercise 3

```javascript
db.airports.find({'type': 'International'}).forEach((d) => {
    var res = db.restaurants.findOne({'cuisine': 'Korean', 'address.coord': {'$geoWithin': {'$centerSphere': [d['loc']['coordinates'], 2 / 6378.1]}}}); 
    if (res != null) printjson(res); 
});
```

### Exercise 4

```javascript
var lax = db.airports.findOne({'code': 'LAX'})
var dtw = db.airports.findOne({'code': 'DTW'})
var geojson = {
    'type': 'LineString', 
    'coordinates': [lax['loc']['coordinates'], dtw['loc']['coordinates']]
};

db.states.find({'loc': {'$geoIntersects': {'$geometry': geojson}}}, {'name': 1, '_id': 0}).sort({'name': 1})
```

