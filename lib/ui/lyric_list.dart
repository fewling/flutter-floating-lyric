import 'package:flutter/material.dart';

import '../service/song_box.dart';

class LyricList extends StatefulWidget {
  const LyricList({super.key});

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
                        tileColor: Colors.primaries[index % Colors.primaries.length].shade200,
                        onTap: () {},
                      );
                    },
                  ),
                ),
                Expanded(
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
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => songBox.clearDB().then((value) {
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
                const SizedBox(height: 16),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No LRC files record'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => songBox.importLRC().then((_) => setState(() {})),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
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
