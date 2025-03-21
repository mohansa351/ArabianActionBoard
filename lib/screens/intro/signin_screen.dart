import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/common_widgets.dart';
import '../../utils/constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hidePass = true;

  String token = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              child: Image.asset(logo, width: screenWidth(context)),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(' Hi, Welcome Back!',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 30),
                const Text(
                  ' Your Email ID',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Enter your email address",
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 25),
                const Text(
                  ' Password',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: hidePass,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      hidePass = !hidePass;
                      setState(() {});
                    },
                    child: hidePass
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
                const SizedBox(height: 45),
                // Text(token),
                GetBuilder<AuthController>(
                  builder: (AuthController controller) {
                    return controller.authLoader
                        ? const CustomLoader()
                        : CustomButton(
                            onTap: () {
                              if (_emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                controller.userSignIn(
                                    context,
                                    _emailController.text,
                                    _passwordController.text);
                              } else {
                                showToast("Kindly fill all the fields");
                              }
                            },
                            title: 'Login',
                          );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
