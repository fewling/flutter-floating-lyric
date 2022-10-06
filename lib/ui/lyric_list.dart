import 'package:floating_lyric/singletons/song_box.dart';
import 'package:flutter/material.dart';

class LyricList extends StatelessWidget {
  const LyricList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final songBox = SongBox();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.file_copy_outlined),
        title: const Text('Your lyric files'),
      ),
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
