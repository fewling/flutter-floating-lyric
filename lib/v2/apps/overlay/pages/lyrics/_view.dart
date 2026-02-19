part of 'page.dart';

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(width: double.infinity, child: _OverlayWindow()),
    );
  }
}
