### Exercise 1
```javascript
// Exercise 1-1 
db.inventory.find({tags: {$all: ["appliance", "school", "book"]}}).pretty()

// Exercise 1-2
db.inventory.find({}, {tags: {$slice: [1, 3]}}).pretty()

// Exercise 1-3
db.inventory.find({qty: {$elemMatch: {size: "6", color: "blue"}}}).pretty()
```

### Exercise 2
```javascript
// Exercise 2-1
db.store.find({"items.name": "iPhone Xs"}).pretty()

// Exercise 2-2
db.store.find({"items.price": {$lt: 400}}, {_id: 0, "buyer.name": 1})
```

### Exercise 3 
```javascript
// Exercise 3-1
db.inventory.count()
db.inventory.find().limit(2).pretty()

// Exercise 3-2
db.store.find({}, {_id: 0, "buyer.method": 1}).skip(3).limit(2)
```

### Exercise 4
```javascript
// Exercise 4-1
db.posts.insertOne({name: "Lee", content: "Hello, I'm Lee", tags: ["Hello", "Greet"]})
db.posts.updateOne({name: "Lee"},
    {$push: {comments:
        {$each: [
             {name: "Kim", content: "Good posts.", like: 3},
             {name: "Koo", content: "Coffee please.", like: 2},  
             {name: "Han", content: "Bagels are not croissants.", like: 1},
             {name: "Kim", content: "Welcome!", like: 3}
             ] }
        } } )

// Exercise 4-2
db.posts.updateOne({name: "Lee"}, {$set: {"comments.1.like": 0}})
db.posts.updateOne({name: "Lee", "comments.name": "Kim"}, {$set: {"comments.$.like": 5}})

// Exercise 4-3
db.posts.updateOne({name: "Lee"}, {$set: {"comments.$[xy].like": 6}}, {arrayFilters: [ { "xy.like": { $gte: 3 } } ] } )

// Exercise 4-4
db.posts.updateOne({name: "Lee"}, {$set: {"comments.$[].like": 1}})

// Exercise 4-5
db.posts.updateOne({name: "Lee"}, {$pop: {comments: 1}})
db.posts.updateOne({name: "Lee"}, {$pull: {comments: {name: "Koo"}}})
db.posts.updateOne({name: "Lee"}, {$unset: {content: 1}})
```
