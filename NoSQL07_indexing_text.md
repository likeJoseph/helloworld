# Text LAB

## Exercises

### Exercise 1

```javascript
db.restaurants.find({'$text': {'$search': 'Poke'}}, {'_id': 0, 'name': 1, 'address': 1});
```

### Exercise 2

```javascript
var r = db.restaurants.findOne({'$text': {'$search': '\"Nolbu Restaurant\"'}});
db.states.find({'loc': {'$geoIntersects': {'$geometry': {'type': 'Point',
'coordinates': r["address"]["coord"]}}}}, {'name': 1, '_id': 0});
```

### Exercise 3

```javascript
var kor = db.restaurants.findOne({'$text': {'$search': 'Ramen -Izakaya'}, 'cuisine': 'Korean'});
db.restaurants.find({'cuisine': 'Japanese',
 'address.coord': {'$geoWithin': {'$centerSphere': [kor['address']['coord'], 0.15 / 6378.1]}}});
```

