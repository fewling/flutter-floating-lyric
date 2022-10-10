import 'package:floating_lyric/singletons/song_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../singletons/window_controller.dart';

class InstructionPage extends StatelessWidget {
  const InstructionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final windowController = Get.find<WindowController>();
    final songBox = SongBox();

    final pad = MediaQuery.of(context).size.height * 0.02;

    final headerTxtStyle = Theme.of(context)
        .textTheme
        .headline6
        ?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.notes_outlined),
        title: const Text('How to use'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 8),
                  Text('1. Start your music app and play a song.'),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Currently playing: ${windowController.displayingTitle}'),
                      const SizedBox(height: 8),
                      Text(
                          'Expected file: ${windowController.displayingTitle}.lrc'),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            Obx(() => SwitchListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 8),
                      Text('2. Tap to show floating window'),
                      SizedBox(height: 8),
                    ],
                  ),
                  value: windowController.shouldShowWindow,
                  onChanged: (value) =>
                      windowController.shouldShowWindow = value,
                )),
            const Divider(),
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 8),
                  Text('3. Tap to import LRC files from a folder'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right_outlined),
              onTap: () => songBox.importLRC(),
            ),
            const Divider(),
            const ListTile(
              title: Text(
                '4. If you have completed steps 1 ~ 3, yet the window is not showing the lyric, try switch to another song then switch back.',
              ),
            ),
            const Divider(),
            Text(
              'Format of synchroized <.LRC> file',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.grey),
            ),
            Image.asset('assets/images/sample_lrc_file.png'),
          ],
        ),
      ),
    );
  }
}



        // SingleChildScrollView(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
          

        //       Text(
        //         '4. If you have completed all 3 steps above, yet the window is not showing the lyric, try switch to another song then switch back.',
        //         style: Theme.of(context)
        //             .textTheme
        //             .titleMedium!
        //             .copyWith(color: Colors.grey),
        //       ),

        //       const SizedBox(height: 16),

        //       Text(
        //         'If the window still not showing the lyric, please check if you have the correct filename and content.',
        //         style: Theme.of(context)
        //             .textTheme
        //             .titleMedium!
        //             .copyWith(color: Colors.grey),
        //       ),

        //       const SizedBox(height: 16),
        //       const Divider(),

        //       Text(
        //         'A typical .LRC file looks like this: ',
        //         style: Theme.of(context)
        //             .textTheme
        //             .titleMedium!
        //             .copyWith(color: Colors.grey),
        //       ),
        //       Image.asset('assets/images/sample_lrc_file.png'),

        //       SizedBox(height: pad),
        //     ],
        //   ),
        // ),
