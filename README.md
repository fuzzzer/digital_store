# digital_store_dart
This digital store is written fully in dart,\
using shelf library for running server,\
SQLite as database and flutter for front end. \
\
In order to start application you need first to add .env file in project directory and then \
set it up and run it on localhost for testing. \
`SECRET_KEY=28K7I86GU-A6Y7HYFCJKOO9-8733GYTGJKU-998IUNND (or your secret key)` \
`DATABASE_LOCATION='project location'/digital store/digital_store_server/databases/digital_store_database.db` \
`IP_ADRESS="localhost" `

after you set up .env you can go ahead and run: \
 `dart pub get` \
 `dart pub run build_runner build` 

after this you can start the server: \
run from digital_store_server project directory: \
 `dart run bin/server.dart `

after you start the server \
you can manualy send requests given in the server readme file. \
or run the flutter app from emulator. \
unless server is hosted and you are not run it on local ip, \
you can't run the app on the real mobile phone. \
So only available option is Android or ios emulator. 

To run digital_store user end application from emulator, \
select target device from your editor and \
run this command from digital_store_flutter project directory: \
`flutter run lib/main.dart `


