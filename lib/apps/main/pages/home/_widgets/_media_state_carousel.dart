part of '../page.dart';

class _MediaStateCarousel extends StatefulWidget {
  const _MediaStateCarousel({required this.mediaStates});

  final List<MediaState> mediaStates;

  @override
  State<_MediaStateCarousel> createState() => _MediaStateCarouselState();
}

class _MediaStateCarouselState extends State<_MediaStateCarousel> {
  late final CarouselController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarouselController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaStates = widget.mediaStates;

    return SizedBox(
      height: 100,
      child: CarouselView(
        itemExtent: double.infinity,
        children: [
          for (final mediaState in mediaStates)
            Center(child: _MediaStateCard(mediaState: mediaState)),
        ],
      ),
    );
  }
}
