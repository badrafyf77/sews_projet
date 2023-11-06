import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
import 'package:sews_projet/views/widgets/date_picker.dart';
import 'package:sews_projet/views/widgets/drop_down_field.dart';
import 'package:sews_projet/views/widgets/line.dart';
import 'package:sews_projet/views/widgets/text_field.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:uuid/uuid.dart';
import '../widgets/button.dart';
import '../../constants.dart';

class ManualAdditionPage extends StatefulWidget {
  const ManualAdditionPage({super.key});
  static String id = '/ManualAdditionPage';

  @override
  State<ManualAdditionPage> createState() => _ManualAdditionPageState();
}

class _ManualAdditionPageState extends State<ManualAdditionPage> {
  List<DateTime?> debutLocation = [
    DateTime.now(),
  ];
  List<DateTime?> finLocation = [
    DateTime.now(),
  ];
  final List<String> siteItems = [
    'Site Ain Harouda',
    'Site Berrechid 1',
    'Site Berrechid 2',
    'Site Ain Sebaa',
  ];
  final List<String> appareilItems = [
    'Pc fixe',
    'Pc portable',
    'Ecran',
  ];

  List<String> fields = [];
  List<String> valeurs = [];
  String? selectedSite;
  String? selectedAppareil;
  var controllerId = TextEditingController();
  var controllerUser = TextEditingController();
  var fieldController = TextEditingController();
  var valueController = TextEditingController();
  void mySetState() {
    setState(() {});
  }

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> formKey2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var args = ModalRoute.of(context)!.settings.arguments as UserInfo;

