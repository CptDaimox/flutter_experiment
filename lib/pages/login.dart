import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_experiment/api/request.dart';
import 'package:flutter_experiment/auth/auth.dart';
import 'package:flutter_experiment/components/button.dart';
import 'package:flutter_experiment/components/textfield.dart';
import 'package:flutter_experiment/helper/helper_functions.dart';
import 'package:flutter_experiment/logger.dart';

class LoginPage extends StatefulWidget {
  final void Function()? switchPage;
  const LoginPage({super.key, required this.switchPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final requestHelper = RequestHelper();
  // textfield controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Attempt to login using the email and password
      bool isLoginSuccessful = await AuthService.instance
          .login(emailController.text, passwordController.text);

      if (context.mounted) {
        // Close the loading dialog
        Navigator.of(context).pop();

        if (!isLoginSuccessful) {
          // Display an error message to the user
          displayMessageToUser("login failed", context);
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        // Display an error message to the user
        displayMessageToUser("login failed", context);
        logger.e(e.toString());
        // Close the loading dialog
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // logo
                    Icon(Icons.person_4_rounded,
                        size: 80,
                        color: Theme.of(context).colorScheme.inversePrimary),
                    const SizedBox(height: 25),
                    //app name
                    const Text("M I N I M A L", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 50),

                    // email textfield
                    MyTextField(
                        hintText: "Email",
                        obscureText: false,
                        controller: emailController),
                    const SizedBox(height: 25),

                    // password textfield
                    MyTextField(
                        hintText: "Password",
                        obscureText: true,
                        controller: passwordController),
                    //forgot password
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Text("Forgot Password?",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    fontSize: 12)))
                      ],
                    ),
                    // sign in button
                    const SizedBox(height: 25),
                    MyButton(
                        label: AppLocalizations.of(context)!.login,
                        onPressed: login),

                    // don't have an account? sign up
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.noAccount,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary)),
                        TextButton(
                          onPressed: widget.switchPage,
                          child: Text(
                            AppLocalizations.of(context)!.register,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        ));
  }
}
