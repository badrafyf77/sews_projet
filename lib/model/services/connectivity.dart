import 'package:connectivity_plus/connectivity_plus.dart';

Future<ConnectivityResult> connectivityResult() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult;
}
