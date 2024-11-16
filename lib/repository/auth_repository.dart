import 'package:vergoes_mobile_app/models/user_model.dart';

class AuthRepository {
  Future<User> login(String email, String password) async {
    // Simulate a fake API call
    await Future.delayed(Duration(seconds: 2));
    return User(id: '123', name: 'John Doe', email: email); // Fake data
  }
}
