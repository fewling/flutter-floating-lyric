part of 'overlay_app.dart';

class OverlayAppListener extends StatelessWidget {
  const OverlayAppListener({required this.builder, super.key});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MsgFromMainBloc, MsgFromMainState>(
          listenWhen: (previous, current) => current.settings?.width == 0,
          listener: (context, state) {},
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
