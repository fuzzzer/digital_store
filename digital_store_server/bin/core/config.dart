import 'package:envify/envify.dart';

part 'config.g.dart';

@Envify()
abstract class Env {
  static const secretKey = _Env.secretKey;
  static const databaseLocation = _Env.databaseLocation;
  static const ipAdress = _Env.ipAdress;
}
