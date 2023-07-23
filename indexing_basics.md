### Exercise 1
```javascript 
// Exercise 1-1
db.blog.find({writer: "Kim"}).explain("executionStats")

// Exercise 1-2
db.blog.createIndex({writer: 1})

// Exercise 1-3
db.blog.find({writer: "Kim"}).explain("executionStats")

// Exercise 1-4
db.blog.createIndex({_id: -1, writer: 1})

// Exercise 1-5
db.blog.dropIndexes()
``` 

### Exercise 2
```javascript
// Exercise 2-1
db.metro.createIndex({doc_id: 1}, {unique: true})
db.metro.createIndex({line_num: 1}, {unique: true})
MongoServerError: E11000 duplicate key error collection: lab.metro index: line_num_1 dup key: { line_num: "1호선" }
db.metro.createIndex({intersect: 1}, {sparse: true})
db.metro.createIndex({instersect_id: 1}, {unique: true, spare: true})
MongoServerError: E11000 duplicate key error collection: lab.metro index: instersect_id_1 dup key: { instersect_id: null }
db.metro.createIndex({ride_psgr_num: 1}, {partialFilterExpression: {ride_psgr_num: {$gt: 10000}}})

// Exercise 2-2
db.metro.find().sort({doc_id: 1}).limit(2).explain("executionStats")
db.metro.find().sort({doc_id: 1}).limit(2).hint({intersect: 1}).explain("executionStats")

// Exercise 2-3

// 1
db.metro.dropIndexes()
db.metro.find({sub_sta_nm: "서울대입구(관악구청)"}).explain()
db.metro.createIndex({sub_sta_nm: 1})
db.metro.find({sub_sta_nm: "서울대입구(관악구청)"}).explain()

// 2
db.metro.dropIndexes()
db.metro.find({ride_pasgr_num: {$gt: 100000}, alight_pasgr_num: {$gt: 100000}}).explain()
db.metro.createIndex({ride_pasgr_num: 1, alight_pasgr_num: 1})
db.metro.find({ride_pasgr_num: {$gt: 100000}, alight_pasgr_num: {$gt: 100000}}).explain()

// 3
db.metro.dropIndexes()
db.metro.find({ride_pasgr_num: {$gt: 100000}, alight_pasgr_num: {$gt: 100000}}).sort({ride_pasgr_num: 1})
db.metro.createIndex({ride_pasgr_num: 1, alight_pasgr_num: 1})
db.metro.find({ride_pasgr_num: {$gt: 100000}, alight_pasgr_num: {$gt: 100000}}).explain()
```