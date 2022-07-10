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

