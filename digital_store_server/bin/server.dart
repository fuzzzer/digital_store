import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:shelf/shelf_io.dart';
import 'package:sqlite3/sqlite3.dart';
import 'core/config.dart';
import 'core/global_info.dart';
import 'router/router.dart';

void main(List<String> args) async {
  final db = sqlite3.open(Env.databaseLocation);
  const secretKey = Env.secretKey;

  final ip = InternetAddress.anyIPv4;

  final server = await serve(
      DigitalStoreRouter(database: db, secretKey: secretKey).handler, ip, port);
  print('Server listening on port ${server.port}');
}











// creating tables:

// db.execute('''
//     create table cart
// (
//     id          text    not null
//         constraint cart_pk
//             primary key,
//     modified_at text not null
// );

// create unique index cart_id_uindex
//     on cart (id);

//   create table user
// (
//     id          text    not null
//         constraint user_pk
//             primary key,
//     username     text not null,
//     password     text not null,
//     salt         text not null,
//     balance      real    default 0,
//     is_admin     integer default 0 not null,
//     first_name   text not null,
//     last_name    text not null,
//     email        text not null,
//     birth_date   text not null,
//     phone_number text not null,
// adress       text not null,
//     sex          text not null,
//     created_at   text not null,
//     modified_at  text not null,
//     cart_id      text not null
//     constraint user_cart_id_fk
//                   REFERENCES cart
// );

// create unique index user_id_uindex
//     on user (id);

// create unique index user_username_uindex
//     on user (username);
    
// create unique index user_salt_uindex
//     on user (salt);

// create unique index user_cart_id_uindex
//     on user (cart_id);

// create table category
// (   id          text    not null
//         constraint category_pk
//             primary key,
//     title       text not null,
//     description text not null,
//     created_at  text not null,
//     modified_at text not null
// );

// create unique index category_title_uindex
//     on category (title);

// create table product
// (   id          text    not null
//         constraint product_pk
//             primary key,
//     title       text    not null,
//     description text    not null,
//     quantity    integer not null,
//     image       blob    not null,
//     size        text    not null,
//     rating      real    not null,
//     color       text    not null,
//     price       real    not null,
//     created_at  text    not null,
//     modified_at text    not null

// );

// create unique index product_id_uindex
//     on product (id);

// create table product_category
// (
//     id          text not null
//         constraint product_category_pk
//             primary key,
//     category_id text not null
//     constraint product_category_category_id_fk
//                   REFERENCES category,
//     product_id text not null
//     constraint product_category_product_id_fk
// REFERENCES product

// );

// create unique index product_category_id_uindex
//     on product_category (id);

// create table cart_item
// (
//     id          text    not null
//         constraint cart_item_pk
//             primary key,
//     quantity    integer not null,
//     created_at  text    not null,
//     modified_at text    not null,
//     cart_id     text    not null
//         constraint cart_item_cart_id_fk
//                   REFERENCES cart,
//     product_id  text not null
//     constraint cart_item_product_id_fk
//                   REFERENCES product
// );

// create unique index cart_item_id_uindex
//     on cart_item (id);

// create table "order"
// (
//     id          text    not null
//         constraint order_pk
//             primary key,
//     quantity    integer not null,
//     created_at  text    not null,
//     modified_at text    not null,
//     product_id  text     not null
//         constraint order_product_id_fk
//                   REFERENCES product,
//     user_id   text not null
//         constraint order_user_id_fk
//                   REFERENCES user
// );

// create unique index order_id_uindex
//     on "order" (id);


// create table product_review
// (
//     id          text not null
//         constraint product_review_pk
//             primary key,
//     rating      real not null,
//     review      text not null,
//     created_at  text not null,
//     modified_at text not null,
//     product_id  text not null
//         constraint product_review_product_id_fk
//                   REFERENCES product,
//     user_id     text not null
//         constraint product_review_user_id_fk
//                   REFERENCES user

// );

// create unique index product_review_id
//     on product_review (id);


//   ''');
