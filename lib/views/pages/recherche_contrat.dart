import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
import 'package:sews_projet/views/widgets/drop_down_field.dart';
import 'package:sews_projet/views/widgets/listview_body.dart';
import 'package:sews_projet/views/widgets/listview_header.dart';
import 'package:sews_projet/views/widgets/loading_circle.dart';
import 'package:sews_projet/views/widgets/no_result.dart';
import 'package:sews_projet/views/pages/recherche_page.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:uuid/uuid.dart';

import '../widgets/date_picker.dart';
import '../widgets/text_field.dart';
import '../../constants.dart';
import '../../model/models/models.dart';

class ContratRecherche extends StatefulWidget {
  const ContratRecherche({super.key});
  static String id = '/ContratPage';

  @override
  State<ContratRecherche> createState() => _ContratRechercheState();
}

class _ContratRechercheState extends State<ContratRecherche> {
  List<DateTime?> debutLocation = [
    DateTime.now(),
  ];

  final List<String> siteItems = [
    'Site Ain Harouda',
    'Site Berrechid 1',
    'Site Berrechid 2',
    'Site Ain Sebaa',
  ];
  bool editingMode = false;
  void enterEditingMode() {
    setState(() {
      editingMode = true;
      controller.startEditingMode();
    });
  }

  void mySetState() {
    setState(() {});
  }

  String fieldName = 'a5';
  String? fieldValue;

  void exitEditingMode() {
    setState(() {
      editingMode = false;
      controller.stopEditingMode();
    });
  }

  var controller = SwipeActionController();
  var myController = TextEditingController();

  String? selectedSite;

  List<int> selectedIndexes = [];

  CollectionReference sewsDatabase =
      Firestore.instance.collection('sewsDatabase');

  CollectionReference historique = Firestore.instance.collection('Historique');

  Future<List<Document>>? myData;

  Future<List<Document>> getData() async {
    List<Document> data =
        await sewsDatabase.where(fieldName, isEqualTo: fieldValue).get();
    return data;
  }

  @override
  void initState() {
    fieldValue = _getValueText(
      config.calendarType,
      debutLocation,
    );

    myData = getData();

    super.initState();
  }

