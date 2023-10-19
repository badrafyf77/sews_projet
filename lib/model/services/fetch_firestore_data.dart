import 'package:firedart/firedart.dart';

Future<String> getUsersData(String email) async {
  try {
    CollectionReference userData = Firestore.instance.collection('Users');
    Map<String, dynamic>? data;
    await userData.document(email).get().then((value) {
      data = value.map;
    });
    return data!['site'];
  } catch (e) {
    return e.toString();
  }
}
