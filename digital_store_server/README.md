A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This sample code handles HTTP GET requests to `/` and `/echo/<message>`

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8086
```

And then from a second terminal:
```
authentication directories:
$ curl -X POST http://localhost:8086/authentication/refresh   {post}
$ curl http://localhost:8086/authentication/sign-up   {post}
$ curl http://localhost:8086/authentication/sign-in   {post}
$ curl http://localhost:8086/authentication/sign-out   {get}

cart directories:
$ curl http://localhost:8086/cart/   {get, post}
$ curl http://localhost:8086/cart/<id>   {patch, delete}
$ curl http://localhost:8086/cart/checkout   {post}
$ curl http://localhost:8086/cart/clear/all   {delete}

category directories:
$ curl http://localhost:8086/categories/   {get}
$ curl http://localhost:8086/categories/   {post}
$ curl http://localhost:8086/categories/<id>   {patch}
$ curl http://localhost:8086/categories/<id>   {delete}

product directories:
$ curl http://localhost:8086/products/   {get, post}
$ curl http://localhost:8086/products/<id>   {get, patch, delete}
$ curl http://localhost:8086/products/purchase/<id>   {put}
$ curl http://localhost:8086/products/review/<id>   {put}

user directories: 
$ curl http://localhost:8086/user/   {delete}
$ curl http://localhost:8086/user/orders   {get}
$ curl http://localhost:8086/user/orders/<id>   {get}
$ curl http://localhost:8086/user/balance   {get, patch}
$ curl http://localhost:8086/user/profile   {get, patch}











todos
// after purchase balance and product quantities must update


# Digital Store

A system built from a RESTful service and its corresponding mobile client application.

## Assignment

In order to implement the system, mandatory tasks must be completed. Optional tasks exist for practicing purposes. It is recommended to alter the idea and certain implementations in order to feel more invested in the project, as long as the core principles and mandatory tasks will be fulfilled.

### Mandatory Tasks

#### Client

1. Write implementation in `Flutter`
2. Use `bloc` dependency for state management purposes and `flutter_bloc` dependency for UI
3. Have three user roles: `unauthenticated`, `consumer`, `administrator`
4. Conditionally manage state and render appropriate UI based on user role and actions (have at least one feature solely for `administrator` users)
5. Follow **Material Design** guidelines and use its components (from [Material You](https://m3.material.io) if available, otherwise from [Material Design 2](https://material.io))
6. Have at least one page suitable for tablet resolution
7. Implement user friendly error messages upon service errors and log more detailed messages on the developer side
8. Verify JWT before using it
9. Have a mechanism to refresh tokens if access token expires
10. Utitilze and cache JWT using [Hive](https://pub.dev/packages/hive)
11. **Make sure that the code is formatted and linter suggestions are implemented!** (use `flutter_lints` dependency as `dev` dependency, and only override the following rule: `prefer_single_quotes: true`)
12. Make sure to thoroughly test the application, look at the product from the end user's perspective and strive towards minimal, simple, yet efficient and beautiful features
13. Make sure that the application doesn't crash due to state management and that UI errors appear as infrequently as possible
14. Take inspiration from the following application [layering architecture](https://bloclibrary.dev/#/architecture)
15. Have easily readable code, write consistently, follow best practices, et cetera...
16. Make sure not to overcomplicate form/input elements and have them be as functional and easy to use as possible while also following design guidelines and leveraging different properties of text fields (follow the [design recommendations](https://www.material.io/components/text-fields))

#### Server

1. Have a working implementation of the server using `Dart` programming language

#### Database

1. Have a working database implementation bound to the aforementioned server through any DBMS (`SQLite` is preferred)

### Optional Tasks

#### Client

1. Have neatly structured theme system, and a light and a dark theme (hint: `ThemeData.light()` and `ThemeData.dark()`)
2. Implement animations
3. Use `Cupertino` widgets for `iOS` devices (hint: some widgets have `.adaptive()` method, such as `CircularProgressIndicator`; take a look at [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/) for general `iOS` design guidelines)
4. Write tests: `bloc` tests through `bloc_test` dependency, unit/widget/integration tests by following the [Flutter cookbook recipes](https://docs.flutter.dev/cookbook#testing)
5. Et cetera...

#### Server

1. Bind `OpenAPI` document (`digital-store.json`) to `Swagger UI` front-end to a certain endpoint in order to render API documentation
2. Utilize environment variables for handling sensitive data
3. Strive towards returning well-defined status codes based on action results
4. Have an environment variable for compiling the server for different environments (`local`, `development`, `testing`, `staging`, `production`) and only render `OpenAPI` document on its corresponding endpoint for `local`, `development` and `testing` environments
5. Delegate as much work as comfortably possible to database as it is usually faster than computing on the server
6. Make sure that the server is client-agnostic, meaning that it should not matter if the client is a mobile application, web application, command-line interface application, et cetera...
7. Et cetera...

#### Database

1. Avoid using ORM and write queries yourself
2. Take a primer on `SQL` and preferably `SQLite`
3. Research one-to-one, one-to-many and many-to-many relationships
4. Save images as `blob` data instead of simple `URL` strings for practicing purposes
5. Et cetera...
