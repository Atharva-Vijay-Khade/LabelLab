import 'package:flutter/foundation.dart';
import 'package:labellab_mobile/data/repository.dart';
import 'package:labellab_mobile/model/auth_user.dart';
import 'package:labellab_mobile/model/register_user.dart';
import 'package:labellab_mobile/model/user.dart';

class AuthState with ChangeNotifier {
  final Respository _respository = Respository();

  // State
  User user;

  bool get isAuthenticated => user != null && user.id != null;
  bool get isLoading => user != null && user.id == null;

  AuthState() {
    user = User(username: "", name: "", email: "");
    notifyListeners();
    _respository.initToken().then((isSuccess) {
      if (isSuccess) {
        _respository.usersInfo().then((User user) {
          this.user = user;
          notifyListeners();
        });
      } else {
        this.user = null;
        notifyListeners();
      }
    }).catchError((err) {
      this.user = null;
      notifyListeners();
    });
  }

  Future<bool> signin(AuthUser user) {
    return _respository.login(user).then((response) {
      print("Success: " + response.token);
      return _respository.usersInfo().then((User user) {
        this.user = user;
        notifyListeners();
        return response.success;
      });
    });
  }

  Future<bool> register(RegisterUser user) {
    return _respository.register(user).then((response) {
      print("Success: " + response.token);
      _respository.usersInfo().then((User user) {
        this.user = user;
        notifyListeners();
        return response.success;
      });
    });
  }

  void signout() {
    _respository.logout().then((_) {
      user = null;
      notifyListeners();
    });
  }
}