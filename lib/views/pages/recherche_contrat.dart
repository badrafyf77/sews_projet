import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sews_projet/core/utils/customs/custom_appbar.dart';
import 'package:sews_projet/core/utils/customs/drop_down_field.dart';
import 'package:sews_projet/views/widgets/listview_body.dart';
import 'package:sews_projet/views/widgets/listview_header.dart';
import 'package:sews_projet/core/utils/customs/loading_circle.dart';
import 'package:sews_projet/core/utils/customs/no_result.dart';
import 'package:sews_projet/views/pages/recherche_page.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:uuid/uuid.dart';

import 'package:sews_projet/core/utils/customs/date_picker.dart';
import 'package:sews_projet/core/utils/customs/text_field.dart';
import '../../core/utils/constants.dart';
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

  final List<String> siteItemsSelect = [
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

  String sitefield = 'a0';
  String siteValue = 'All';

  String appareilfield = 'a00';
  String appareilValue = 'All';

  Future<List<Document>>? myData;

  Future<List<Document>> getData() async {
    List<Document> data = await sewsDatabase
        .where(sitefield, isEqualTo: siteValue)
        .where(appareilfield, isEqualTo: appareilValue)
        .where(fieldName, isEqualTo: fieldValue)
        .get();
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
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
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
                                            myShowToast(
                                                context,
                                                'Pas de connexion internet',
                                                Colors.grey);
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
                                        'Entrer la date pour rechercher',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.45,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            '(${appareilList.length})',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                            tooltip: 'actualiser',
                                            onPressed: () {
                                              mysetState();
                                              myShowToast(context, 'actualiser',
                                                  Colors.grey);
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
                                                    dataLength:
                                                        appareilList.length);
                                              },
                                              icon: const Icon(
                                                Icons.check_box,
                                                color: Colors.white,
                                              ),
                                            ),
                                          if (editingMode)
                                            IconButton(
                                              tooltip: 'Déplacer',
                                              onPressed: () {
                                                selectedIndexes = controller
                                                    .getSelectedIndexPaths();
                                                bool allowed = true;
                                                bool isValide = true;
                                                String initialSite =
                                                    appareilList[0].site;

                                                for (int i = 0;
                                                    i < selectedIndexes.length;
                                                    i++) {
                                                  if (appareilList[
                                                              selectedIndexes[
                                                                  i]]
                                                          .site !=
                                                      args.site) {
                                                    allowed = false;
                                                  }
                                                  if (initialSite !=
                                                      appareilList[
                                                              selectedIndexes[
                                                                  i]]
                                                          .site) {
                                                    isValide = false;
                                                  }
                                                }
                                                if (allowed ||
                                                    args.poste ==
                                                        'administrateur') {
                                                  if (selectedIndexes.isEmpty ||
                                                      isValide == false) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(''),
                                                          content: SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.3,
                                                            width: size.width *
                                                                0.4,
                                                            child: Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 30,
                                                                ),
                                                                Text(
                                                                  isValide
                                                                      ? 'Vous devez selectionner un element !!!'
                                                                      : 'Vous devez selectionner des appareils sur même site !!!',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text(
                                                                'retour',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Déplacer'),
                                                          content: SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.3,
                                                            width: size.width *
                                                                0.4,
                                                            child: Column(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    const SizedBox(
                                                                      height:
                                                                          30,
                                                                    ),
                                                                    Text(
                                                                      selectedIndexes.length ==
                                                                              1
                                                                          ? 'Déplacer un element'
                                                                          : 'Déplacer ${selectedIndexes.length} elements',
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8),
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
                                                                  width:
                                                                      size.width *
                                                                          0.35,
                                                                  child:
                                                                      MyDropDownField(
                                                                    onChanged:
                                                                        (value) {
                                                                      initialSite =
                                                                          value!;
                                                                    },
                                                                    items:
                                                                        siteItems,
                                                                    hintText:
                                                                        'Site',
                                                                    selectedItem:
                                                                        initialSite,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text(
                                                                'concel',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                'continue',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                if (await connectivityResult() ==
                                                                    ConnectivityResult
                                                                        .none) {
                                                                  if (context
                                                                      .mounted) {
                                                                    myShowToast(
                                                                        context,
                                                                        'Pas de connexion internet',
                                                                        Colors
                                                                            .grey);
                                                                  }
                                                                } else {
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          selectedIndexes
                                                                              .length;
                                                                      i++) {
                                                                    await sewsDatabase
                                                                        .document(
                                                                            appareilList[i].id)
                                                                        .update({
                                                                      'a3':
                                                                          initialSite,
                                                                    });
                                                                  }
                                                                  var id =
                                                                      const Uuid()
                                                                          .v4();
                                                                  historique
                                                                      .document(
                                                                          id)
                                                                      .set({
                                                                    'Type':
                                                                        'Modification',
                                                                    'userNom': args
                                                                        .displayName,
                                                                    'site': args
                                                                        .site,
                                                                    'poste': args
                                                                        .poste,
                                                                    'Nombre de pieces':
                                                                        selectedIndexes
                                                                            .length,
                                                                    'Date':
                                                                        DateTime
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
                                                                  exitEditingMode();
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
                                                                }
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
                                                      'vous ne pouvez pas supprimer car vous n\'avez pas l\'autorisation, Essayez de sélectionner un appareil de votre site',
                                                      Colors.red);
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.move_up,
                                                color: Colors.white,
                                              ),
                                            ),
                                          if (editingMode)
                                            IconButton(
                                              onPressed: () {
                                                selectedIndexes = controller
                                                    .getSelectedIndexPaths();
                                                bool allowed = true;

                                                for (int i = 0;
                                                    i < selectedIndexes.length;
                                                    i++) {
                                                  if (appareilList[
                                                              selectedIndexes[
                                                                  i]]
                                                          .site !=
                                                      args.site) {
                                                    allowed = false;
                                                  }
                                                }
                                                if (allowed ||
                                                    args.poste ==
                                                        'administrateur') {
                                                  if (selectedIndexes.isEmpty) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(''),
                                                          content: SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.3,
                                                            width: size.width *
                                                                0.4,
                                                            child: const Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                Text(
                                                                  'Vous devez selectionner un element !!!',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text(
                                                                'return',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Supprimer'),
                                                          content: SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.3,
                                                            width: size.width *
                                                                0.4,
                                                            child: Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 30,
                                                                ),
                                                                Text(
                                                                  'Supprimer ${selectedIndexes.length} elements',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: const Text(
                                                                'concel',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                'continue',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                if (await connectivityResult() ==
                                                                    ConnectivityResult
                                                                        .none) {
                                                                  if (context
                                                                      .mounted) {
                                                                    myShowToast(
                                                                        context,
                                                                        'Pas de connexion internet',
                                                                        Colors
                                                                            .grey);
                                                                  }
                                                                } else {
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          selectedIndexes
                                                                              .length;
                                                                      i++) {
                                                                    await sewsDatabase
                                                                        .document(
                                                                            appareilList[selectedIndexes[i]].id)
                                                                        .delete();
                                                                  }
                                                                  var id =
                                                                      const Uuid()
                                                                          .v4();
                                                                  await historique
                                                                      .document(
                                                                          id)
                                                                      .set({
                                                                    'Type':
                                                                        'Suppression',
                                                                    'userNom': args
                                                                        .displayName,
                                                                    'site': args
                                                                        .site,
                                                                    'poste': args
                                                                        .poste,
                                                                    'Nombre de pieces':
                                                                        selectedIndexes
                                                                            .length,
                                                                    'Date':
                                                                        DateTime
                                                                            .now(),
                                                                    'Time': DateFormat
                                                                            .jm()
                                                                        .format(
                                                                            DateTime.now())
                                                                        .toLowerCase(),
                                                                    'Icon':
                                                                        'delete.png',
                                                                    'Id': id,
                                                                  });
                                                                  exitEditingMode();
                                                                  if (context
                                                                      .mounted) {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }

                                                                  mysetState();
                                                                }
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
                                                      'vous ne pouvez pas supprimer car vous n\'avez pas l\'autorisation, Essayez de sélectionner un appareil de votre site',
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
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Le site:',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: size.width * 0.2,
                                              child: MyDropDownField(
                                                  isContractPage: true,
                                                  filre: true,
                                                  selectedItem: 'All',
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Veuillez choisir une option.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    if (value == 'All') {
                                                      setState(() {
                                                        sitefield = 'a0';
                                                        siteValue = 'All';
                                                        fieldValue =
                                                            _getValueText(
                                                          config.calendarType,
                                                          debutLocation,
                                                        );
                                                        myData = getData();
                                                      });
                                                    } else {
                                                      setState(() {
                                                        sitefield = 'a3';
                                                        siteValue = value!;
                                                        fieldValue =
                                                            _getValueText(
                                                          config.calendarType,
                                                          debutLocation,
                                                        );
                                                        myData = getData();
                                                      });
                                                    }
                                                  },
                                                  items: siteItemsSelect,
                                                  hintText: 'le site'),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text(
                                              'l\'appareil',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: size.width * 0.2,
                                              child: MyDropDownField(
                                                  isContractPage: true,
                                                  filre: true,
                                                  selectedItem: 'All',
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'Veuillez choisir une option.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    if (value == 'All') {
                                                      setState(() {
                                                        appareilfield = 'a00';
                                                        appareilValue = 'All';
                                                        myData = getData();
                                                      });
                                                    } else {
                                                      setState(() {
                                                        appareilfield = 'a4';
                                                        appareilValue = value!;
                                                        myData = getData();
                                                      });
                                                    }
                                                  },
                                                  items: appareilItems,
                                                  hintText: 'l\'appareil'),
                                            ),
                                            const SizedBox(
                                              width: 10,
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
                          SliverToBoxAdapter(
                            child: appareilList.isEmpty
                                ? NoRestultAnimation(size: size)
                                : AnimationLimiter(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: appareilList.length,
                                        itemBuilder: (context, index) {
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            duration: const Duration(
                                                milliseconds: 375),
                                            child: SlideAnimation(
                                              verticalOffset: 50.0,
                                              child: FadeInAnimation(
                                                child: Column(
                                                  children: [
                                                    if (index == 0)
                                                      ListviewHeader(
                                                          size: size),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    SwipeActionCell(
                                                      controller: controller,
                                                      index: index,
                                                      key: ValueKey(
                                                          appareilList[index]),
                                                      selectedIndicator:
                                                          const Icon(
                                                              Icons.check_box,
                                                              color:
                                                                  kPrimaryColor),
                                                      unselectedIndicator:
                                                          const Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              color:
                                                                  kPrimaryColor),
                                                      child: MouseRegion(
                                                        cursor:
                                                            SystemMouseCursors
                                                                .click,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            myController.text =
                                                                appareilList[
                                                                        index]
                                                                    .utilisateur;
                                                            selectedSite =
                                                                appareilList[
                                                                        index]
                                                                    .site;
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
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
                                                                            Navigator.pushNamed(context,
                                                                                RecherchePage.id,
                                                                                arguments: appareilList[index].id);
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.visibility))
                                                                    ],
                                                                  ),
                                                                  content:
                                                                      SizedBox(
                                                                    height: size
                                                                            .height *
                                                                        0.38,
                                                                    width:
                                                                        size.width *
                                                                            0.4,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const SizedBox(
                                                                          height:
                                                                              18,
                                                                        ),
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8),
                                                                          child:
                                                                              Text(
                                                                            'le Site',
                                                                            style:
                                                                                TextStyle(
                                                                              color: kPrimaryColor,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.55,
                                                                          child:
                                                                              MyDropDownField(
                                                                            onChanged:
                                                                                (value) {
                                                                              selectedSite = value;
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
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8),
                                                                          child:
                                                                              Text(
                                                                            'Utilisateur',
                                                                            style:
                                                                                TextStyle(
                                                                              color: kPrimaryColor,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.55,
                                                                          child:
                                                                              MyTextField(
                                                                            validator:
                                                                                (value) {
                                                                              if (value == null || value.isEmpty) {
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
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
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
                                                                                appareilList[index].site) {
                                                                          if (await connectivityResult() ==
                                                                              ConnectivityResult.none) {
                                                                            if (context.mounted) {
                                                                              myShowToast(context, 'Pas de connexion internet', Colors.grey);
                                                                            }
                                                                          } else {
                                                                            await sewsDatabase.document(appareilList[index].id).update({
                                                                              'a2': myController.text,
                                                                              'a3': selectedSite,
                                                                            });

                                                                            var id =
                                                                                const Uuid().v4();
                                                                            historique.document(id).set({
                                                                              'Type': 'Modification de ${appareilList[index].id}',
                                                                              'userNom': args.displayName,
                                                                              'site': args.site,
                                                                              'poste': args.poste,
                                                                              'Nombre de pieces': 1,
                                                                              'Date': DateTime.now(),
                                                                              'Time': DateFormat.jm().format(DateTime.now()).toLowerCase(),
                                                                              'Icon': 'update.png',
                                                                              'Id': id,
                                                                            });
                                                                            mysetState();
                                                                            if (context.mounted) {
                                                                              Navigator.pop(context);
                                                                              myShowToast(context, 'success', Colors.green);
                                                                            }
                                                                          }
                                                                        } else {
                                                                          myShowToast(
                                                                              context,
                                                                              'vous ne pouvez pas modifier ceci car vous n\'avez pas l\'autorisation',
                                                                              Colors.red);
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
                    ),
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
