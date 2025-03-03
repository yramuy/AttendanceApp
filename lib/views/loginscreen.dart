import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/logincontroller.dart';
import '../widgets/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (loginController) => Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              image: const DecorationImage(
                  image: AssetImage('assets/images/bgimg.png'),
                  alignment: Alignment.center,
                  opacity: 0.010)),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Form(
              key: loginController.formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        Constants.logoImage,
                        scale: 1.2,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.black54),
                      controller: loginController.emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Colors.black54)),
                        hintText: "Enter username or email or phone number",
                        hintStyle: const TextStyle(color: Colors.black54),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Colors.black54)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Colors.grey)),
                        errorBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(color: Colors.red)),
                      ),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Enter a valid email or username or phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.black54),
                      controller: loginController.passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Colors.black54)),
                        hintText: "Password",
                        suffixIcon: IconButton(
                            onPressed: () {
                              loginController.showPassword();
                            },
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.black54,
                            )),
                        hintStyle: const TextStyle(color: Colors.black54),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Colors.grey)),
                        errorBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Colors.red)),

                      ),
                      obscureText: loginController.showLoginPassword,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Enter a valid Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    _LoginBtn(loginController),
                    const SizedBox(
                      height: 20,
                    ),
                    _donotHaveAccount(),
                    _forgotPassword(),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Widget _inputField(hintText, controller, {isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.white));

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          enabledBorder: border,
          focusedBorder: border),
    );
  }

  Widget _LoginBtn(loginController) {
    return ElevatedButton(
      onPressed: () {
        if (loginController.formKey.currentState!.validate()) {
          loginController.login(loginController.emailController.text,
              loginController.passwordController.text);
        }
      },
      style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16)),
      child: const SizedBox(
          width: double.infinity,
          child: Text(
            "Log In",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
    );
  }

  Widget _donotHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't Have An Account?",
          style: TextStyle(
              color: Colors.blueGrey, fontSize: 16),
        ),
        TextButton(
            onPressed: () {},
            child: const Text(
              "Sign Up",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 18),
            ))
      ],
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot your password?",
        style: TextStyle(
            color: Colors.blueGrey, fontSize: 16),
      ),
    );
  }
}
