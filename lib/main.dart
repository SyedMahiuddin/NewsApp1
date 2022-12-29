import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/connectapi/newsprovider.dart';
import 'package:untitled1/pages/homepage.dart';
import 'package:untitled1/pages/newsdetainpage.dart';


void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => NewsProvder(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context)=>HomePage(),
        NewsDetailPage.routeName: (context)=>NewsDetailPage(),
      },
    );
  }
}
