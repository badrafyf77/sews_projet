// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sews_projet/constants.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/model/services/auth_api.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:sews_projet/views/pages/login_page.dart';
import 'package:sews_projet/views/widgets/button.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
import 'package:sews_projet/views/widgets/line.dart';
import 'package:sews_projet/views/widgets/loading_circle.dart';
import 'package:sews_projet/views/widgets/text_field.dart';

class SettingsPage extends StatefulWidget {
  final UserInfo args;
  const SettingsPage({
    Key? key,
    required this.args,
  }) : super(key: key);
  static String id = '/Settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();
  bool enableEmail = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    nameController.text = widget.args.displayName;

    return Form(
      key: formKey,
      child: Scaffold(
        body: Column(
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
                  onPressed: () async {
                    if (await connectivityResult() == ConnectivityResult.none) {
                      if (context.mounted) {
                        myShowToast(
                            context, 'Pas de connexion internet', Colors.grey);
                      }
                    } else {
                      Get.back();
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: size.height * 0.07,
                  color: kPrimaryColor,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Bonjour: ${widget.args.displayName}.',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: size.width * 0.023,
                        ),
                      ),
                      Image.asset(
                        'assets/images/wave.png',
                        width: size.width * 0.043,
                        height: size.height * 0.043,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: size.width * 0.3, child: const MyLine()),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text('E-mail:'),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        widget.args.email,
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text('Nouveau E-mail:'),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: MyTextField(
                            onChanged: (text) {
                              if (emailController.text != widget.args.email &&
                                  confirmEmailController.text ==
                                      emailController.text) {
                                setState(() {
                                  enableEmail = true;
                                });
                              } else {
                                setState(() {
                                  enableEmail = false;
                                });
                              }
                            },
                            radius: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrer votre e-mail';
                              } else if (!value.isValidEmail()) {
                                return 'vérifier votre e-mail';
                              }
                              return null;
                            },
                            label: 'Nouveau e-mail',
                            controller: emailController),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Text('Confirm:'),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: MyTextField(
                            onChanged: (text) {
                              if (emailController.text != widget.args.email &&
                                  confirmEmailController.text ==
                                      emailController.text) {
                                setState(() {
                                  enableEmail = true;
                                });
                              } else {
                                setState(() {
                                  enableEmail = false;
                                });
                              }
                            },
                            radius: 10,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrer votre e-mail';
                              } else if (!value.isValidEmail()) {
                                return 'vérifier votre e-mail';
                              }
                              return null;
                            },
                            label: 'Confirm e-mail',
                            controller: confirmEmailController),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: MyButton(
                        enable: enableEmail,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const LoadingAnimation();
                                  },
                                );
                              }
                              var data = await updateEmail(
                                  widget.args.email, widget.args.idToken);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                              if (context.mounted) {
                                myShowToast(
                                    context, 'E-mail changee', Colors.green);
                              }
                              setState(() {
                                widget.args.email = data['email'];
                                widget.args.idToken = data['idToken'];
                              });
                            } catch (e) {
                              if (context.mounted) {
                                myShowToast(context, e.toString(), Colors.red);
                              }
                            }
                          }
                        },
                        textButton: 'Changer',
                        padding: 12,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
