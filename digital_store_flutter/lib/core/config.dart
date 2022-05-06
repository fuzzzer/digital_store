// import 'package:envify/envify.dart';

import 'dart:io' show Platform;

final String ipAdress = Platform.isAndroid ? '10.0.2.2' : '0.0.0.0';
const String port = '8086';



// part 'config.g.dart';

// @Envify()
// abstract class Env {
//   static const ipAdress = _Env.ipAdress;
// }
