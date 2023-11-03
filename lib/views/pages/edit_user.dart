import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sews_projet/constants.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';

class EditUser extends StatelessWidget {
  const EditUser({super.key});
  static String id = '/EditUser';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Users;
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
        ],
      ),
    );
  }
}
