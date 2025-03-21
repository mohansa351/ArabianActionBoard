import 'package:firebase_messaging/firebase_messaging.dart';
import '../screens/intro/biometric_authentication.dart';
import '../screens/dashboard/dashboard_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../utils/common_widgets.dart';
import 'credential_controller.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import 'package:get/get.dart';
import 'dart:convert';

class AuthController extends GetxController {
  final LocalAuthentication localAuth = LocalAuthentication();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String authStatus = "Not Authenticated";
  List<BiometricType> availableBiometrics = [];
  UserModel? userData;
  bool authLoader = false;

  String checkNullValue(val) {
    if (val != null && val != "") {
      return val;
    } else {
      return "Not available";
    }
  }

  void updateLoader(bool val) {
    authLoader = val;
    update();
  }

  ////
  ////
  //// User sign in
  Future<void> userSignIn(context, String email, String password) async {
    updateLoader(true);
    try {
      var headers = {
        'Content-Type': 'application/json',
      };
      var request = http.Request('POST', Uri.parse(loginUrl));
      request.body = json.encode({"email": email, "password": password});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        print(responseData);

        if (responseData["success"] == true) {
          var data = responseData["data"]["user"];
          await credentialController.storeUserId(
            data["_id"].toString(),
            trimToken(response.headers['set-cookie'].toString()),
            data["username"].toString(),
            password,
          );
          userData = UserModel(
              id: checkNullValue(data["_id"]),
              email: checkNullValue(data["email"]),
              userName: checkNullValue(data["username"]),
              firstName: checkNullValue(data["firstname"]),
              lastName: data["lastname"] ?? "",
              phone: checkNullValue(data["mobileNo"]),
              middleName: data["middlename"] ?? "",
              companyCode: data["companyCode"] ?? "",
              companyName: checkNullValue(data["companyName"]),
              fcmToken: "");
          update();
          Future.microtask(() => updateFcmToken());
          Get.off(() => const DashboardScreen());
        }
      } else if (response.statusCode == 404) {
        showToast("Invalid credentials");
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
      updateLoader(false);
    } finally {
      updateLoader(false);
    }
  }

////
////
////
  Future<void> updateFcmToken() async {
    try {
      String? token;

      // // Determine the platform and fetch the corresponding token
      // if (Platform.isIOS) {
      //   // token = await _firebaseMessaging.getAPNSToken() ?? '';
       
      //   print(token);
      //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>");
      // } else {
      //   token = await _firebaseMessaging.getToken() ?? '';
      // }

       token = await _firebaseMessaging.getToken() ?? '';

      if (token != "" && token.isNotEmpty) {
        var headers = {
          'Content-Type': 'application/json',
          'Cookie': credentialController.userCookie
        };
        var request = http.Request('POST', Uri.parse(updateTokenUrl));
        request.body = json.encode({"fcmToken": token});
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          final res = await response.stream.bytesToString();
          var responseData = json.decode(res);

          print(responseData);

          fetchUserInfo(false, false, true);
        } else {
          print(response.reasonPhrase);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

////
  // Future<String?> getTokenByUserId(String userId) async {
  //   try {
  //     // Query Firestore for the document with the matching userId
  //     QuerySnapshot querySnapshot = await _fireStore
  //         .collection('users')
  //         .where('userId', isEqualTo: userId)
  //         .limit(1)
  //         .get();

  //     // Check if a document exists and return the token
  //     if (querySnapshot.docs.isNotEmpty) {
  //       String token = querySnapshot.docs.first['token'] as String;
  //       print("Token for userId $userId: $token");
  //       return token;
  //     } else {
  //       print("No token found for userId $userId.");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error fetching token: ${e.toString()}");
  //     return null;
  //   }
  // }

/////
  // Future<void> checkAndClearTokenByUserId(String userId) async {
  //   try {
  //     // Query Firestore for the document with the matching userId
  //     QuerySnapshot querySnapshot = await _fireStore
  //         .collection('users')
  //         .where('userId', isEqualTo: userId)
  //         .limit(1)
  //         .get();

  //     // Check if a document exists
  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Get the token
  //       String token = querySnapshot.docs.first['token'] as String;

  //       // If token exists, clear it by setting it to an empty string
  //       await _fireStore
  //           .collection('users')
  //           .doc(querySnapshot.docs.first.id)
  //           .update({'token': ""});

  //       print("Token for userId $userId cleared.");
  //     }
  //   } catch (e) {
  //     print("Error checking and clearing token: ${e.toString()}");
  //   }
  // }

  ////
  ////
  //// User sign in
  Future<void> fetchUserInfo(bool signin, bool notification, bool token) async {
    updateLoader(true);
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request(
          'GET', Uri.parse('$userInfoUrl${credentialController.userId}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

    

        if (responseData["success"] == true) {
          var data = responseData["data"]["user"];
          userData = UserModel(
            id: checkNullValue(data["_id"]),
            email: checkNullValue(data["email"]),
            userName: checkNullValue(data["username"]),
            firstName: checkNullValue(data["firstname"]),
            lastName: data["lastname"] ?? "",
            phone: checkNullValue(data["mobileNo"]),
            middleName: data["middlename"] ?? "",
            companyCode: data["companyCode"] ?? "",
            companyName: checkNullValue(data["companyName"]),
            fcmToken: checkNullValue(data["fcmToken"]),
          );
          update();
          if (!notification) {
            if (signin) {
              Get.off(() => const DashboardScreen());
            } else {
              if (!token) {
                Get.offAll(() => const BiometricAuthentication());
              }
            }
          }
        }
      } else {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);

        if (responseData["message"] == "session expired") {
          credentialController.logoutUser();
          showToast("Session expired");
        }

        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      updateLoader(false);
    }
  }

  ////
  ////
  //// Biometric authentication process

  Future<void> deviceAuth() async {
    try {
      bool isBiometricAvailable = await localAuth.canCheckBiometrics;

      bool isDevicePinAvailable = await localAuth.isDeviceSupported();

      if (isBiometricAvailable && isDevicePinAvailable) {
        // Authenticate the user
        bool isAuthenticated = await localAuth.authenticate(
          localizedReason: 'Authenticate to access the app',
          options: const AuthenticationOptions(
            biometricOnly: false,
            stickyAuth: true,
          ),
        );

        if (isAuthenticated) {
          Get.off(() => const DashboardScreen());
        } else {
          SystemNavigator.pop();
        }
        update();
      } else {
        Get.off(() => const DashboardScreen());
      }
    } catch (e) {
      authStatus = "Error: ${e.toString()}";
      update();
    } finally {
      print(authStatus);
    }
  }

  ////
  ////
  Future<void> logout() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': credentialController.userCookie
      };
      var request = http.Request('POST', Uri.parse(logoutUrl));
      // request.body = r'<file contents here>';

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final res = await response.stream.bytesToString();
        var responseData = json.decode(res);
        print(responseData);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
