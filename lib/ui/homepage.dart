import 'package:floating_lyric/singletons/song_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../singletons/window_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final windowController = Get.find<WindowController>();
    final songBox = SongBox();

    final pad = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.settings_overscan_outlined),
        title: const Text('Floating Window Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: pad),

              Text(
                'How to use',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(decoration: TextDecoration.underline),
              ),
              const SizedBox(height: 8),

              Text(
                '1. Show and customize the floating window',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),

              //* Window visibility switch:
              Obx(() => SwitchListTile(
                    title: Text(
                      '${windowController.shouldShowWindow ? 'Show' : 'Hide'} Window ',
                      // style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    value: windowController.shouldShowWindow,
                    onChanged: (value) =>
                        windowController.shouldShowWindow = value,
                  )),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Obx(() => Text(
                    'Window Transparency (${(windowController.backgroundOpcity * 100).toInt()}%)')),
              ),

              //* Opacity slider:
              Obx(() => Slider(
                    label: windowController.backgroundOpcity.toString(),
                    divisions: 20,
                    value: windowController.backgroundOpcity,
                    min: 0,
                    max: 1,
                    onChanged: (value) =>
                        windowController.backgroundOpcity = value,
                  )),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Obx(() => Text(
                    'Window Width (${(windowController.widthProportion).toInt()}%)')),
              ),

              //* Width slider:
              Obx(() => Slider(
                    label: windowController.widthProportion.toString(),
                    value: windowController.widthProportion,
                    min: 30.0,
                    max: 100.0,
                    onChanged: (value) =>
                        windowController.widthProportion = value,
                  )),

              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 16),

              Text(
                '2. Start your music app and play a song.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),

              Obx(() {
                final prefix = songBox.hasSong(windowController.song.artist,
                        windowController.song.title)
                    ? 'Currently using file: '
                    : 'No record of file: ';

                final color = songBox.hasSong(windowController.song.artist,
                        windowController.song.title)
                    ? Theme.of(context).primaryColorDark
                    : Theme.of(context).errorColor;

                return Text(
                  '$prefix${windowController.displayingTitle}.lrc',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                );
              }),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              Text(
                '3. Use the `Import LRC` button below to select a folder which contains your LRC files.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey),
              ),
              const Text(
                'LRC filenames are expected as in step 2.',
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: pad),

              //* Bottom buttons:
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => songBox.importLRC(),
                          label: const Text('Import LRC'),
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: double.infinity,
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
                                  onPressed: () {
                                    songBox.clearDB();
                                    Navigator.of(context).pop();
                                  },
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

              SizedBox(height: pad),

              const Divider(),
              const SizedBox(height: 16),

              Text(
                '4. If you have completed all 3 steps above, yet the window is not showing the lyric, try switch to another song then switch back.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 16),

              Text(
                'If the window still not showing the lyric, please check if you have the correct filename and content.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 16),
              const Divider(),

              Text(
                'A typical .LRC file looks like this: ',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey),
              ),
              Image.asset('assets/images/sample_lrc_file.png'),

              SizedBox(height: pad),
            ],
          ),
        ),
      ),
    );
  }
}
