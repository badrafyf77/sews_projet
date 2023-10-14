import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sews_projet/components/button.dart';
import 'package:sews_projet/components/loading_circle.dart';
import 'package:sews_projet/components/text_field.dart';
import 'package:sews_projet/constants.dart';
import 'package:sews_projet/pages/login_page.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../components/custom_appbar.dart';
import '../services/auth_api.dart';

class Forgetpassword extends StatelessWidget {
  const Forgetpassword({super.key});
  static String id = '/Forgetpassword';

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    Size size = MediaQuery.of(context).size;
    GlobalKey<FormState> formKey = GlobalKey();

    String args = ModalRoute.of(context)!.settings.arguments as String;

    controller.text = args;

    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const CustomAppbar(
              widget: SizedBox(),
            ),
            Row(
              children: [
                IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 50,
                  color: kPrimaryColor,
                ),
              ],
            ),
            const Text(
              'Mot de passe oublié',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SizedBox(
                width: size.width * 0.1,
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(4.0),
                  child: Container(
                    color: Colors.blue,
                    height: 4,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.5,
              width: size.width * 0.6,
              child: Lottie.asset('assets/forgot_password.json'),
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
                  label: 'Entrer votre e-mail',
                  controller: controller),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
                padding: 15,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const LoadingAnimation();
                        },
                      );
                      await resetPassword(controller.text);
                      if (context.mounted) Navigator.of(context).pop();
                      if (context.mounted) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: size.height * 0.3,
                                  width: size.width * 0.3,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.2,
                                        width: size.width * 0.2,
                                        child: Image.asset(
                                            'assets/images/like.png'),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MyButton(
                                          padding: 8,
                                          onPressed: () {
                                            Get.off(() => const LoginPage(),
                                                arguments: controller.text,
                                                transition:
                                                    Transition.leftToRight);
                                          },
                                          textButton: 'à la page de connexion')
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    } catch (e) {
                      Navigator.of(context).pop();
                      showToast(
                        e.toString(),
                        context: context,
                        animation: StyledToastAnimation.sizeFade,
                        backgroundColor: Colors.red,
                      );
                    }
                  }
                },
                textButton: 'Réinitialiser le mot de passe'),
          ],
        ),
      ),
    );
  }
}
