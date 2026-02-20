part of 'page.dart';

class _View extends StatelessWidget {
  const _View({required this.pathParams});

  final LocalLyricDetailPathParams pathParams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _LyricFileNameLabel(),
        actions: [
          IconButton(
            onPressed: () => context.read<LyricDetailBloc>().add(
              const LyricDetailEvent.saveRequested(),
            ),
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: const _LyricContentField(),
    );
  }
}

class _LyricFileNameLabel extends StatelessWidget {
  const _LyricFileNameLabel();

  @override
  Widget build(BuildContext context) {
    final fileName = context.select(
      (LyricDetailBloc bloc) => bloc.state.lrcModel?.fileName,
    );

    return Text(fileName ?? '...');
  }
}

class _LyricContentField extends StatefulWidget {
  const _LyricContentField();

  @override
  State<_LyricContentField> createState() => _LyricContentFieldState();
}

class _LyricContentFieldState extends State<_LyricContentField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LyricDetailBloc, LyricDetailState>(
      listenWhen: (previous, current) =>
          current.lrcModel?.content != _controller.text,
      listener: (context, state) =>
          _controller.text = state.lrcModel?.content ?? '',
      child: TextField(
        controller: _controller,
        onChanged: (value) => context.read<LyricDetailBloc>().add(
          LyricDetailEvent.contentUpdated(value),
        ),
        expands: true,
        maxLines: null,
      ),
    );
  }
}