  mysetState() {
    setState(() {
      myData = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var args = ModalRoute.of(context)!.settings.arguments as UserInfo;

    try {
      return FutureBuilder(
          future: myData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Appareil> appareilList = [];

              for (int i = 0; i < snapshot.data!.length; i++) {
                appareilList.add(
                  Appareil.fromJson(
                    snapshot.data!.elementAt(i),
                  ),
                );
              }
              return Scaffold(
                floatingActionButton: appareilList.isEmpty
                    ? const SizedBox()
                    : FloatingActionButton(
                        backgroundColor: kPrimaryColor,
                        tooltip: 'Editer',
                        onPressed: () {
                          enterEditingMode();
                        },
                        child: const Icon(Icons.edit),
                      ),
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
                            if (await connectivityResult() ==
                                ConnectivityResult.none) {
                              if (context.mounted) {
                                myShowToast(context,
                                    'Pas de connexion internet', Colors.grey);
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
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Entrer la date pour continue',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.7,
                          child: MyDatePicker(
                            onPressed: () async {
                              final value = await showCalendarDatePicker2Dialog(
                                context: context,
                                config: config,
                                dialogSize: const Size(325, 400),
                                borderRadius: BorderRadius.circular(15),
                                value: debutLocation,
                              );
                              if (value != null) {
                                setState(() {
                                  debutLocation = value;
                                  fieldValue = _getValueText(
                                    config.calendarType,
                                    debutLocation,
                                  );
                                  myData = getData();
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
                      height: 7,
                    ),
                    Container(
                      color: kPrimaryColor,
                      width: size.width,
                      height: size.height * 0.075,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'resultats : ${_getValueText(
                                config.calendarType,
                                debutLocation,
                              )}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '(${appareilList.length})',
                                style: const TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                tooltip: 'actualiser',
                                onPressed: () {
                                  mysetState();
                                  myShowToast(
                                      context, 'actualiser', Colors.grey);
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              ),
                              if (editingMode)
                                IconButton(
                                  onPressed: () {
                                    controller.selectAll(
                                        dataLength: appareilList.length);
                                  },
                                  icon: const Icon(
                                    Icons.check_box,
                                    color: Colors.white,
                                  ),
                                ),
                              if (editingMode)
                                IconButton(
                                  onPressed: () {
                                    selectedIndexes =
                                        controller.getSelectedIndexPaths();
                                    bool allowed = true;

                                    for (int i = 0;
                                        i < selectedIndexes.length;
                                        i++) {
                                      if (appareilList[selectedIndexes[i]]
                                              .site !=
                                          args.site) {
                                        allowed = false;
                                      }
                                    }
                                    if (allowed) {
                                      if (selectedIndexes.isEmpty) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(''),
                                              content: SizedBox(
                                                height: size.height * 0.3,
                                                width: size.width * 0.4,
                                                child: const Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      'Vous devez selectionner un element !!!',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
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
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Supprimer'),
                                              content: SizedBox(
                                                height: size.height * 0.3,
                                                width: size.width * 0.4,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    Text(
                                                      'Supprimer ${selectedIndexes.length} elements',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
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
                                                    'concel',
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
                                                    'continue',
                                                    style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    for (int i = 0;
                                                        i <
                                                            selectedIndexes
                                                                .length;
                                                        i++) {
                                                      await sewsDatabase
                                                          .document(appareilList[
                                                                  selectedIndexes[
                                                                      i]]
                                                              .id)
                                                          .delete();
                                                    }
                                                    var id = const Uuid().v4();
                                                    historique
                                                        .document(id)
                                                        .set({
                                                      'Type': 'Suppression',
                                                      'Nombre de pieces':
                                                          selectedIndexes
                                                              .length,
                                                      'Date': DateTime.now(),
                                                      'Time': DateFormat.jm()
                                                          .format(
                                                              DateTime.now())
                                                          .toLowerCase(),
                                                      'Icon': 'delete.png',
                                                      'Id': id,
                                                    });
                                                    exitEditingMode();
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                    }

                                                    mysetState();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      myShowToast(
                                          context,
                                          'vous ne pouvez pas supprimer car vous n\'avez pas l\'autorisation, Essayez de sélectionner un appareil sur votre site',
                                          Colors.red);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              if (editingMode)
                                IconButton(
                                  onPressed: () {
                                    exitEditingMode();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: appareilList.isEmpty
                          ? NoRestultAnimation(size: size)
                          : AnimationLimiter(
                              child: ListView.builder(
                                  itemCount: appareilList.length,
                                  itemBuilder: (context, index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Column(
                                            children: [
                                              if (index == 0)
                                                ListviewHeader(size: size),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              SwipeActionCell(
                                                controller: controller,
                                                index: index,
                                                key: ValueKey(
                                                    appareilList[index]),
                                                selectedIndicator: const Icon(
                                                    Icons.check_box,
                                                    color: kPrimaryColor),
                                                unselectedIndicator: const Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    color: kPrimaryColor),
                                                child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      myController.text =
                                                          appareilList[index]
                                                              .utilisateur;
                                                      selectedSite =
                                                          appareilList[index]
                                                              .site;
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Row(
                                                              children: [
                                                                Text(
                                                                  'Editer ${appareilList[index].id}',
                                                                ),
                                                                IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          RecherchePage
                                                                              .id,
                                                                          arguments:
                                                                              appareilList[index].id);
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .visibility))
                                                              ],
                                                            ),
                                                            content: SizedBox(
                                                              height:
                                                                  size.height *
                                                                      0.38,
                                                              width:
                                                                  size.width *
                                                                      0.4,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 18,
                                                                  ),
                                                                  const Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    child: Text(
                                                                      'le Site',
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            kPrimaryColor,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.55,
                                                                    child:
                                                                        MyDropDownField(
                                                                      onChanged:
                                                                          (value) {
                                                                        selectedSite =
                                                                            value;
                                                                      },
                                                                      items:
                                                                          siteItems,
                                                                      hintText:
                                                                          'Site',
                                                                      selectedItem:
                                                                          selectedSite!,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  const Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(8),
                                                                    child: Text(
                                                                      'Utilisateur',
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            kPrimaryColor,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.55,
                                                                    child:
                                                                        MyTextField(
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          return 'Taper ici';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      },
                                                                      controller:
                                                                          myController,
                                                                      label:
                                                                          'Utilisateur',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                  'return',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                  'changer',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  if (args.poste ==
                                                                          'administrateur' ||
                                                                      args.site ==
                                                                          appareilList[index]
                                                                              .site) {
                                                                    await sewsDatabase
                                                                        .document(
                                                                            appareilList[index].id)
                                                                        .update({
                                                                      'a2': myController
                                                                          .text,
                                                                      'a3':
                                                                          selectedSite,
                                                                    });

                                                                    var id =
                                                                        const Uuid()
                                                                            .v4();
                                                                    historique
                                                                        .document(
                                                                            id)
                                                                        .set({
                                                                      'Type':
                                                                          'Modification de ${appareilList[index].id}',
                                                                      'Nombre de pieces':
                                                                          1,
                                                                      'Date': DateTime
                                                                          .now(),
                                                                      'Time': DateFormat
                                                                              .jm()
                                                                          .format(
                                                                              DateTime.now())
                                                                          .toLowerCase(),
                                                                      'Icon':
                                                                          'update.png',
                                                                      'Id': id,
                                                                    });
                                                                    mysetState();
                                                                    if (context
                                                                        .mounted) {
                                                                      Navigator.pop(
                                                                          context);
                                                                      myShowToast(
                                                                          context,
                                                                          'success',
                                                                          Colors
                                                                              .green);
                                                                    }
                                                                  } else {
                                                                    myShowToast(
                                                                        context,
                                                                        'vous ne pouvez pas modifier ceci car vous n\'avez pas l\'autorisation',
                                                                        Colors
                                                                            .red);
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: ListviewBody(
                                                        size: size,
                                                        index: index,
                                                        appareilList:
                                                            appareilList),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                    )
                  ],
                ),
              );
            }
            return const Scaffold(
              body: LoadingAnimation(
                color: kPrimaryColor,
                size: 60,
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
