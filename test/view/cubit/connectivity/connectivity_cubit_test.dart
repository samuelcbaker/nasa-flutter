import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_cubit.dart';
import 'package:nasa_flutter/view/cubit/connectivity/connectivity_state.dart';

class ConnectivityMock extends Mock implements Connectivity {}

void main() {
  late Connectivity connectivity;
  late ConnectivityCubit cubit;
  late StreamController<List<ConnectivityResult>> streamController;

  setUp(() {
    connectivity = ConnectivityMock();
    streamController = StreamController();
    when(
      () => connectivity.onConnectivityChanged,
    ).thenAnswer((invocation) => streamController.stream);

    cubit = ConnectivityCubit(connectivity: connectivity);
  });

  blocTest<ConnectivityCubit, ConnectivityState>(
    'should emit offline state',
    build: () => cubit,
    act: (_) => streamController.sink.add([ConnectivityResult.none]),
    expect: () => [OfflineState()],
  );

  blocTest<ConnectivityCubit, ConnectivityState>(
    'should emit connected state',
    build: () => cubit,
    act: (_) => streamController.sink.add([ConnectivityResult.ethernet]),
    expect: () => [ConnectedState()],
  );
}
