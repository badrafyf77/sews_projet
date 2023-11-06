import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sews_projet/views/pages/setting.dart';
import 'package:sews_projet/views/widgets/button.dart';
import 'package:sews_projet/views/widgets/container.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
import 'package:sews_projet/views/widgets/line.dart';
import 'package:sews_projet/views/widgets/text_button.dart';
import 'package:sews_projet/views/widgets/text_field.dart';
import 'package:sews_projet/constants.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/views/pages/historique_page.dart';
import 'package:sews_projet/views/pages/manual_addition_page.dart';
import 'package:sews_projet/views/pages/recherche_contrat.dart';
import 'package:sews_projet/views/pages/recherche_page.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'add_with_excelfile.dart';
import 'edit_mode.dart';

class HomePage extends StatefulWidget {
  final Function() updateCallback;
  const HomePage({super.key, required this.updateCallback});
  static String id = '/HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DateTime?> debutLocation = [
    DateTime.now(),
  ];

  final List<String> siteItems = [
    'Site Ain Harouda',
    'Site Berrechid 1',
    'Site Berrechid 2',
    'Site Ain Sebaa',
    'All',
  ];
  final List<String> appareilItems = [
    'Pc fixe',
    'Pc portable',
    'Ecran',
    'All',
  ];

  var controller = TextEditingController();

  String fieldIndexSite = 'a0';
  String fieldValueSite = 'All';
  String fieldIndexAppareil = 'a00';
  String fieldValueAppareil = 'All';
  String? contratDate;

  GlobalKey<FormState> formKey = GlobalKey();

  CollectionReference sewsDatabase =
      Firestore.instance.collection('sewsDatabase');

  Future<List<Document>> getData() async {
    List<Document> data;
    try {
      data = await sewsDatabase.get();
      return data;
    } on Exception {
      data = [];
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as UserInfo;
    try {
      return FutureBuilder<List<Document>>(
          future: getData(),
          builder: (context, snapshot) {
            List<String> numSerie = [];
            List<Appareil> appareilList = [];
            int c = 0;

            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0.0),
                    child: Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
                  toolbarHeight: 30,
                  backgroundColor: Colors.white,
                  title: CustomAppbar(
                    widget: Row(
                      children: [
                        SizedBox(
                          width: 70,
                          height: 28,
                          child: Image.asset(
                            kIcon,
                          ),
                        ),
                        const Text(
                          'Gestion Parc Informatique',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Row(
                        children: [
                          Text(
                            'Bonjour: ${args.displayName}.',
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
                          const MyVerticalLine(
                            height: 20,
                            color: kPrimaryColor,
                          ),
                          IconButton(
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
                                  await Get.to(
                                    () => const SettingPage(),
                                    arguments: args,
                                    transition: Transition.cupertino,
                                  );

                                  widget.updateCallback();
                                }
                              },
                              icon: const Icon(
                                Icons.settings,
                                color: kPrimaryColor,
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(
                                    'Taper N° de série pour rechercher',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                UnconstrainedBox(
                                  child: SizedBox(
                                    width: size.width * 0.6,
                                    child: Form(
                                      key: formKey,
                                      child: Autocomplete<String>(
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController
                                                fieldTextEditingController,
                                            FocusNode fieldFocusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return MyTextField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Taper ici';
                                              } else {
                                                return null;
                                              }
                                            },
                                            label: 'N° de série',
                                            controller:
                                                fieldTextEditingController,
                                            focusNode: fieldFocusNode,
                                          );
                                        },
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (c == 0) {
                                            appareilList.clear();
                                            numSerie.clear();
                                            for (int i = 0;
                                                i < snapshot.data!.length;
                                                i++) {
                                              appareilList.add(
                                                Appareil.fromJson(
                                                  snapshot.data!.elementAt(i),
                                                ),
                                              );
                                            }
                                            for (int i = 0;
                                                i < appareilList.length;
                                                i++) {
                                              numSerie.add(appareilList[i].id);
                                            }
                                            c++;
                                          }
                                          setState(() {
                                            controller.text =
                                                textEditingValue.text;
                                          });
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                String>.empty();
                                          }
                                          return numSerie
                                              .where((String option) {
                                            return option.contains(
                                                textEditingValue.text);
                                          });
                                        },
                                        onSelected: (String value) {},
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          MyButton(
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
                                  Get.to(() => const RecherchePage(),
                                      arguments: controller.text,
                                      transition: Transition.downToUp);
                                }
                              }
                            },
                            textButton: 'Rechercher',
                          ),
                          UnconstrainedBox(
                            child: SizedBox(
                              width: size.width * 0.76,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: MyLine(),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MyContainer(
                                label: 'Ajouter',
                                widget1: MyTextButton(
                                  onPressed: () async {
                                    await Get.to(
                                        () => const ManualAdditionPage(),
                                        transition: Transition.cupertino);
                                    widget.updateCallback();
                                  },
                                  text: '- Ajouter manuellement',
                                ),
                                widget2: MyTextButton(
                                    onPressed: () async {
                                      await Get.to(
                                          () => const AddExcelFilePage(),
                                          transition: Transition.cupertino);
                                      widget.updateCallback();
                                    },
                                    text: '- Ajouter par un fichier excel'),
                              ),
                              MyContainer(
                                label: 'Autre',
                                widget1: MyTextButton(
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
                                      await Get.to(() => const EditPage(),
                                          arguments: args,
                                          transition: Transition.cupertino);

                                      widget.updateCallback();
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  },
                                  text: '- Mode édition',
                                ),
                                widget2: MyTextButton(
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
                                      await Get.to(
                                          () => const ContratRecherche(),
                                          arguments: args,
                                          transition: Transition.cupertino);
                                      widget.updateCallback();
                                    }
                                  },
                                  text:
                                      '- Afficher tous les appareils d\'un contrat',
                                ),
                                widget3: MyTextButton(
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
                                      await Get.to(() => const HistoriquePage(),
                                          transition: Transition.cupertino);

                                      widget.updateCallback();
                                    }
                                  },
                                  text: '- Historique',
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0.0),
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                  ),
                ),
                toolbarHeight: 30,
                backgroundColor: Colors.white,
                title: WindowTitleBarBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: MoveWindow(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 70,
                                height: 28,
                                child: Image.asset(
                                  kIcon,
                                ),
                              ),
                              const Text(
                                'Gestion Parc Informatique',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const WindowButtons(),
                    ],
                  ),
                ),
              ),
              body: Center(
                child: Image.asset(
                  kIcon,
                  width: size.width * 0.2,
                  height: size.height * 0.2,
                ),
              ),
            );
          });
    } catch (e) {
      // Handle the exception here
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text('An error occurred: $e'),
        ),
      );
    }
  }
}
