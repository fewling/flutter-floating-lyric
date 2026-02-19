part of '../page.dart';

class _OverlayWindow extends StatelessWidget {
  const _OverlayWindow({this.debugText, this.isLoading = false});

  final String? debugText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final configs = context.select((MsgFromMainBloc bloc) => bloc.state.config);

    if (configs == null) return const _OverlayLoadingIndicator();

    final colorScheme = Theme.of(context).colorScheme;
    final foregroundColor = colorScheme.onPrimaryContainer;

    final useAppColor = configs.useAppColor;
    final opacity = (configs.opacity ?? 50) / 100;
    final textColor = (useAppColor
        ? foregroundColor
        : Color(configs.color ?? Colors.white.toARGB32()));

    final isLyricOnly = context.select(
      (OverlayWindowBloc b) => b.state.isLyricOnly,
    );

    return IgnorePointer(
      ignoring: configs.ignoreTouch ?? false,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: useAppColor
              ? colorScheme.primaryContainer.withTransparency(opacity)
              : Color(
                  configs.backgroundColor ?? Colors.black.toARGB32(),
                ).withTransparency(opacity),
        ),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => context.read<OverlayWindowBloc>().add(
            const OverlayWindowEvent.windowTapped(),
          ),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                if (debugText != null)
                  Text(
                    debugText!,
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
                  ),
                if (!isLyricOnly) _OverlayHeader(textColor: textColor),
                _OverlayContent(config: configs, textColor: textColor),
                if (!isLyricOnly || (configs.showProgressBar ?? false))
                  _OverlayProgressBar(textColor: textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayContent extends StatelessWidget {
  const _OverlayContent({required this.config, required this.textColor});

  final OverlayWindowConfig config;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final overlayWindowState = context.watch<OverlayWindowBloc>().state;
    final lyricFinderState = context.watch<LyricFinderBloc>().state;

    final line1 = overlayWindowState.line1;
    final line2 = overlayWindowState.line2;

    final line1Pos = line1?.time;
    final line2Pos = line2?.time;

    final line1IsFurther =
        (line1Pos?.compareTo(line2Pos ?? Duration.zero) ?? 0) > 0;

    final status = lyricFinderState.status;
    final showLine2 = config.showLine2 ?? false;
    final shouldAnimate = config.enableAnimation;
    final animationMode = config.animationMode;

    switch (status) {
      case LyricFinderStatus.empty:
        return Center(
          child: Text(
            l10n.overlay_window_no_lyric,
            style: TextStyle(color: textColor),
          ),
        );
      case LyricFinderStatus.searching:
        return Center(
          child: Text(
            l10n.overlay_window_searching_lyric,
            style: TextStyle(color: textColor),
          ),
        );
      case LyricFinderStatus.notFound:
        return Center(
          // child: Text('Lyric not found', style: TextStyle(color: textColor)),
          child: Text(
            l10n.fetch_online_no_lyric_found,
            style: TextStyle(
              color: config.transparentNotFoundTxt
                  ? Colors.transparent
                  : textColor,
            ),
          ),
        );
      case LyricFinderStatus.initial:
      case LyricFinderStatus.found:
        return Column(
          children: [
            Align(
              alignment: showLine2 ? Alignment.centerLeft : Alignment.center,
              child: shouldAnimate
                  ? _AnimatedLyricLine(
                      key: ValueKey('line1:${line1?.content}'),
                      textColor: textColor,
                      id: 'line1:${line1?.content}',
                      content: line1?.content,
                      fontSize: config.fontSize,
                      isBold: line1IsFurther,
                      animationMode: animationMode,
                    )
                  : Text(
                      line1?.content ?? '',
                      style: TextStyle(
                        color: textColor,
                        fontSize: config.fontSize,
                        fontWeight: line1IsFurther
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
            ),
            if (showLine2)
              Align(
                alignment: Alignment.centerRight,
                child: shouldAnimate
                    ? _AnimatedLyricLine(
                        key: ValueKey('line2:${line2?.content}'),
                        textColor: textColor,
                        id: 'line2:${line2?.content}',
                        content: line2?.content,
                        fontSize: config.fontSize,
                        isBold: !line1IsFurther,
                        animationMode: animationMode,
                      )
                    : Text(
                        line2?.content ?? '',
                        style: TextStyle(
                          color: textColor,
                          fontSize: config.fontSize,
                          fontWeight: !line1IsFurther
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
              ),
          ],
        );
    }
  }
}

class _AnimatedLyricLine extends StatefulWidget {
  const _AnimatedLyricLine({
    required this.textColor,
    required this.id,
    required this.isBold,
    required this.animationMode,
    super.key,
    this.content,
    this.fontSize,
  });

  final String id;
  final String? content;
  final Color textColor;
  final double? fontSize;
  final bool isBold;
  final AnimationMode animationMode;

  @override
  State<_AnimatedLyricLine> createState() => _AnimatedLyricLineState();
}

class _AnimatedLyricLineState extends State<_AnimatedLyricLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txtStyle = TextStyle(
      color: widget.textColor,
      fontSize: widget.fontSize,
      fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
    );

    final plainLine = Text(
      widget.content ?? '',
      key: ValueKey(widget.id),
      style: txtStyle,
    );

    switch (widget.animationMode) {
      case AnimationMode.fadeIn:
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(_controller),
            child: Opacity(opacity: _controller.value, child: plainLine),
          ),
        );
      case AnimationMode.typer:
        return widget.isBold
            ? AnimatedTextKit(
                isRepeatingAnimation: false,
                key: ValueKey(widget.id),
                animatedTexts: [
                  TyperAnimatedText(
                    widget.content ?? '',
                    textStyle: txtStyle,
                    speed: const Duration(milliseconds: 80),
                  ),
                ],
              )
            : plainLine;

      case AnimationMode.typeWriter:
        return widget.isBold
            ? AnimatedTextKit(
                isRepeatingAnimation: false,
                key: ValueKey(widget.id),
                animatedTexts: [
                  TypewriterAnimatedText(
                    widget.content ?? '',
                    textStyle: txtStyle,
                    speed: const Duration(milliseconds: 80),
                  ),
                ],
              )
            : plainLine;
    }
  }
}

class _OverlayHeader extends StatelessWidget {
  const _OverlayHeader({required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final mediaState = context.select(
      (MsgFromMainBloc b) => b.state.mediaState,
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            mediaState?.title ?? ' ',
            style: TextStyle(color: textColor),
          ),
        ),
        IconButton(
          onPressed: () => _onLockToggle(context),
          icon: context.select((OverlayWindowBloc b) => b.state.isLocked)
              ? Icon(Icons.lock, color: textColor)
              : Icon(Icons.lock_open_outlined, color: textColor),
        ),
        IconButton(
          onPressed: () => context.read<OverlayAppBloc>().add(
            const OverlayAppEvent.minimizeRequested(),
          ),
          icon: Icon(Icons.remove, color: textColor),
        ),
        IconButton(
          onPressed: () => context.read<OverlayWindowBloc>().add(
            const OverlayWindowEvent.closeRequested(),
          ),
          icon: Icon(Icons.close, color: textColor),
        ),
      ],
    );
  }

  void _onLockToggle(BuildContext context) {
    final isLocked = context.read<OverlayWindowBloc>().state.isLocked;
    context.read<OverlayWindowBloc>().add(
      OverlayWindowEvent.lockToggled(!isLocked),
    );
  }
}

