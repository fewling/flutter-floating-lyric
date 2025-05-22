import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/lyric_detail_bloc.dart';

class LyricDetailScreen extends StatelessWidget {
  const LyricDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const LyricFileNameLabel(),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<LyricDetailBloc>().add(const SaveRequested()),
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: BlocListener<LyricDetailBloc, LyricDetailState>(
        listenWhen: (previous, current) =>
            previous.saveStatus != current.saveStatus,
        listener: (context, state) {
          if (state.saveStatus.isInitial) return;

          if (state.saveStatus.isError) {
            _showError(context);
          } else {
            _showSuccess(context);
          }
          context.read<LyricDetailBloc>().add(const SaveStatusReset());
        },
        child: const LyricContentField(),
      ),
    );
  }

  void _showError(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
            const SizedBox(width: 8),
            Text(
              'Error saving lyric',
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ],
        ),
        backgroundColor: colorScheme.errorContainer,
        closeIconColor: colorScheme.onErrorContainer,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.primaryContainer,
        closeIconColor: colorScheme.onPrimaryContainer,
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              'Lyric saved',
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class LyricFileNameLabel extends StatelessWidget {
  const LyricFileNameLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final fileName = context.select<LyricDetailBloc, String?>(
      (bloc) => bloc.state.lrcDB?.fileName,
    );

    return Text(fileName ?? '...');
  }
}

class LyricContentField extends StatefulWidget {
  const LyricContentField({super.key});

  @override
  State<LyricContentField> createState() => _LyricContentFieldState();
}

class _LyricContentFieldState extends State<LyricContentField> {
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
          current.lrcDB?.content != _controller.text,
      listener: (context, state) =>
          _controller.text = state.lrcDB?.content ?? '',
      child: TextField(
        controller: _controller,
        onChanged: (value) =>
            context.read<LyricDetailBloc>().add(ContentUpdated(value)),
        expands: true,
        maxLines: null,
      ),
    );
  }
}
