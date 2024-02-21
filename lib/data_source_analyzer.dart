library data_source_analyzer;

import 'dart:convert';

import 'package:data_source_analyzer/services/js_engines/core/js_vm.dart';
import 'package:data_source_analyzer/services/js_engines/core/js_engine_stub.dart'
    if (dart.library.io) 'package:data_source_analyzer/services/js_engines/platforms_implementations/webview_js_engine.dart'
    if (dart.library.html) 'package:data_source_analyzer/services/js_engines/platforms_implementations/web_js_engine.dart';

import 'models/model_preload_result.dart';
import 'models/remote_hosting_settings.dart';

class DataSourseAnalyzer {
  final JsVMService _jsVMService;

  DataSourseAnalyzer._({required JsVMService jsVMService})
      : _jsVMService = jsVMService;

  factory DataSourseAnalyzer() {
    return DataSourseAnalyzer._(
      jsVMService: getJsVM(),
    );
  }

  Future<dynamic> callAiModel({
    required String type,
    required String model,
    String additionalPipelineParams = "{}",
    required String request,
    String additionalModelParams = "{}",
    RemoteHostSettings remoteHostSettings = const RemoteHostSettings(
        remoteHost: 'https://huggingface.co/',
        remotePathTemplate: '{model}/resolve/{revision}/'),
  }) async {
    final function =
        '''window.callAiModel("$type","$model", $additionalPipelineParams, "$request", $additionalModelParams, 
        {remoteHost: "${remoteHostSettings.remoteHost}", 
        remotePathTemplate: "${remoteHostSettings.remotePathTemplate}"})''';
    final output = await _jsVMService.callJSAsync(function);
    final decodedOutput = jsonDecode(output);
    if (decodedOutput is Map && decodedOutput['error'] != null) {
      throw Exception(decodedOutput['error']);
    } else {
      return output;
    }
  }

  Future<ModelPreLoadResult> loadModelToCache({
    required String type,
    required String model,
    String additionalPipelineParams = """{
      quantized: true,
      progress_callback: (p) => console.log(JSON.stringify(p)),
    }""",
    RemoteHostSettings remoteHostSettings = const RemoteHostSettings(
        remoteHost: 'https://huggingface.co/',
        remotePathTemplate: '{model}/resolve/{revision}/'),
  }) async {
    final function =
        """window.loadModelToCache("$type","$model", $additionalPipelineParams,
        {remoteHost: "${remoteHostSettings.remoteHost}",
        remotePathTemplate: "${remoteHostSettings.remotePathTemplate}"})""";
    final output = await _jsVMService.callJSAsync(function);
    final decodedOutput = jsonDecode(output);
    if (decodedOutput is Map && decodedOutput["success"] == true) {
      return ModelPreLoadResult(success: true);
    } else if (decodedOutput is Map && decodedOutput["success"] == false) {
      return ModelPreLoadResult(
          success: false, errorMessage: decodedOutput["error"]);
    } else {
      return ModelPreLoadResult(success: false, errorMessage: "Unknown error");
    }
  }
}
