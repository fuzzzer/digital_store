# digital_store_dart
This digital store is written fully in dart,\
using shelf library for running server,\
SQLite as database and flutter for front end. \
\
In order to start application you need first to add .env file in digital_store_server project directory and then \
set it up and run it on localhos. \
`SECRET_KEY=28K7I86GU-A6Y7HYFCJKOO9-8733GYTGJKU-998IUNND (or your secret key)` \
`DATABASE_LOCATION='project location'/digital store/digital_store_server/databases/digital_store_database.db` \
`IP_ADRESS="localhost" `

after you set up .env you can go ahead 
and run from digital_store_server project directory: \
 `dart pub get` \
 `dart pub run build_runner build` 

after this you can start the server by runing: \
 `dart run bin/server.dart `

after you start the server \
you can manualy send requests on urls given in the server readme file. \
or run the flutter app from emulator. \
if server is not hosted and you are running it on local ip, \
you can't run the app on the real mobile phone. \
So only available option is Android or ios emulator. 

To run digital_store_flutter user end application from emulator, \
select target device from your editor and \
run this command from digital_store_flutter project directory: \
'flutter pub get'
`flutter run lib/main.dart `


