# MongoDB 사용법 가이드

MongoDB는 Document Database입니다.

RDB와 MongoDB의 대응 관계는 다음과 같습니다:
- Databse: Database
- Table: Collection
- Row: Document

따라서 Document를 만들기 위해서는 Collection이 필요하고, Collection이 존재하기 위해서는 Database가 있어야 합니다.

## Step 1. Mongo Shell 접속

Mongo shell은 MongoDB에서 데이터를 조작하기 위한 도구입니다. Windows CMD는 현재 로컬 컴퓨터 전체를 다루기 위한 도구이므로, 로컬 컴퓨터에 저장된 데이터셋 파일들을 MongoDB에 import하기 위해서는 mongo shell가 아닌 Windows CMD에서 조작해야 합니다.

```bash
# CMD에서 mongoimport 명령을 사용하여 데이터 import (lab 데이터베이스의 posts 컬렉션에 posts.json 파일을 import)
mongoimport -d lab -c posts posts.json

# mongo shell 접속
mongo
```

## Step 2. 데이터베이스 설정

mongo shell에 접속하면 기본적으로 test라는 데이터베이스가 선택되어 있습니다.

```javascript
> db
```
위 명령을 실행하면 현재 사용 중인 데이터베이스를 확인할 수 있습니다.

```javascript
> show dbs
```

위 명령을 통해 전체 데이터베이스 목록을 확인할 수 있습니다.

만약 mongoimport에서 posts.json을 저장한 database의 이름이 lab이고 해당 데이터베이스의 컬렉션을 이용하려면 데이터베이스를 변경해주셔야 합니다.

```javascript
> use lab
```

## Step 3. 컬렉션을 이용한 다큐먼트 조작

`db`는 global variable로서 `db` 변수를 사용하여 현재 데이터베이스 내의 컬렉션 및 문서와 상호 작용할 수 있습니다. 예를 들어 `db.collectionName`을 사용하여 특정 컬렉션에 액세스하고 찾기, 삽입, 업데이트 및 삭제와 같은 작업을 수행할 수 있습니다.

```javascript
> db.posts.find()
```

현재 선택한 데이터베이스에 어떤 컬렉션이 있는지 확인하려면 

```javascript
> show collections
```

위 명령을 실행하면 해당 데이터베이스의 컬렉션 목록을 확인할 수 있습니다.