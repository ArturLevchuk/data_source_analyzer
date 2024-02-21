import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../constants.dart';

final InAppLocalhostServer? localhostServer = kIsWeb
    ? null
    : InAppLocalhostServer(
        documentRoot: WebViewConstants.documentRoot,
      );

Future<void> initDataSourceAnalyzerLib() async {
  if (!kIsWeb) {
    await localhostServer?.start();
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
}
