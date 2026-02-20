part of '../page.dart';

class _OverlayWindow extends StatelessWidget with OverlayWindowSizingMixin {
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

    updateSize(context);

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

    final status = lyricFinderState.status;
    final shouldAnimate = config.enableAnimation;

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
        final allLines = overlayWindowState.allLines;
        final currentLineIndex = overlayWindowState.currentLineIndex;
        final visibleLinesCount = config.visibleLinesCount ?? 3;

        if (allLines.isEmpty) {
          return Center(
            child: Text(
              l10n.overlay_window_no_lyric,
              style: TextStyle(color: textColor),
            ),
          );
        }

        return _ScrollingLyricView(
          allLines: allLines,
          currentLineIndex: currentLineIndex,
          visibleLinesCount: visibleLinesCount,
          textColor: textColor,
          fontSize: config.fontSize,
          shouldAnimate: shouldAnimate,
        );
    }
  }
}

class _ScrollingLyricView extends StatefulWidget {
  const _ScrollingLyricView({
    required this.allLines,
    required this.currentLineIndex,
    required this.visibleLinesCount,
    required this.textColor,
    this.fontSize,
    this.shouldAnimate = false,
  });

  final List<LrcLine> allLines;
  final int currentLineIndex;
  final int visibleLinesCount;
  final Color textColor;
  final double? fontSize;
  final bool shouldAnimate;

  @override
  State<_ScrollingLyricView> createState() => _ScrollingLyricViewState();
}

class _ScrollingLyricViewState extends State<_ScrollingLyricView> {
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
      initialItem: widget.currentLineIndex,
    );
  }

  @override
  void didUpdateWidget(_ScrollingLyricView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLineIndex != widget.currentLineIndex) {
      _scrollController.animateToItem(
        widget.currentLineIndex,
        duration: 300.milliseconds,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.allLines.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate item height based on font size with line height multiplier
    final itemHeight = (widget.fontSize ?? 14.0) * 1.8;

    return SizedBox(
      height: itemHeight * widget.visibleLinesCount,
      child: ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: itemHeight,
        physics: const NeverScrollableScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: widget.allLines.length,
          builder: (context, index) {
            if (index < 0 || index >= widget.allLines.length) return null;

            return _LyricLineWidget(
              line: widget.allLines[index],
              isCurrent: index == widget.currentLineIndex,
              textColor: widget.textColor,
              fontSize: widget.fontSize,
              shouldAnimate:
                  widget.shouldAnimate && index == widget.currentLineIndex,
            );
          },
        ),
      ),
    );
  }
}

class _LyricLineWidget extends StatelessWidget {
  const _LyricLineWidget({
    required this.line,
    required this.isCurrent,
    required this.textColor,
    this.fontSize,
    this.shouldAnimate = false,
  });

  final LrcLine line;
  final bool isCurrent;
  final Color textColor;
  final double? fontSize;
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    return Text(
      line.content,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isCurrent ? textColor : textColor.withTransparency(0.6),
        fontSize: fontSize,
        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
      ),
    );
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
