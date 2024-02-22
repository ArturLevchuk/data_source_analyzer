// ignore_for_file: use_build_context_synchronously
import 'package:data_source_analyzer/data_source_analyzer.dart';
import 'package:data_source_analyzer/models/remote_hosting_settings.dart';
import 'package:data_source_analyzer/services/lib_init_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDataSourceAnalyzerLib();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSourseAnalyzer = DataSourseAnalyzer.defaultInstance();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AiRequestBlock(
                  title: "Text classification",
                  dataSourseAnalyzer: dataSourseAnalyzer,
                  type: "text-classification",
                  model:
                      "Xenova/distilbert-base-uncased-finetuned-sst-2-english",
                  additionalPipelineParams:
                      "{progress_callback: (p) => console.log(JSON.stringify(p)),}",
                  request:
                      "Top SELLING! 300% profit !!! only 50\$ for consultation",
                  additionalModelParams: "{topk:null,}",
                  remoteHost: 'https://bf73-188-190-37-83.ngrok-free.app',
                  remotePathTemplate: '/models/{model}',
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AiRequestBlock(
                  title: "Text generation",
                  dataSourseAnalyzer: dataSourseAnalyzer,
                  type: "text-generation",
                  model: "Xenova/distilgpt2",
                  additionalPipelineParams:
                      "{progress_callback: (p) => console.log(JSON.stringify(p)),}",
                  request: "I enjoy walking with my cute dog,",
                  additionalModelParams: "{}",
                  remoteHost: 'https://huggingface.co/',
                  remotePathTemplate: '{model}/resolve/{revision}/',
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AiRequestBlock(
                  title: "Translation",
                  dataSourseAnalyzer: dataSourseAnalyzer,
                  type: "translation",
                  model: "Xenova/opus-mt-en-uk",
                  additionalPipelineParams:
                      "{progress_callback: (p) => console.log(JSON.stringify(p)),}",
                  request: "I enjoy walking with my cute dog",
                  additionalModelParams: """{src_lang: 'en', tgt_lang: 'uk'}""",
                  remoteHost: 'https://huggingface.co/',
                  remotePathTemplate: '{model}/resolve/{revision}/',
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AiRequestBlock(
                  title: "Automatic speech recognition",
                  dataSourseAnalyzer: dataSourseAnalyzer,
                  type: "automatic-speech-recognition",
                  model: "Xenova/whisper-tiny.en",
                  additionalPipelineParams:
                      "{progress_callback: (p) => console.log(JSON.stringify(p)),}",
                  request:
                      "https://huggingface.co/datasets/Xenova/transformers.js-docs/resolve/main/jfk.wav",
                  additionalModelParams: "{}",
                  remoteHost: 'https://huggingface.co/',
                  remotePathTemplate: '{model}/resolve/{revision}/',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AiRequestBlock extends StatefulWidget {
  const AiRequestBlock({
    super.key,
    required this.title,
    required this.dataSourseAnalyzer,
    required this.type,
    required this.model,
    required this.additionalPipelineParams,
    required this.request,
    required this.additionalModelParams,
    required this.remoteHost,
    required this.remotePathTemplate,
  });
  final String title;
  final DataSourseAnalyzer dataSourseAnalyzer;
  final String type;
  final String model;
  final String additionalPipelineParams;
  final String request;
  final String additionalModelParams;
  final String remoteHost;
  final String remotePathTemplate;

  @override
  State<AiRequestBlock> createState() => _AiRequestBlockState();
}

class _AiRequestBlockState extends State<AiRequestBlock> {
  DataSourseAnalyzer get dataSourseAnalyzer => widget.dataSourseAnalyzer;

  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> requestParams = {};

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(widget.title, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: widget.type,
              decoration: inputDecoration('Request type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter request type';
                }
                return null;
              },
              onSaved: (newValue) {
                requestParams["type"] = newValue!;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
                initialValue: widget.model,
                decoration: inputDecoration('Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter model';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  requestParams["model"] = newValue!;
                }),
            const SizedBox(height: 15),
            TextFormField(
                initialValue: widget.additionalPipelineParams,
                decoration: inputDecoration('Additional pipeline params'),
                minLines: 1,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter additional pipeline params';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  requestParams["additionalPipelineParams"] = newValue!;
                }),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: widget.request,
              decoration: inputDecoration('Request'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter request';
                }
                return null;
              },
              onSaved: (newValue) {
                requestParams["request"] = newValue!;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: widget.additionalModelParams,
              decoration: inputDecoration('Additional model params'),
              minLines: 1,
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter additional model params';
                }
                return null;
              },
              onSaved: (newValue) {
                requestParams["additionalModelParams"] = newValue!;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: widget.remoteHost,
              decoration: inputDecoration('Remote host'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter remote host';
                }
                return null;
              },
              onSaved: (newValue) {
                requestParams["remoteHost"] = newValue!;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
                initialValue: widget.remotePathTemplate,
                decoration: inputDecoration('Remote path template'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter remote path template';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  requestParams["remotePathTemplate"] = newValue!;
                }),
            const SizedBox(height: 15),
            if (!loading)
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      final output = await dataSourseAnalyzer.callAiModel(
                          model: requestParams["model"],
                          type: requestParams["type"],
                          additionalPipelineParams:
                              requestParams["additionalPipelineParams"],
                          request: requestParams["request"],
                          additionalModelParams:
                              requestParams["additionalModelParams"],
                          remoteHostSettings: RemoteHostSettings(
                            remoteHost: requestParams["remoteHost"],
                            remotePathTemplate:
                                requestParams["remotePathTemplate"],
                          ));
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Output",
                              style: TextStyle(fontSize: 20),
                            ),
                            content: SelectableText(output),
                          );
                        },
                      );
                    } catch (err) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: Text(err.toString()),
                          );
                        },
                      );
                    }
                    setState(() {
                      loading = false;
                    });
                  }
                },
                child: const Text("Generate ai request"),
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: const OutlineInputBorder(),
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 20),
    );
  }
}
