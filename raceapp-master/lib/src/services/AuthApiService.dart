import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:app_races/src/models/UserCredentials.dart';
import 'package:app_races/src/responses/RegisterResponse.dart';
import 'package:app_races/src/services/ApiService.dart';
import 'package:http/http.dart' as http;

class AuthApiService extends ApiService {
  static final baseUrl = ApiService.baseUrl;

  AuthApiService({String token = ''}) : super(token: token);

  Future<String> login(UserCredentials credentials) async {
    final response = await http.post("${baseUrl}/api_user/login",
        headers: {"Content-Type": "application/json"},
        body: credentials.toJson());

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final token = body['token'];
      return token;
    }
  }

  Future<RegisterResponse> register(UserCredentials user) async {
    try {
      final response = await http.post("${baseUrl}/api_user/signup",
          headers: {"Content-type": "application/json"}, body: user.toJson());

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        final body = json.decode(response.body);
        token = body['token'];
        return RegisterResponse.success(token, 'Usuario registrado con exito');
      } else if (response.statusCode != 201) {
        final error = json.decode(response.body);
        print(error);
        switch (error["message"]) {
          case 'User duplicate':
            return RegisterResponse.userDuplicate('El usuario ya existe');
          case '"Password is too short"':
            return RegisterResponse.passwordShort('Contraseña demasiado corta');
          case '"Email format is invalid"':
            return RegisterResponse.emailInvalid(
                'Correo electronico no valido');
          case '"Email and password are required"':
            return RegisterResponse.emailPasswordRequired(
                'Email y contraseña obligatorios');
          default:
            return RegisterResponse.unknowError('Error desconocido');
        }
      }
    } catch (e) {
      return RegisterResponse.networkError('Error de conexion');
    }
  }

  bool isTokenValid() {
    return !JwtDecoder.isExpired(token);
  }
}
