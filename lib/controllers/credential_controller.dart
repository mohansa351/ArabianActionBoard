import 'package:bizlogika_app/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import '../screens/intro/signin_screen.dart';

final CredentialController credentialController = CredentialController();

class CredentialController extends GetxController {
  String userId = "";
  String userCookie = "";
  String userName = "";
  String password = "";

  storeUserId(String val, String cookie, user, pass) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', val);
      await prefs.setString('cookie', cookie);
      await prefs.setString('user_name', user);
      await prefs.setString('password', pass);
      userId = prefs.getString('user_id') ?? "";
      userCookie = prefs.getString('cookie') ?? "";
      userName = prefs.getString('user_name') ?? "";
      password = prefs.getString('password') ?? "";

      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getUserId(bool notification) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? "";
    userCookie = prefs.getString('cookie') ?? "";
    userName = prefs.getString('user_name') ?? "";
    password = prefs.getString('password') ?? "";
    update();

    if (userId != "" && userCookie != "") {
      Future.microtask(()=> Get.find<AuthController>().fetchUserInfo(false, notification, false));
      
    } else {
      Get.offAll(() => const SignInPage());
    }
  }

  logoutUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await Future.microtask(
          () => Get.find<AuthController>().logout());
      await prefs.setString('user_id', "");
      await prefs.setString('cookie', "");
      await prefs.setString('user_name', "");
      await prefs.setString('password', "");
      userId = prefs.getString('user_id') ?? "";
      userCookie = prefs.getString('cookie') ?? "";
      userName = prefs.getString('user_name') ?? "";
      password = prefs.getString('password') ?? "";
      update();
      Get.offAll(() => const SignInPage());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getOAuthToken() async {
    try {
      // final jsonKey =
      //     File('assets/json/firebase.json').readAsStringSync();
      final serviceAccountCredentials =
          auth.ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "bizlogika-app",
        "private_key_id": "9e923a858ae40ab2dd94eeb54f4544be7bccca82",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC76nM+/7lf6zvK\n1yQV2wVmCgHYDeG420wakp4Wnk2MC2nc7YTmk5DIAqSyvKWxVD2qyBmqogL4ZfuJ\nuT7xVMvKCsCgSf9frkmv6k2wy6Oqz1RI9DgsNUb1NtQVKT0ozg6cf06KaZD7Op0t\n5CsbOa1/ot5X2Vm4livTwypSBUFrR7osl7ALTjsmgRZwB0MtKKGHLcowcDly0Abn\nWh/TX9dw2F88PwkBWO8xg9y5w1pE3sLWZ2mWMKWRUUmMB9D90jeMBm/lGFCBInTR\neCp6VBI5C3Yktea4XoXTOsDOYTgZLFWFopEoUALQbGNioZk1KcQP/v0P4QNuKqRJ\nQ0k3LXrDAgMBAAECggEAAY+PSNJWQiixr3FIAx0gQgUKl4vN+HtsehAGW3O8eyb2\ncyJPPJxfKHofz2g9DBMCDB1rW9J1VIYsUlbajKXtUg6dePdZtVFnmpwclxT/QAJG\n1fBJWHyndo6aW66jARLCZk8HDPlBfgSyR4Oh+VuU8v7G+qh7KUr+BDKWcxCeHCZR\nuHWlfZ1p+xk0TWeX872Gp+bDHu3PYSTMF0va8yt3Uch+g91olYonlWoG7vEKtijb\npAtNr9rsrZnfgmYLCfV1yTP+/waApaE48rU4ewEAmDwZXcPSSGVBsbk4upL6oPq2\n67wqDM4ZsdJXf9ewv9tPdNfcmpmJBm2h9BbSrDLxeQKBgQDcvKPocVTBNFpF5JtN\nvFQQS5krgQK/56zLNyIO/BW8LxcJNPbWYs6hnZKMYw3AXZbKQRfoUNf0ikzR3Bez\n68A96YFNTG0Vgyu5hmnR+TQModNOC5x77snRP6lKyNVJ8+XgaT4FW8ri2/xfhUZb\n33RV3Ad8pvn22I0+6UpPS5sIbwKBgQDZ74tlf9bdQHKocIG9AST1hOhSpFRnYVrG\nYgSH0KqZ9sBpdJWWCKMrwyfcqN3lhupRhBeqbQjNoBN3FtShYXkXQ+98ad/mvwFG\n2SoBPIw5DjFKLiytT60eZz4pdXVqy3F1XqpAaJbC30HGU0/8zZtqrpDEEp2LlSYS\n48MA9uIU7QKBgHC1JWAPVf5cs+dSJfZYPfggEbKD6hqAudr9aLeMAbEXvkRmNc8b\nnnQpF+X0wdXCM7dL62Akv0/OuhDBt5yXuI4kR3BnoJ9GXbIaLrgW7XuxuUn1Zc5m\nC8h7H/7ecwGStoKSWie0SfDx8Hf5fgZ1H1qjwXLlc2aWBfDkf5vjd+KjAoGBAMco\nQyjkJIRYSu9msQj5rL65UF2FUqSOsRetpxo+NEky1y8HnVNYXVS2qQzbPLxuCF+p\n6L6TmYHfkSo5MOKxYqlCKe52CmihkBcgiWRL4pCZSa3SeH2A3GF2U7YrYrvPYsWx\nVsA5U9yNjVwh8mzBsA9Tq3Oi11ohWIPWo/OTqZMZAoGBAM6mJwA6psW7W9uLr+3C\nbqw7py/+TzJP2sOnRgl+tgEAJIHx2IOeHAw438vhp0OvAyumUmsKzyk9+Y6j3Qck\n2VGilJ8h8re8NcLn+Nn5rb3d7PNu2lQEdhPFRfnYgJwTH/LasyERvCrXsflf05g5\nnnXiVLq8Z4b3jWayCbP8zw09\n-----END PRIVATE KEY-----\n",
        "client_email": "bizlogika@bizlogika-app.iam.gserviceaccount.com",
        "client_id": "117262885303674513091",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/bizlogika%40bizlogika-app.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      });

      final scopes = [
        "https://www.googleapis.com/auth/firebase.messaging",
      ];

      final client =
          await auth.clientViaServiceAccount(serviceAccountCredentials, scopes);

      final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        serviceAccountCredentials,
        scopes,
        client,
      );

      // Get the access token from the authenticated client
      final accessToken = credentials.accessToken.data.toString();

      client.close();

      print(accessToken);

      return accessToken;
    } catch (e) {
      print(e.toString());
      return "";
    } // Returns the OAuth token
  }
}


