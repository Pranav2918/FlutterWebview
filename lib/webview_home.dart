import 'package:flutter/material.dart';
import 'package:webview_demo/menu.dart';
import 'package:webview_demo/navigation_controls.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewDemo extends StatefulWidget {
  const WebviewDemo({super.key});

  @override
  State<WebviewDemo> createState() => _WebviewDemoState();
}

class _WebviewDemoState extends State<WebviewDemo> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
        onNavigationRequest: (navigation) {
          final host = Uri.parse(navigation.url).host;
          if (host.contains("youtube.com")) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 500),
                content: Text(
                  'Blocking navigation to $host',
                ),
              ),
            );
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse('https://flutter.dev'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller)
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          loadingPercentage < 100
              ? Center(
                  child: CircularProgressIndicator(
                      value: loadingPercentage / 100, color: Colors.deepOrange),
                )
              : Container()
        ],
      ),
    );
  }

  //Load Flutter Assets
  Future<void> _onLoadFlutterAssetExample(
      WebViewController controller, BuildContext context) async {
    await controller.loadFlutterAsset('assets/www/index.html');
  }
}
