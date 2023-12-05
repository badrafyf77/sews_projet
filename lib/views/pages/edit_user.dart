// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sews_projet/core/utils/constants.dart';
import 'package:sews_projet/core/utils/customs/button.dart';
import 'package:sews_projet/core/utils/customs/custom_appbar.dart';
import 'package:sews_projet/core/utils/customs/drop_down_field.dart';
import 'package:sews_projet/core/utils/customs/loading_circle.dart';
import 'package:sews_projet/core/utils/customs/text_field.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/model/services/auth_api.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:sews_projet/model/services/encrypt.dart';

class EditUser extends StatefulWidget {
  final String editPost;
  final String displayName;
  final String site;
  const EditUser({
    Key? key,
    required this.editPost,
    required this.displayName,
    required this.site,
  }) : super(key: key);
  static String id = '/EditUser';

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final List<String> siteItems = [
    'Site Ain Harouda',
    'Site Berrechid 1',
    'Site Berrechid 2',
    'Site Ain Sebaa',
  ];

  bool enableSave = false;

  String? selectedSite;

  @override
  void initState() {
    controller.text = widget.displayName;
    selectedSite = widget.site;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as User;

    Size size = MediaQuery.of(context).size;

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
                    Get.back();
                  }
                },
                icon: const Icon(Icons.arrow_back),
                iconSize: 50,
                color: kPrimaryColor,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.27),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 80,
                  ),
                  Row(
                    children: [
                      const Text('Nom complete :'),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: size.width * 0.3,
                        child: MyTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Entrer le nom complete';
                              }
                              return null;
                            },
                            onChanged: (text) {
                              if (controller.text != args.displayName ||
                                  selectedSite != args.site) {
                                setState(() {
                                  enableSave = true;
                                });
                              } else {
                                setState(() {
                                  enableSave = false;
                                });
                              }
                            },
                            label: 'Nom complete',
                            controller: controller),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text('Le post:'),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        args.poste,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text('E-mail:'),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        args.email,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text('Le site :'),
                      const SizedBox(
                        width: 10,
                      ),
                      (widget.editPost == 'administrateur')
                          ? SizedBox(
                              width: size.width * 0.3,
                              child: MyDropDownField(
                                  selectedItem: args.site,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Veuillez choisir une option.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    selectedSite = value!;
                                    if (selectedSite != args.site ||
                                        controller.text != args.displayName) {
                                      setState(() {
                                        enableSave = true;
                                      });
                                    } else {
                                      setState(() {
                                        enableSave = false;
                                      });
                                    }
                                  },
                                  items: siteItems,
                                  hintText: 'Selectionner le site'),
                            )
                          : Text(
                              args.site,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyButton(
                        enable: enableSave,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (await connectivityResult() ==
                                ConnectivityResult.none) {
                              if (context.mounted) {
                                myShowToast(context,
                                    'Pas de connexion internet', Colors.grey);
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
                                Map<String, dynamic> data = await signIn(
                                    args.email,
                                    MyEncryptionDecryption.decryptFernet(
                                        args.passUser));
                                await updateName(
                                    data['idToken'], controller.text);

                                CollectionReference users =
                                    Firestore.instance.collection('Users');

                                users.document(args.email).update({
                                  'displayName': controller.text,
                                  'site': selectedSite,
                                });
                                args.displayName = controller.text;
                                args.site = selectedSite!;
                                setState(() {
                                  enableSave = false;
                                });

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  myShowToast(context, 'Success', Colors.green);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  myShowToast(
                                      context, e.toString(), Colors.red);
                                }
                              }
                            }
                          }
                        },
                        textButton: 'Enregistrer',
                        padding: 10,
                      ),
                      MyButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Supprimer'),
                                  content: const Text(
                                      'voulez-vous supprimer cet employee ?'),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'return',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'supprimer',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () async {
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
                                                builder:
                                                    (BuildContext context) {
                                                  return const LoadingAnimation();
                                                },
                                              );
                                            }
                                            Map<String, dynamic> data =
                                                await signIn(
                                                    args.email,
                                                    MyEncryptionDecryption
                                                        .decryptFernet(
                                                            args.passUser));
                                            await deleteUser(data['idToken']);

                                            CollectionReference users =
                                                Firestore.instance
                                                    .collection('Users');

                                            users.document(args.email).delete();

                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                              myShowToast(context, 'Success',
                                                  Colors.green);
                                              Navigator.of(context).pop();
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                              myShowToast(context, e.toString(),
                                                  Colors.red);
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        textButton: 'Supprimer',
                        padding: 10,
                        color: Colors.red,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
