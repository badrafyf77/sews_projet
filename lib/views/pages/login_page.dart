import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sews_projet/views/widgets/button.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
import 'package:sews_projet/views/widgets/loading_circle.dart';
import 'package:sews_projet/views/widgets/text_button.dart';
import 'package:sews_projet/views/widgets/text_field.dart';
import 'package:sews_projet/constants.dart';
import 'package:sews_projet/views/pages/forgetpass_page.dart';
import 'package:sews_projet/views/pages/home_page.dart';
import 'package:sews_projet/model/services/auth_api.dart';
import 'package:lottie/lottie.dart';
import 'package:sews_projet/model/services/connectivity.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static String id = '/';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    String? args;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      args = ModalRoute.of(context)!.settings.arguments as String;
      emailController.text = args;
    }

    GlobalKey<FormState> formKey = GlobalKey();

    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomAppbar(widget: SizedBox()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  SizedBox(
                    height: size.height * 0.6,
                    width: size.width * 0.45,
                    child: Lottie.asset('assets/login_animation.json'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      height: size.height * 0.7,
                      child: const VerticalDivider(
                        color: kPrimaryColor,
                        thickness: 1,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.2,
                      ),
                      const Text(
                        'Connectez-vous a votre compte',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'E-mail',
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: size.width * 0.4,
                        child: MyTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrer votre e-mail';
                              } else if (!value.isValidEmail()) {
                                return 'vérifier votre e-mail';
                              }
                              return null;
                            },
                            label: 'Email',
                            controller: emailController),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Mot de passe',
                        style: TextStyle(
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: size.width * 0.4,
                        child: MyTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer votre mot de passe';
                            } else if (value.length < 8) {
                              return 'Mot de passe doit être d\'au moins 8 caractères';
                            }
                            return null;
                          },
                          label: 'Mot de passe',
                          controller: passwordController,
                          obscureText: true,
                          showPasswordIcon: true,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyButton(
                              padding: 8,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (await connectivityResult() ==
                                      ConnectivityResult.none) {
                                    if (context.mounted) {
                                      myShowToast(
                                          context,
                                          'Pas de connexion internet',
                                          Colors.grey);
                                    }
                                  } else {
                                    try {
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const LoadingAnimation();
                                          },
                                        );
                                      }
                                      await signIn(emailController.text,
                                          passwordController.text);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                      Get.offAll(() =>
                                          HomePage(updateCallback: () {}));
                                    } catch (e) {
                                      if (context.mounted) {
                                        myShowToast(
                                            context, e.toString(), Colors.red);
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  }
                                }
                              },
                              textButton: 'Se connectez'),
                          MyTextButton(
                            onPressed: () {
                              Get.to(() => const Forgetpassword(),
                                  arguments: emailController.text,
                                  transition: Transition.downToUp);
                            },
                            text: 'oublier mot de passe?',
                            size: 14,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
