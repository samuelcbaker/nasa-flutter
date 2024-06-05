import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity connectivity;

  ConnectivityCubit({required this.connectivity})
      : super(InitialConnectivityState()) {
    _listenConnectivity();
  }

  void _listenConnectivity() {
    connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        emit(OfflineState());
      } else {
        emit(ConnectedState());
      }
    });
  }
}
