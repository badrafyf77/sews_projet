// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sews_projet/model/services/encrypt.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:sews_projet/constants.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/model/services/auth_api.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:sews_projet/views/pages/home_page.dart';
import 'package:sews_projet/views/pages/login_page.dart';
import 'package:sews_projet/views/widgets/button.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
import 'package:sews_projet/views/widgets/drop_down_field.dart';
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
      Center(
        child: AddUserWidget(
          size: size,
        ),
      )
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
                    setState(() {
                      selectedIndex = 0;
                    });
                    Get.off(() => HomePage(updateCallback: () {}),
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
                    items: [
                      const SideNavigationBarItem(
                        icon: Icons.person,
                        label: 'Compte',
                      ),
                      const SideNavigationBarItem(
                        icon: Icons.contact_mail,
                        label: 'E-mail',
                      ),
                      const SideNavigationBarItem(
                        icon: Icons.vpn_key,
                        label: 'Mot de passe',
                      ),
                      if (args.displayName == "admin")
                        const SideNavigationBarItem(
                          icon: Icons.person_add,
                          label: 'Ajouter utilisateur',
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

class AddUserWidget extends StatefulWidget {
  final Size size;
  const AddUserWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController confirmEmailController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();

    final List<String> siteItems = [
      'Site Ain Harouda',
      'Site Berrechid 1',
      'Site Berrechid 2',
      'Site Ain Sebaa',
    ];

    String? selectedSite;

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
        Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, top: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Nom complete :'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: widget.size.width * 0.3,
                      child: MyTextField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrer le nom complete';
                            }
                            return null;
                          },
                          label: 'Nom complete',
                          controller: controller),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text('Le site :'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: widget.size.width * 0.3,
                      child: MyDropDownField(
                          validator: (value) {
                            if (value == null) {
                              return 'Veuillez choisir une option.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            selectedSite = value;
                          },
                          items: siteItems,
                          hintText: 'Selectionner le site'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('E-mail :'),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: widget.size.width * 0.3,
                          child: MyTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer e-mail';
                                } else if (!value.isValidEmail()) {
                                  return 'vérifier e-mail';
                                }
                                return null;
                              },
                              label: 'E-mail',
                              controller: emailController),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: widget.size.width * 0.3,
                          child: MyTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer confirmation d\'email';
                                } else if (value != emailController.text) {
                                  return 'Confirmation ne correspond pas au e-mail';
                                }
                                return null;
                              },
                              label: 'Confirmer e-mail',
                              controller: confirmEmailController),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mot de passe :'),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: widget.size.width * 0.3,
                          child: MyTextField(
                              obscureText: true,
                              showPasswordIcon: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer mot de passe';
                                } else if (value.length < 8) {
                                  return 'Mot de passe doit être d\'au moins 8 caractères';
                                }
                                return null;
                              },
                              label: 'Mot de passe',
                              controller: passController),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: widget.size.width * 0.3,
                          child: MyTextField(
                              obscureText: true,
                              showPasswordIcon: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer confirmation mot de passe';
                                } else if (value != passController.text) {
                                  return 'Confirmation ne correspond pas au mot de passe';
                                }
                                return null;
                              },
                              label: 'Confirmer mot de passe',
                              controller: confirmPassController),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (await connectivityResult() ==
                            ConnectivityResult.none) {
                          if (context.mounted) {
                            myShowToast(context, 'Pas de connexion internet',
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
                            Map<String, dynamic> data = await signUp(
                                emailController.text, passController.text);
                            await updateName(data['idToken'], controller.text);
                            CollectionReference users =
                                Firestore.instance.collection('Users');
                            users.document(emailController.text).set({
                              'displayName': controller.text,
                              'email': emailController.text,
                              'site': selectedSite,
                              'passUser': MyEncryptionDecryption.encryptFernet(
                                      passController.text)
                                  .base64,
                            });
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                            if (context.mounted) {
                              myShowToast(context, 'success', Colors.green);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              myShowToast(context, e.toString(), Colors.red);
                            }
                          }
                        }
                      }
                    },
                    textButton: 'Ajouter')
              ],
            ),
          ),
        )
      ],
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
                      if (formKeyPass.currentState!.validate()) {
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
                          var data = await updatePassword(
                              newPassController.text,
                              dataForIdToken['idToken']);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                          if (context.mounted) {
                            myShowToast(
                                context, 'Mot de passe changee', Colors.green);
                          }
                          setState(() {
                            widget.userInfo.password = newPassController.text;
                            widget.userInfo.idToken = data['idToken'];
                            enablePassword = false;
                            oldPassController.clear();
                            newPassController.clear();
                            confirmPassController.clear();
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
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
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

                          CollectionReference updateUserInfo =
                              Firestore.instance.collection('Users');

                          await updateUserInfo
                              .document(widget.userInfo.email)
                              .delete();

                          updateUserInfo.document(data['email']).set({
                            'displayName': widget.userInfo.displayName,
                            'email': data['email'],
                            'site': widget.userInfo.site,
                          });

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
                  Text(
                    'Nom complete:',
                    style: TextStyle(fontSize: size.height * 0.024),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    userInfo.displayName,
                    style: TextStyle(
                      fontSize: size.height * 0.024,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'E-mail:',
                    style: TextStyle(fontSize: size.height * 0.024),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    userInfo.email,
                    style: TextStyle(
                      fontSize: size.height * 0.024,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Site:',
                    style: TextStyle(fontSize: size.height * 0.024),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    userInfo.site,
                    style: TextStyle(
                      fontSize: size.height * 0.024,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              TextButton(
                onPressed: () {
                  Get.off(() => const LoginPage(),
                      transition: Transition.leftToRight);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Colors.white;
                    },
                  ),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return kPrimaryColor;
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: 150,
                    child: Row(
                      children: [
                        Text(
                          'Se deconnecter',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.logout)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
