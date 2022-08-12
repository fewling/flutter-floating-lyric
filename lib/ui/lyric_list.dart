import 'package:floating_lyric/singletons/song_box.dart';
import 'package:flutter/material.dart';

class LyricList extends StatelessWidget {
  const LyricList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songBox = SongBox();

    return Scaffold(
      appBar: AppBar(title: const Text('Your lyrics')),
      body: ListView.builder(
        itemCount: songBox.size,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(songBox.getTitleByIndex(index)),
            tileColor:
                Colors.primaries[index % Colors.primaries.length].shade200,
            onTap: () {},
          );
        },
      ),
    );
  }
}
