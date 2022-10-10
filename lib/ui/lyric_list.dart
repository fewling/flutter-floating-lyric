import 'package:floating_lyric/singletons/song_box.dart';
import 'package:flutter/material.dart';

class LyricList extends StatefulWidget {
  const LyricList({Key? key}) : super(key: key);

  @override
  State<LyricList> createState() => _LyricListState();
}

class _LyricListState extends State<LyricList> {
  @override
  Widget build(BuildContext context) {
    final songBox = SongBox();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.file_copy_outlined),
        title: const Text('Your lyric files'),
      ),
      body: songBox.size > 0
          ? Column(
              children: [
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                    itemCount: songBox.size,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(songBox.getTitleByIndex(index)),
                        tileColor: Colors
                            .primaries[index % Colors.primaries.length]
                            .shade200,
                        onTap: () {},
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox.expand(
                          child: ElevatedButton.icon(
                            onPressed: () => songBox.importLRC(),
                            label: const Text('Import LRC'),
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox.expand(
                          child: ElevatedButton.icon(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text(
                                    'This will empty all stored lyrics in this app (does not remove the original files).'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        songBox.clearDB().then((value) {
                                      Navigator.of(context).pop();
                                      if (mounted) setState(() {});
                                    }),
                                    child: const Text('I understand'),
                                  )
                                ],
                              ),
                            ),
                            label: const Text('Clear Storage'),
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No LRC files record'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        songBox.importLRC().then((_) => setState(() {})),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        Text('Import from folder'),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
