part of 'page.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder, required this.pathParams});

  final WidgetBuilder builder;
  final LocalLyricDetailPathParams pathParams;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              LyricDetailBloc(localDbService: context.read<LocalDbService>())
                ..add(LyricDetailEvent.started(id: pathParams.id)),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}
