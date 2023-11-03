import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sews_projet/view_model/blocs/auth_bloc/auth_bloc.dart';
import 'package:sews_projet/view_model/blocs/excel_import_bloc/excel_import_bloc.dart';
import 'package:sews_projet/constants.dart';
import 'package:sews_projet/views/pages/add_with_excelfile.dart';
import 'package:sews_projet/views/pages/edit_mode.dart';
import 'package:sews_projet/views/pages/forgetpass_page.dart';
import 'package:sews_projet/views/pages/historique_page.dart';
import 'package:sews_projet/views/pages/home_page.dart';
import 'package:sews_projet/views/pages/login_page.dart';
import 'package:sews_projet/views/pages/manual_addition_page.dart';
import 'package:sews_projet/views/pages/recherche_contrat.dart';
import 'package:sews_projet/views/pages/recherche_page.dart';
import 'package:sews_projet/views/pages/setting.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

const projectId = 'sews-projet';

void main() async {
  Firestore.initialize(projectId);
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
  doWhenWindowReady(() {
    const initialSize = Size(800, 550);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Gestion Parc Informatique';
    appWindow.show();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => ExcelImportBloc(),
        ),
      ],
      child: GetMaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Gestion Parc Informatique',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: kPrimaryColor,
          fontFamily: 'kFont',
        ),
        home: const LoginPage(),
        getPages: [
          GetPage(name: LoginPage.id, page: () => const LoginPage()),
          GetPage(
              name: HomePage.id,
              page: () => HomePage(
                    updateCallback: () {
                      setState(() {});
                    },
                  )),
          GetPage(
              name: AddExcelFilePage.id, page: () => const AddExcelFilePage()),
          GetPage(
              name: ManualAdditionPage.id,
              page: () => const ManualAdditionPage()),
          GetPage(name: EditPage.id, page: () => const EditPage()),
          GetPage(
              name: ContratRecherche.id, page: () => const ContratRecherche()),
          GetPage(name: HistoriquePage.id, page: () => const HistoriquePage()),
          GetPage(name: RecherchePage.id, page: () => const RecherchePage()),
          GetPage(name: Forgetpassword.id, page: () => const Forgetpassword()),
          GetPage(name: SettingPage.id, page: () => const SettingPage()),
        ],
      ),
    );
  }
}
