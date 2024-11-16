import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vergoes_mobile_app/blocs/auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email')),
            TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                    LoginEvent(emailController.text, passwordController.text));
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
