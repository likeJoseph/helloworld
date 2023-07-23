### Exercise 1
```javascript
use crud
db.movies.insertOne({title: "Inception", genre: "Action"})
db.movies.insetMany([{title: "Pulp Fiction", genre: "Crime"}, {title: "The Godfather, genre: "Crime"}])
```

### Exercise 2
```javascript
db.movies.updateOne({title: "Inception"}, {$set: {score: 87}})
db.movies.updateMany({genre: "Crime"}, {$set: {score: 92}})
db.movies.updateOne({title: "Parasite"}, {$set: {genre: "Comedy"}, {upsert: true}})
db.movies.updateOne({title: "Inception"}, {$set: {director: "Christopher Nolan}}, {upsert: true})
```

### Exercise 3
```javascript
db.movies.deleteMany({score: 92})
```
