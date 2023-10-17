// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sews_projet/constants.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:sews_projet/views/widgets/button.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool enableEmail = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    emailController.text = widget.args.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    nameController.text = widget.args.displayName;

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
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Nom complete:'),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: MyTextField(
                          enable: false,
                          radius: 10,
                          validator: (value) {
                            return null;
                          },
                          label: widget.args.displayName,
                          controller: nameController),
                    ),
                  ],
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
                    Expanded(
                      child: MyTextField(
                          onChanged: (value) {
                            setState(() {
                              enableEmail = value == widget.args.email;
                            });
                          },
                          radius: 10,
                          validator: (value) {
                            return null;
                          },
                          label: 'e-mail',
                          controller: emailController),
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
                      onPressed: () {},
                      textButton: 'Changer',
                      padding: 12,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
