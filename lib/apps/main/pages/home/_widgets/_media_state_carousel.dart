part of '../page.dart';

class _MediaStateCarousel extends StatefulWidget {
  const _MediaStateCarousel({required this.mediaStates});

  final List<MediaState> mediaStates;

  @override
  State<_MediaStateCarousel> createState() => _MediaStateCarouselState();
}

class _MediaStateCarouselState extends State<_MediaStateCarousel> {
  late final CarouselSliderController _controller;
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    final mediaStates = widget.mediaStates;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: mediaStates.length,
          itemBuilder: (context, index, realIndex) {
            return Center(
              child: _MediaStateCard(mediaState: mediaStates[index]),
            );
          },
          options: CarouselOptions(
            height: 100,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) =>
                setState(() => _currentIndex = index),
          ),
        ),
        if (mediaStates.length > 1)
          _CarouselIndicator(
            itemCount: mediaStates.length,
            currentIndex: _currentIndex,
          ),
      ],
    );
  }
}

class _CarouselIndicator extends StatelessWidget {
  const _CarouselIndicator({
    required this.itemCount,
    required this.currentIndex,
  });

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index
                ? colorScheme.primary
                : colorScheme.onSurface.withTransparency(0.3),
          ),
        ),
      ),
    );
  }
}
