import 'package:flutter/material.dart';
import 'package:instantdel/pages/homepage.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

  class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(                           //return LayoutBuilder
        builder: (context, constraints) {
      return OrientationBuilder(                  //return OrientationBuilder
          builder: (context, orientation) {
        //initialize SizerUtil()
        SizerUtil().init(constraints, orientation);
        return MaterialApp(
          title: 'Instant Delivery',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: Colors.blue,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 22.0,color: Colors.blue),
            headline2: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            bodyText1: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Colors.blueAccent,
            ),
           ),
          ),
          home: HomePage(),
    );
          },
      );
        },
    );
  }
}