    try {
      return Scaffold(
        body: Column(
          children: [
            const CustomAppbar(
              widget: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (args.poste != 'administrateur')
                  Text(
                    args.site,
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: MyButton(
                      padding: 14,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext build) {
                              return AlertDialog(
                                title: const Text('Ajouter'),
                                content: const Text('Ajouter une appareil'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'concel',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                  TextButton(
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
                                          CollectionReference sewsDatabase =
                                              Firestore.instance
                                                  .collection('sewsDatabase');
                                          CollectionReference historique =
                                              Firestore.instance
                                                  .collection('Historique');

                                          if (args.poste != 'administrateur') {
                                            selectedSite = args.site;
                                          }

                                          sewsDatabase
                                              .document(controllerId.text)
                                              .set(
                                            {
                                              'a0': 'All',
                                              'a00': 'All',
                                              'a1': controllerId.text,
                                              'a2': controllerUser.text,
                                              'a3': selectedSite,
                                              'a4': selectedAppareil,
                                              'a5': _getValueText(
                                                config.calendarType,
                                                debutLocation,
                                              ),
                                              'a6': _getValueText(
                                                config.calendarType,
                                                finLocation,
                                              ),
                                              'a7': 'null',
                                              'a8': 'null',
                                              'a9': 'null',
                                              'a10': 'null',
                                              'a11': 'null',
                                              'a12': 'null',
                                              'a13': 'null',
                                              'a14': 'null',
                                              'a15': 'null',
                                              'a16': 'null',
                                              'a17': 'null',
                                              'a18': 'null',
                                              'a19': 'null',
                                              'a20': 'null',
                                            },
                                          );

                                          if (fields.isNotEmpty) {
                                            for (int i = 0, j = 7;
                                                i < fields.length;
                                                i++, j++) {
                                              sewsDatabase
                                                  .document(controllerId.text)
                                                  .update({
                                                'a${j.toString()}':
                                                    '${fields[i]} : ${valeurs[i]}'
                                              });
                                            }
                                            fieldController.clear();
                                            valueController.clear();
                                            fields.clear();
                                            valeurs.clear();
                                          }
                                          controllerId.clear();
                                          controllerUser.clear();
                                          mySetState();
                                          var id = const Uuid().v4();
                                          historique.document(id).set({
                                            'Type': 'Ajouter manuellement',
                                            'userNom': args.displayName,
                                            'site': args.site,
                                            'poste': args.poste,
                                            'Nombre de pieces': 1,
                                            'Date': DateTime.now(),
                                            'Time': DateFormat.jm()
                                                .format(DateTime.now())
                                                .toLowerCase(),
                                            'Icon': 'add.png',
                                            'Id': id,
                                          });
                                          if (context.mounted) {
                                            myShowToast(context, 'succes',
                                                Colors.green);
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Ajoute',
                                        style: TextStyle(color: kPrimaryColor),
                                      ))
                                ],
                              );
                            },
                          );
                        }
                      },
                      textButton: 'Ajouter'),
                ),
              ],
            ),
            const MyLine(),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'N° de série :',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: MyTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Entrer N° de série';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: controllerId,
                                      label: 'N° de série',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'Utilisateur :',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: MyTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Entrer utilisateur';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: controllerUser,
                                      label: 'Utilisateur',
                                    ),
                                  ),
                                ],
                              ),
                              (args.poste == 'administrateur')
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            'Site :',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: MyDropDownField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Taper ici';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (value) {
                                              selectedSite = value;
                                            },
                                            items: siteItems,
                                            hintText: 'site',
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 6,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'Appareil :',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: MyDropDownField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Taper ici';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        selectedAppareil = value;
                                      },
                                      items: appareilItems,
                                      hintText: 'appareil',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'Debut de location :',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: MyDatePicker(
                                      onPressed: () async {
                                        final value =
                                            await showCalendarDatePicker2Dialog(
                                          context: context,
                                          config: config,
                                          dialogSize: const Size(325, 400),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          value: debutLocation,
                                        );
                                        if (value != null) {
                                          setState(() {
                                            debutLocation = value;
                                          });
                                        }
                                      },
                                      hintText: _getValueText(
                                        config.calendarType,
                                        debutLocation,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      'Fin de location :',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.4,
                                    child: MyDatePicker(
                                      onPressed: () async {
                                        final value =
                                            await showCalendarDatePicker2Dialog(
                                          context: context,
                                          config: config,
                                          dialogSize: const Size(325, 400),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          value: finLocation,
                                        );
                                        if (value != null) {
                                          // ignore: avoid_print
                                          print(
                                            _getValueText(
                                              config.calendarType,
                                              value,
                                            ),
                                          );

                                          setState(() {
                                            finLocation = value;
                                          });
                                        }
                                      },
                                      hintText: _getValueText(
                                        config.calendarType,
                                        finLocation,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: formKey2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Libelle de la caracteristique',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                        width: size.width * 0.3,
                                        child: MyTextField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Taper ici';
                                              } else {
                                                return null;
                                              }
                                            },
                                            label: 'Libelle',
                                            controller: fieldController)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'La valeur',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                        width: size.width * 0.3,
                                        child: MyTextField(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Taper ici';
                                              } else {
                                                return null;
                                              }
                                            },
                                            label: 'Valeur',
                                            controller: valueController)),
                                  ],
                                ),
                              ),
                              MyButton(
                                  onPressed: () {
                                    if (formKey2.currentState!.validate()) {
                                      if (fields.length >= 16) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(''),
                                              content: SizedBox(
                                                height: size.height * 0.27,
                                                width: size.width * 0.3,
                                                child: const Column(
                                                  children: [
                                                    Icon(Icons.warning),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                      'Veuillez assurer que le nombre de caracteristique ne depasse pas 16',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        fields.add(fieldController.text);
                                        fieldController.clear();
                                        valeurs.add(valueController.text);
                                        valueController.clear();
                                        mySetState();
                                      }
                                    }
                                  },
                                  textButton: 'Ajouter une caracteristique'),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                height: 300,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Les caracteristique:',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          fields.isEmpty
                                              ? const SizedBox()
                                              : Text(
                                                  '(${fields.length})',
                                                  style: const TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                          fields.isEmpty
                                              ? const SizedBox()
                                              : IconButton(
                                                  onPressed: () {
                                                    fields.clear();
                                                    valeurs.clear();
                                                    mySetState();
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: kPrimaryColor,
                                                  ),
                                                  tooltip: 'Reset',
                                                )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: size.width * 0.5,
                                          child: ListView.builder(
                                            itemCount: fields.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${fields[index]}: ${valeurs[index]}',
                                                  style: const TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
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

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    return valueText;
  }
}
