import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sews_projet/components/no_result.dart';
import 'package:sews_projet/services/connectivity.dart';
import '../components/custom_appbar.dart';
import '../constants.dart';
import '../models/model.dart';

class RecherchePage extends StatelessWidget {
  const RecherchePage({super.key});
  static String id = '/RecherchByIdPage';

  @override
  Widget build(BuildContext context) {
    CollectionReference sewsDatabase =
        Firestore.instance.collection('sewsDatabase');
    Size size = MediaQuery.of(context).size;

    final args = ModalRoute.of(context)!.settings.arguments as String;

    Future<List<Document>> getData() async {
      List<Document> data =
          await sewsDatabase.where('a1', isEqualTo: args).get();
      return data;
    }

    try {
      return FutureBuilder(
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
                  appBar: AppBar(
                    toolbarHeight: 35,
                    title: CustomAppbar(
                      widget: Text(
                        'Resultat pour $args',
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    elevation: 0,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(0.0),
                      child: Container(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                    leading: BackButton(
                      onPressed: () async {
                        if (await connectivityResult() ==
                            ConnectivityResult.none) {
                          if (context.mounted) {
                            myShowToast(context, 'Pas de connexion internet',
                                Colors.grey);
                          }
                        } else {
                          Get.back();
                        }
                      },
                      color: kPrimaryColor,
                    ),
                    backgroundColor: Colors.white,
                  ),
                  body: appareilList.isEmpty
                      ? NoRestultAnimation(size: size)
                      : ListView(
                          children: [
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: size.width,
                              color: Colors.grey[350],
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: Text(
                                  'N° de série : $args',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: size.width,
                              color: Colors.grey[350],
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: Text(
                                  'Utilisateur : ${appareilList[0].utilisateur}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: size.width,
                              color: Colors.grey[350],
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: Text(
                                  'Site : ${appareilList[0].site}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: size.width,
                              color: Colors.grey[350],
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: Text(
                                  'Appareil : ${appareilList[0].appareil}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: size.width,
                              color: Colors.grey[350],
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: Text(
                                  'Debut de location: ${appareilList[0].debutContrat}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: size.width,
                              color: Colors.grey[350],
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: Text(
                                  'Fin de location : ${appareilList[0].finContrat}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a7 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a7,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a8 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a8,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a9 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a9,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a10 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a10,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a11 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a11,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a12 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a12,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a13 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a13,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a14 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a14,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a15 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a15,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a16 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a16,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a17 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a17,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a18 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a18,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a19 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a19,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 2,
                            ),
                            appareilList[0].a20 != 'null'
                                ? Container(
                                    width: size.width,
                                    color: Colors.grey[350],
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Text(
                                        appareilList[0].a20,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ));
            }
            return const Scaffold(
              body: Center(
                child: Text(
                  'Chargement....',
                  style: TextStyle(color: kPrimaryColor),
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