class _OverlayProgressBar extends StatelessWidget {
  const _OverlayProgressBar({required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final msgFromMain = context.watch<MsgFromMainBloc>().state;

    final (config, mediaState) = (msgFromMain.config, msgFromMain.mediaState);

    final pos = Duration(milliseconds: mediaState?.position.toInt() ?? 0);
    final max = Duration(milliseconds: mediaState?.duration.toInt() ?? 0);

    final progress = max.inMilliseconds == 0
        ? 0
        : pos.inMilliseconds / max.inMilliseconds;

    final left = (config?.showMillis ?? false) ? pos.mmssmm() : pos.mmss();
    final right = (config?.showMillis ?? false) ? max.mmssmm() : max.mmss();

    return Row(
      children: [
        Text(left, style: TextStyle(color: textColor)),
        Expanded(
          child: LinearProgressIndicator(
            value: progress.toDouble(),
            color: textColor,
          ),
        ),
        Text(right, style: TextStyle(color: textColor)),
      ].separatedBy(const SizedBox(width: 8)).toList(),
    );
  }
}

class _OverlayLoadingIndicator extends StatelessWidget {
  const _OverlayLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 200,
      width: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.primaryContainer,
      ),
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => context.read<OverlayWindowBloc>().add(
                const OverlayWindowEvent.closeRequested(),
              ),
              icon: Icon(Icons.close, color: colorScheme.onPrimaryContainer),
            ),
          ),
          Align(
            child: Text(
              context.l10n.overlay_window_waiting_for_music_player,
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
