import 'package:jwt_decoder/jwt_decoder.dart';

abstract class ApiService {
  static final baseUrl = 'http://192.168.1.19:5050';
  String token;

  ApiService({this.token = ""});

  int getUserIdFromToken(String token) {
    final mapJwt = JwtDecoder.decode(token);
    return int.parse(mapJwt['sub']);
  }
}
