import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sews_projet/core/utils/customs/custom_appbar.dart';
import 'package:sews_projet/core/utils/customs/loading_circle.dart';
import 'package:sews_projet/core/utils/customs/no_result.dart';
import 'package:sews_projet/model/models/models.dart';
import 'package:sews_projet/model/services/connectivity.dart';
import '../../core/utils/constants.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});
  static String id = '/HistoriquePage';

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  CollectionReference historique = Firestore.instance.collection('Historique');

  Future<List<Document>> getData() async {
    List<Document> data =
        await historique.orderBy('Date', descending: true).get();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as UserInfo;
    return FutureBuilder<List<Document>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Historique> historiqueList = [];

          for (int i = 0; i < snapshot.data!.length; i++) {
            historiqueList.add(
              Historique.fromJson(
                snapshot.data!.elementAt(i),
              ),
            );
          }

          return Scaffold(
            body: Column(
              children: [
                const CustomAppbar(
                  widget: SizedBox(),
                ),
                Row(
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
                        if (historiqueList.isNotEmpty &&
                            args.poste == 'administrateur')
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Suppression'),
                                    content: SizedBox(
                                      height: size.height * 0.3,
                                      width: size.width * 0.4,
                                      child: const Column(
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            'Supprimer tout?',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
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
                                              i < historiqueList.length;
                                              i++) {
                                            await historique
                                                .document(historiqueList[i].id)
                                                .delete();
                                          }

                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }

                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Supprimer tout',
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                        IconButton(
                          tooltip: 'actualiser',
                          onPressed: () {
                            setState(() {});
                            myShowToast(context, 'actualiser', Colors.grey);
                          },
                          icon: const Icon(
                            Icons.refresh,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                historiqueList.isEmpty
                    ? NoRestultAnimation(size: size)
                    : Expanded(
                        child: ListView.builder(
                            itemCount: historiqueList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  if (index == 0)
                                    (historiqueList[index].date.year ==
                                                DateTime.now().year &&
                                            historiqueList[index].date.month ==
                                                DateTime.now().month &&
                                            historiqueList[index].date.day ==
                                                DateTime.now().day)
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 4),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Aujourd\'hui',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          )
                                        : (historiqueList[index].date.year ==
                                                    DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                days: 1))
                                                        .year &&
                                                historiqueList[index]
                                                        .date
                                                        .month ==
                                                    DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                days: 1))
                                                        .month &&
                                                historiqueList[index]
                                                        .date
                                                        .day ==
                                                    DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                days: 1))
                                                        .day)
                                            ? const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 4),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Hier',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 4),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${historiqueList[index].date.day.toString()} ${mounthName(historiqueList[index].date.month)} ${historiqueList[index].date.year.toString()}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                  if (index != 0)
                                    (historiqueList[index].date.year !=
                                                historiqueList[index - 1]
                                                    .date
                                                    .year ||
                                            historiqueList[index].date.month !=
                                                historiqueList[index - 1]
                                                    .date
                                                    .month ||
                                            historiqueList[index].date.day !=
                                                historiqueList[index - 1]
                                                    .date
                                                    .day)
                                        ? (historiqueList[index].date.year ==
                                                    DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                days: 1))
                                                        .year &&
                                                historiqueList[index]
                                                        .date
                                                        .month ==
                                                    DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                days: 1))
                                                        .month &&
                                                historiqueList[index]
                                                        .date
                                                        .day ==
                                                    DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                days: 1))
                                                        .day)
                                            ? const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 4),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Hier',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 4),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${historiqueList[index].date.day.toString()} ${mounthName(historiqueList[index].date.month)} ${historiqueList[index].date.year.toString()}',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/${historiqueList[index].icon}',
                                                    width: size.width * 0.065,
                                                    height: size.height * 0.065,
                                                  ),
                                                  Text(
                                                    historiqueList[index].type,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    historiqueList[index]
                                                        .userNom,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${historiqueList[index].poste} - ${historiqueList[index].site}',
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'pieces : ${historiqueList[index].nmbrPiece.toString()}',
                                              ),
                                              Text(
                                                historiqueList[index].time,
                                              ),
                                              if (args.poste ==
                                                  'administrateur')
                                                IconButton(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Suppression'),
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
                                                                  'Confirmer la suppression',
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
                                                                await historique
                                                                    .document(
                                                                        historiqueList[index]
                                                                            .id)
                                                                    .delete();
                                                                if (context
                                                                    .mounted) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }

                                                                setState(() {});
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                  ),
                                                ),
                                              const SizedBox(
                                                width: 0.1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index == historiqueList.length - 1)
                                          const SizedBox(
                                            height: 30,
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
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
  }
}

mounthName(int mount) {
  switch (mount) {
    case 1:
      {
        return 'janvier';
      }
    case 2:
      {
        return 'février';
      }
    case 3:
      {
        return 'mars';
      }
    case 4:
      {
        return 'avril';
      }
    case 5:
      {
        return 'mai';
      }
    case 6:
      {
        return 'juin';
      }
    case 7:
      {
        return 'juillet';
      }
    case 8:
      {
        return 'aout';
      }
    case 9:
      {
        return 'septembre';
      }
    case 10:
      {
        return 'octobre';
      }
    case 11:
      {
        return 'novembre';
      }
    case 12:
      {
        return 'décembre';
      }
    default:
      {
        return 'janvier';
      }
  }
}
