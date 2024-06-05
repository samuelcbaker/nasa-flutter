import 'package:equatable/equatable.dart';

abstract class ConnectivityState extends Equatable {}

class InitialConnectivityState extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class OfflineState extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectedState extends ConnectivityState {
  @override
  List<Object> get props => [];
}
