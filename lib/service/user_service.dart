import '/config/net/app_dio.dart';
import '/model/user.dart';
import '/utils/string_utils.dart';

class UserService {
  static const String _loginApi = 'user/login';

  static AppDio get http => AppDio.instance;

  static Future<User> login({
    required String username,
    required String password,
  }) async {
    final response = await post(_loginApi, data: {
      'username': username,
      'password': StringUtils.toMD5(password),
    });
    return User.fromJson(response.data!);
  }
}
