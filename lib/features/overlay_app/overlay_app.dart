import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/message_channels/to_main_message_service.dart';
import '../../service/platform_methods/layout_channel_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/overlay_window.dart';
import '../message_channels/message_from_main_receiver/bloc/message_from_main_receiver_bloc.dart';
import 'bloc/overlay_app_bloc.dart';

final rootKey = GlobalKey();

class OverlayApp extends StatefulWidget {
  const OverlayApp({super.key});

  @override
  State<OverlayApp> createState() => _OverlayAppState();
}

class _OverlayAppState extends State<OverlayApp> {
  double width = 100;
  double height = 100;

  @override
  Widget build(BuildContext rootContext) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OverlayAppBloc(
            toMainMessageService: ToMainMessageService(),
            layoutChannelService: LayoutChannelService(),
          )..add(const OverlayAppStarted()),
        ),
        BlocProvider(
          create: (context) => MessageFromMainReceiverBloc()..add(const MessageFromMainReceiverStarted()),
        ),
      ],
      child: Builder(builder: (context) {
        final pxRatio = MediaQuery.devicePixelRatioOf(rootContext);
        _updateSize(rootContext, context, pxRatio);

        final windowSettings = context.select(
          (MessageFromMainReceiverBloc bloc) => bloc.state.settings,
        );
        final appColor = windowSettings?.appColorScheme;
        // _updateSize(context, pxRatio);
        // return Material(
        //   child: Center(
        //     child: GestureDetector(
        //       child: Container(
        //         width: width,
        //         height: height,
        //         color: Colors.red,
        //       ),
        //       onTap: () {
        //         setState(() {
        //           if (width == 100) {
        //             width = 200;
        //             height = 200;
        //           } else {
        //             width = 100;
        //             height = 100;
        //           }
        //         });
        //       },
        //     ),
        //   ),
        // );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: appColor == null ? null : Color(appColor),
            brightness: (windowSettings?.isLight ?? true) ? Brightness.light : Brightness.dark,
          ),
          home: Builder(builder: (context) {
            if (windowSettings == null) {
              return const LoadingWidget();
            } else {
              return Scaffold(
                // backgroundColor: Colors.black.withOpacity((windowSettings.opacity?.toInt() ?? 50) / 100),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(
                      (windowSettings.opacity?.toInt() ?? 50) / 100,
                    ),
                body: InkWell(
                  onTap: () => context.read<OverlayAppBloc>().add(const WindowTouched()),
                  child: OverlayWindow(
                    settings: windowSettings,
                    onCloseTap: () => context.read<OverlayAppBloc>().add(const CloseRequested()),
                    // debugText: 'AppColor: $appColor',
                    debugText:
                        windowSettings.showLyricOnly != null ? 'LyricOnly: ${windowSettings.showLyricOnly}' : 'null',
                  ),
                ),
              );
            }
          }),
        );
      }),
    );
  }

  void _updateSize(BuildContext rootContext, BuildContext blocContext, double pxRatio) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final box = rootKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return;

      final width = box.getMaxIntrinsicWidth(double.infinity);
      final height = box.getMaxIntrinsicHeight(width);

      blocContext.read<OverlayAppBloc>().add(WindowResized(
            width: (width + 0.3) * pxRatio,
            height: (height + 10) * pxRatio,
          ));
    });
  }
}
