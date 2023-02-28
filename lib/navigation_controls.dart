import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  final WebViewController controller;
  const NavigationControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            onPressed: () async {
              if (await controller.canGoBack()) {
                await controller.goBack();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("No previous history item"),
                    duration: Duration(milliseconds: 500)));
                return;
              }
            },
            icon: const Icon(Icons.arrow_back_ios)),
        const SizedBox(width: 20.0),
        IconButton(
            onPressed: () async {
              if (await controller.canGoForward()) {
                await controller.goForward();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("No forward history item"),
                    duration: Duration(milliseconds: 500)));
                return;
              }
            },
            icon: const Icon(Icons.arrow_forward_ios)),
        
        // IconButton(
        //   icon: const Icon(Icons.replay),
        //   onPressed: () {
        //     controller.reload();
        //   },
        // ),
        // IconButton(
        //     onPressed: () async {
        //       await controller
        //           .loadRequest(Uri.parse("https://github.com/Pranav2918"));
        //     },
        //     icon: const Icon(Icons.code))
      ],
    );
  }
}
