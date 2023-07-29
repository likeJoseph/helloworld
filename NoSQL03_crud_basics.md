### Exercise 1
Perform the following operations on the “movies” collection:
1. Insert a new movie the following details: 
 ⇒ title: “Inception”, genre: “Action”
2. Find the document.
3. Insert multiple movies at once: 
⇒ title: “Pulp Fiction”, genre: “Crime”
⇒ title: “The Godfather”, genre: “Crime”

```javascript
use crud
db.movies.insertOne({title: "Inception", genre: "Action"})
db.movies.insetMany([{title: "Pulp Fiction", genre: "Crime"}, {title: "The Godfather, genre: "Crime"}])
```

### Exercise 2
Perform the following operations on the “movies” collection:
1. Set a score field to 87 for a document that `title` is “Inception”.
2. Set a score field to 92 for documents that `genre` is “Crime”.
```javascript
db.movies.updateOne({title: "Inception"}, {$set: {score: 87}})
db.movies.updateMany({genre: "Crime"}, {$set: {score: 92}})
```
Perform the following operations on the “movies” collection:
1. Upsert a `genre` field to “Comedy” for a document where the `title` is “Parasite”.
2. Upsert a `director` field to “Christopher Nolan” for a document where the `title` is “Inception”.
3. Print all the documents.
```javascript
db.movies.updateOne({title: "Parasite"}, {$set: {genre: "Comedy"}, {upsert: true}})
db.movies.updateOne({title: "Inception"}, {$set: {director: "Christopher Nolan}}, {upsert: true})
```

### Exercise 3
Perform the following operations on the “movies” collection:
1. Delete documents where `score` is 92. 
2. Print all documents.
   
```javascript
db.movies.deleteMany({score: 92})
```
