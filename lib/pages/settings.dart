import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sews_projet/components/custom_appbar.dart';
import 'package:sews_projet/constants.dart';
import 'package:sews_projet/services/connectivity.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static String id = '/Settings';

  @override
  Widget build(BuildContext context) {
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
