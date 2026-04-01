import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity _connectivity = Connectivity();
  
  /// Tells the app if internet is connected or not
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    // Return true if any result is NOT none
    return !results.contains(ConnectivityResult.none);
  }
}
