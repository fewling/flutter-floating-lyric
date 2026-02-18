part of 'page.dart';

class _Listener extends StatelessWidget {
  const _Listener({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    // Add listeners here
    // Example with BlocListener:
    // return BlocListener<HomePageBloc, HomePageState>(
    //   listener: (context, state) {
    //     if (state.shouldNavigate) {
    //       Navigator.of(context).push(...);
    //     }
    //   },
    //   child: Builder(builder: builder),
    // );

    return Builder(builder: builder);
  }
}
