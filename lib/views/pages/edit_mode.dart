import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sews_projet/views/widgets/custom_appbar.dart';
import 'package:sews_projet/views/widgets/line.dart';
import 'package:sews_projet/views/widgets/listview_body.dart';
import 'package:sews_projet/views/widgets/listview_header.dart';
import 'package:sews_projet/views/widgets/loading_circle.dart';
import 'package:sews_projet/views/pages/recherche_page.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import 'package:uuid/uuid.dart';
import '../widgets/drop_down_field.dart';
import '../widgets/text_field.dart';
import '../../constants.dart';
import '../../model/models/models.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});
  static String id = '/EditPage';

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final List<String> siteItems = [
    'Site Ain Harouda',
    'Site Berrechid 1',
    'Site Berrechid 2',
    'Site Ain Sebaa',
  ];
  var controller = SwipeActionController();
  var myController = TextEditingController();
  String? selectedSite;
  List<int> selectedIndexes = [];
  bool editingMode = false;
  void enterEditingMode() {
    setState(() {
      editingMode = true;
      controller.startEditingMode();
    });
  }

  void exitEditingMode() {
    setState(() {
      editingMode = false;
      controller.stopEditingMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final args = ModalRoute.of(context)!.settings.arguments as EditArguments;

    CollectionReference sewsDatabase =
        Firestore.instance.collection('sewsDatabase');
    CollectionReference historique =
        Firestore.instance.collection('Historique');

    Future<List<Document>> getData() async {
      List<Document> data = await sewsDatabase
          .where(args.siteIndex, isEqualTo: args.siteValue)
          .where(args.appareilIndex, isEqualTo: args.appareilValue)
          .get();
      return data;
    }

    try {
      return FutureBuilder<List<Document>>(
        future: getData(),
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
                  Center(
                    child: SizedBox(
                      width: size.width,
                      child: Row(
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
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '(${appareilList.length})',
                                  style: const TextStyle(color: kPrimaryColor),
                                ),
                                IconButton(
                                  tooltip: 'actualiser',
                                  onPressed: () {
                                    setState(() {});
                                    myShowToast(
                                        context, 'actualiser', Colors.grey);
                                  },
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                if (editingMode)
                                  IconButton(
                                    tooltip: 'Selectionner Tout',
                                    onPressed: () {
                                      controller.selectAll(
                                          dataLength: appareilList.length);
                                    },
                                    icon: const Icon(
                                      Icons.check_box,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                if (editingMode)
                                  IconButton(
                                    tooltip: 'Supprimer',
                                    onPressed: () {
                                      selectedIndexes =
                                          controller.getSelectedIndexPaths();
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
                                                    'retour',
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
                                                  onPressed: () {
                                                    for (int i = 0;
                                                        i <
                                                            selectedIndexes
                                                                .length;
                                                        i++) {
                                                      sewsDatabase
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
                                                    Navigator.pop(context);
                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 1,
                                                            milliseconds: 500),
                                                        () {
                                                      setState(() {});
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                if (editingMode)
                                  IconButton(
                                    tooltip: 'Concel',
                                    onPressed: () {
                                      exitEditingMode();
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const MyLine(),
                  appareilList.isEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.4,
                              width: size.width * 0.4,
                              child: Lottie.asset(
                                  'assets/no_result_animation.json'),
                            ),
                            const Text(
                              'Aucun Resultat',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            )
                          ],
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: appareilList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  if (index == 0) ListviewHeader(size: size),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  SwipeActionCell(
                                    controller: controller,
                                    index: index,
                                    key: ValueKey(appareilList[index]),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          myController.text =
                                              appareilList[index].utilisateur;
                                          selectedSite =
                                              appareilList[index].site;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      'Editer ${appareilList[index].id}',
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              RecherchePage.id,
                                                              arguments:
                                                                  appareilList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        icon: const Icon(
                                                            Icons.visibility))
                                                  ],
                                                ),
                                                content: SizedBox(
                                                  height: size.height * 0.38,
                                                  width: size.width * 0.4,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 18,
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                          'le Site',
                                                          style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                        child: MyDropDownField(
                                                          onChanged: (value) {
                                                            selectedSite =
                                                                value;
                                                          },
                                                          items: siteItems,
                                                          hintText: 'Site',
                                                          selectedItem:
                                                              selectedSite!,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                          'Utilisateur',
                                                          style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                        child: MyTextField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Taper ici';
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          controller:
                                                              myController,
                                                          label: 'Utilisateur',
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      'changer',
                                                      style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (args.site !=
                                                          appareilList[index]
                                                              .site) {
                                                        myShowToast(
                                                            context,
                                                            'vous ne pouvez pas modifier ceci car vous n\'avez pas l\'autorisation',
                                                            Colors.red);
                                                      } else {
                                                        sewsDatabase
                                                            .document(
                                                                appareilList[
                                                                        index]
                                                                    .id)
                                                            .update({
                                                          'a2':
                                                              myController.text,
                                                          'a3': selectedSite,
                                                        });
                                                        var id =
                                                            const Uuid().v4();
                                                        historique
                                                            .document(id)
                                                            .set({
                                                          'Type':
                                                              'Modification de ${appareilList[index].id}',
                                                          'Nombre de pieces': 1,
                                                          'Date':
                                                              DateTime.now(),
                                                          'Time': DateFormat
                                                                  .jm()
                                                              .format(DateTime
                                                                  .now())
                                                              .toLowerCase(),
                                                          'Icon': 'update.png',
                                                          'Id': id,
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 1,
                                                                milliseconds:
                                                                    500), () {
                                                          setState(() {});
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          setState(() {});
                                        },
                                        child: ListviewBody(
                                            size: size,
                                            index: index,
                                            appareilList: appareilList),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
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
        },
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
}
