// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:side_navigation/side_navigation.dart';

import 'package:sews_projet/constants.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/model/services/auth_api.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:sews_projet/views/pages/home_page.dart';
import 'package:sews_projet/views/pages/login_page.dart';
import 'package:sews_projet/views/widgets/button.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
import 'package:sews_projet/views/widgets/line.dart';
import 'package:sews_projet/views/widgets/loading_circle.dart';
import 'package:sews_projet/views/widgets/text_field.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});
  static String id = '/Setting';

  @override
  State<SettingPage> createState() => _SettingPageState();
}

int selectedIndex = 0;

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserInfo;
    Size size = MediaQuery.of(context).size;

    List<Widget> views = [
      Center(
        child: DashboardWidget(
          userInfo: args,
          size: size,
        ),
      ),
      Center(
        child: EmailWidget(
          userInfo: args,
          size: size,
        ),
      ),
      Center(
        child: PasswordWidget(
          userInfo: args,
          size: size,
        ),
      ),
    ];

    return Scaffold(
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
                    Get.off(
                        () => HomePage(updateCallback: () {
                              setState(() {});
                            }),
                        arguments: args);
                  }
                },
                icon: const Icon(Icons.arrow_back),
                iconSize: size.height * 0.07,
                color: kPrimaryColor,
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                /// Pretty similar to the BottomNavigationBar!
                Container(
                  color: kPrimaryColor,
                  child: SideNavigationBar(
                    theme: SideNavigationBarTheme(
                      itemTheme: SideNavigationBarItemTheme(
                        selectedItemColor: Colors.white,
                      ),
                      togglerTheme: const SideNavigationBarTogglerTheme(),
                      dividerTheme: const SideNavigationBarDividerTheme(
                          footerDividerColor: Colors.white,
                          showHeaderDivider: true,
                          showMainDivider: true,
                          showFooterDivider: true),
                    ),
                    selectedIndex: selectedIndex,
                    items: const [
                      SideNavigationBarItem(
                        icon: Icons.person,
                        label: 'Compte',
                      ),
                      SideNavigationBarItem(
                        icon: Icons.contact_mail,
                        label: 'E-mail',
                      ),
                      SideNavigationBarItem(
                        icon: Icons.vpn_key,
                        label: 'Mot de passe',
                      ),
                    ],
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ),

                /// Make it take the rest of the available width
                Expanded(
                  child: views.elementAt(selectedIndex),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordWidget extends StatefulWidget {
  final UserInfo userInfo;
  final Size size;
  const PasswordWidget({
    Key? key,
    required this.userInfo,
    required this.size,
  }) : super(key: key);

  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  final GlobalKey<FormState> formKeyPass = GlobalKey<FormState>();

  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  bool enablePassword = false;

  @override
  void dispose() {
    oldPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bonjour',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: widget.size.width * 0.023,
              ),
            ),
            Image.asset(
              'assets/images/wave.png',
              width: widget.size.width * 0.043,
              height: widget.size.height * 0.043,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              SizedBox(width: widget.size.width * 0.15, child: const MyLine()),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: formKeyPass,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Ancien mot de passe:'),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: widget.size.width * 0.3,
                      child: MyTextField(
                          obscureText: true,
                          showPasswordIcon: true,
                          radius: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer votre mot de passe';
                            } else if (value.length < 8) {
                              return 'Mot de passe doit être d\'au moins 8 caractères';
                            } else if (value != widget.userInfo.password) {
                              return 'Le mot de passe contredit votre mot de passe actuel';
                            }
                            return null;
                          },
                          label: 'Ancien mot de passe',
                          controller: oldPassController),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text('Nouveau mot de passe:'),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: widget.size.width * 0.3,
                      child: MyTextField(
                          obscureText: true,
                          showPasswordIcon: true,
                          onChanged: (text) {
                            if (newPassController.text !=
                                    widget.userInfo.password &&
                                newPassController.text ==
                                    confirmPassController.text) {
                              setState(() {
                                enablePassword = true;
                              });
                            } else {
                              setState(() {
                                enablePassword = false;
                              });
                            }
                          },
                          radius: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer votre mot de passe';
                            } else if (value.length < 8) {
                              return 'Mot de passe doit être d\'au moins 8 caractères';
                            }
                            return null;
                          },
                          label: 'Nouveau mot de passe',
                          controller: newPassController),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text('Confirmer:'),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: widget.size.width * 0.3,
                      child: MyTextField(
                          obscureText: true,
                          showPasswordIcon: true,
                          onChanged: (text) {
                            if (newPassController.text !=
                                    widget.userInfo.password &&
                                newPassController.text ==
                                    confirmPassController.text) {
                              setState(() {
                                enablePassword = true;
                              });
                            } else {
                              setState(() {
                                enablePassword = false;
                              });
                            }
                          },
                          radius: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer votre mot de passe';
                            } else if (value.length < 8) {
                              return 'Mot de passe doit être d\'au moins 8 caractères';
                            } else if (value != newPassController.text) {
                              return 'Le mot de passe contredit le nouveau mot de passe';
                            }
                            return null;
                          },
                          label: 'Confirmer mot de passe',
                          controller: confirmPassController),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyButton(
                    enable: enablePassword,
                    onPressed: () async {
                      if (formKeyPass.currentState!.validate()) {}
                    },
                    textButton: 'Changer',
                    padding: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EmailWidget extends StatefulWidget {
  final UserInfo userInfo;
  final Size size;
  const EmailWidget({
    Key? key,
    required this.userInfo,
    required this.size,
  }) : super(key: key);

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController confirmEmailController = TextEditingController();

  bool enableEmail = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bonjour',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: widget.size.width * 0.023,
              ),
            ),
            Image.asset(
              'assets/images/wave.png',
              width: widget.size.width * 0.043,
              height: widget.size.height * 0.043,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              SizedBox(width: widget.size.width * 0.15, child: const MyLine()),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('E-mail:'),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      widget.userInfo.email,
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
                    SizedBox(
                      width: widget.size.width * 0.3,
                      child: MyTextField(
                          onChanged: (text) {
                            if (emailController.text != widget.userInfo.email &&
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
                    SizedBox(
                      width: widget.size.width * 0.3,
                      child: MyTextField(
                          onChanged: (text) {
                            if (emailController.text != widget.userInfo.email &&
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
                          label: 'Confirmer e-mail',
                          controller: confirmEmailController),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
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
                          var dataForIdToken = await signIn(
                              widget.userInfo.email, widget.userInfo.password);
                          var data = await updateEmail(
                              emailController.text, dataForIdToken['idToken']);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                          if (context.mounted) {
                            myShowToast(
                                context, 'E-mail changee', Colors.green);
                          }
                          setState(() {
                            widget.userInfo.email = data['email'];
                            widget.userInfo.idToken = data['idToken'];
                            enableEmail = false;
                            emailController.clear();
                            confirmEmailController.clear();
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardWidget extends StatelessWidget {
  final UserInfo userInfo;
  final Size size;
  const DashboardWidget({
    Key? key,
    required this.userInfo,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Bonjour',
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
          child: SizedBox(width: size.width * 0.15, child: const MyLine()),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Nom complete:'),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    userInfo.displayName,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text('E-mail:'),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    userInfo.email,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Text('Site:'),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Berrechid 1',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
