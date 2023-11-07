import 'package:flutter/material.dart';
import 'package:flutter_experiment/components/button.dart';
import 'package:flutter_experiment/components/textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_experiment/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? switchPage;
  const RegisterPage({super.key, required this.switchPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // textfield controller
  final TextEditingController emailController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPwController = TextEditingController();

  void registerUser() {
    // loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    // password match
    if (passwordController.text != confirmPwController.text) {
      // close loading circle
      Navigator.pop(context);
      // show error
      displayMessageToUser(AppLocalizations.of(context)!.pwNoMatch, context);
    } else {
      // TODO: try creating user
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
                    MyTextField(
                        hintText: "Username",
                        obscureText: false,
                        controller: userNameController),

                    const SizedBox(height: 25),
                    // password textfield
                    MyTextField(
                        hintText: "Password",
                        obscureText: true,
                        controller: passwordController),
                    const SizedBox(height: 25),

                    MyTextField(
                        hintText: "Confirm Password",
                        obscureText: true,
                        controller: confirmPwController),
                    const SizedBox(height: 25),
                    //forgot password
                    const SizedBox(height: 10),
                    // sign in button
                    const SizedBox(height: 25),
                    MyButton(
                        label: AppLocalizations.of(context)!.createAcc,
                        onPressed: registerUser),

                    // don't have an account? sign up
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.existingAcc,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary)),
                        TextButton(
                          onPressed: widget.switchPage,
                          child: Text(
                            AppLocalizations.of(context)!.loginHere,
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
