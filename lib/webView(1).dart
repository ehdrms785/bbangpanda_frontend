import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io' show Platform;

// 웹뷰 간단한 버전
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: const Text('InAppWebView Example'),
          // ),
          body: Container(
            child: Column(children: <Widget>[
              // Container(
              //   padding: EdgeInsets.all(20.0),
              //   child: Text(
              //       "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
              // ),
              // Container(
              //     padding: EdgeInsets.all(10.0),
              //     child: progress < 1.0
              //         ? LinearProgressIndicator(value: progress)
              //         : Container()),
              Expanded(
                child: Container(
                  // margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: InAppWebView(
                    initialUrlRequest:
                        URLRequest(url: Uri.parse("https://flutter.dev/")),
                    initialOptions: InAppWebViewGroupOptions(),
                    onWebViewCreated: (InAppWebViewController controller) {
                      _webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url?.toString() ?? '';
                      });
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        this.url = url?.toString() ?? '';
                      });
                    },
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (_webViewController != null) {
                        _webViewController.goBack();
                      }
                    },
                  ),
                  RaisedButton(
                    child: Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (_webViewController != null) {
                        _webViewController.goForward();
                      }
                    },
                  ),
                  RaisedButton(
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      if (_webViewController != null) {
                        _webViewController.reload();
                      }
                    },
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
