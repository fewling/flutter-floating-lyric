

// class LyricWindow {
//   // singleton constructor
//   factory LyricWindow() => _instance;
//   static final LyricWindow _instance = LyricWindow._();
//   LyricWindow._();

//   final _prefMode = SystemWindowPrefMode.OVERLAY;

//   // body build function
//   SystemWindowHeader buildHeader(WindowController controller) => SystemWindowHeader(
//         padding: SystemWindowPadding.setSymmetricPadding(8, 8),
//         title: SystemWindowText(
//           text: controller.displayingTitle,
//           fontSize: 14,
//           textColor: controller.textColor,
//         ),
//         decoration: SystemWindowDecoration(
//             startColor: Colors.black.withOpacity(controller.backgroundOpacity)),
//       );

//   SystemWindowBody buildBody(WindowController controller) => SystemWindowBody(
//         rows: [
//           EachRow(
//             columns: [
//               EachColumn(
//                 text: SystemWindowText(
//                     text: controller.displayingLyric,
//                     fontSize: 20,
//                     textColor: controller.textColor),
//               ),
//             ],
//             gravity: ContentGravity.CENTER,
//           ),
//         ],
//         padding: SystemWindowPadding.setSymmetricPadding(8, 8),
//         decoration: SystemWindowDecoration(
//             startColor: Colors.black.withOpacity(controller.backgroundOpacity)),
//       );

//   // window visibilities
//   void show() {
//     final controller = Get.find<WindowController>();
//     SystemWindowHeader header = buildHeader(controller);
//     SystemWindowBody body = buildBody(controller);

//     SystemAlertWindow.showSystemWindow(
//       width: (controller.maxWidth * (controller.widthProportion / 100)).toInt(),
//       height: 150,
//       header: header,
//       body: body,
//       gravity: SystemWindowGravity.TOP,
//       prefMode: _prefMode,
//     ).then((showed) => controller.isShowingWindow = true);
//   }

//   void update() {
//     final controller = Get.find<WindowController>();
//     SystemWindowHeader header = buildHeader(controller);
//     SystemWindowBody body = buildBody(controller);
//     log('displaying title: ${controller.displayingTitle}');
//     log('${(controller.maxWidth * (controller.widthProportion / 100))}');
//     log('percent: ${controller.widthProportion}');

//     SystemAlertWindow.updateSystemWindow(
//       width: (controller.maxWidth * (controller.widthProportion / 100)).toInt(),
//       height: 150,
//       header: header,
//       body: body,
//       gravity: SystemWindowGravity.TOP,
//       prefMode: _prefMode,
//     );
//   }

//   void close() {
//     final controller = Get.find<WindowController>();
//     SystemAlertWindow.closeSystemWindow(prefMode: _prefMode)
//         .then((value) => controller.isShowingWindow = false);
//   }
// }
