import 'package:flutter/material.dart';

class LoginWidget extends StatefulWidget {
  Function(String) onChangeField;
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _showPassword = false;

  String _emailValidator(String email) {
    final emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (!emailValid) {
      return 'El email insertado no es valido';
    }
  }

  String _passwordValidator(String password) {
    if (password.length < 3) {
      return 'La constraseña no puede tener menos de 3 caracteres';
    }
  }

  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: Icon(
          Icons.email,
          color: Colors.green,
        ),
        title: TextFormField(
          onChanged: widget.onChangeField,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Correo electronico',
          ),
          validator: _emailValidator,
        ),
      ),
      ListTile(
        leading: Icon(
          Icons.security,
          color: Colors.green,
        ),
        title: TextFormField(
          validator: _passwordValidator,
          obscureText: !_showPassword,
          onChanged: widget.onChangeField,
          decoration: InputDecoration(
              hintText: 'Contraseña',
              suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  })),
        ),
      ),
    ]);
  }
}
