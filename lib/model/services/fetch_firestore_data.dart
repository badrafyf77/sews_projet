import 'package:firedart/firedart.dart';

Future<Map<String, dynamic>> getUsersData(String email) async {
  try {
    CollectionReference userData = Firestore.instance.collection('Users');
    Map<String, dynamic>? data;
    await userData.document(email).get().then((value) {
      data = value.map;
    });
    return data!;
  } catch (e) {
    return {'erreur':e.toString()};
  }
}
