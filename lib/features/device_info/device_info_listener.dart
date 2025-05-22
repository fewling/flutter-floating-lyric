import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/device_info_listener_bloc.dart';

class DeviceInfoListener extends StatelessWidget {
  const DeviceInfoListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return BlocProvider(
      create: (context) =>
          DeviceInfoListenerBloc()
            ..add(DeviceInfoListenerLoaded(devicePixelRatio: pixelRatio)),
      child: child,
    );
  }
}
