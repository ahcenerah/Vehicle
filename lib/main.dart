import 'package:flutter/material.dart';
import 'package:vehicule/view/tune_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicule/data/settingsRepository.dart';
import 'package:vehicule/data/settingsRepositoryImpl.dart';


void main() {
  GetIt.instance.registerSingleton<SettingsRepository>(SettingsRepositoryImpl());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false ,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:TuneWidget()
    );
  }
}


