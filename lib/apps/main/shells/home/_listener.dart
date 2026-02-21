part of 'shell.dart';

class _Listener extends StatelessWidget {
  const _Listener({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    // TODO: Add listeners here
    // Example with BlocListener:
    // return BlocListener<HomeBloc, HomeState>(
    //   listener: (context, state) {
    //     if (state.shouldNavigate) {
    //       Navigator.of(context).push(...);
    //     }
    //     if (state.error != null) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text(state.error!)),
    //       );
    //     }
    //   },
    //   child: Builder(builder: builder),
    // );

    return Builder(builder: builder);
  }
}
