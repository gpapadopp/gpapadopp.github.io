import 'package:flutter/material.dart';
import 'package:social_radio_20/settings.dart';
import 'package:easy_localization/easy_localization.dart';

void main() {
  //Start the app with EasyLocalization
  //runApp(MyApp());
  runApp(EasyLocalization(
    child: MyApp(), //Main class
    path: "assets/languages", //Translation folder
    saveLocale: true, //To always save the current translation
    supportedLocales: [
      Locale('en', 'US'),
      Locale('el', 'GR')
    ], //Supported languages
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Radio 2.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MyHomePage(title: "home".tr().toString()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Variable to get the current index of the bottom navigation bar
  int _currentIndex = 0;
  //List to save the paths of the main display widgets
  final List<Widget> _children = [HomePage(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings"),
              backgroundColor: Colors.blue)
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// This is the design of the home page
class HomePage extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Center(
        child: new Text("test".tr().toString()),
      ),
    );
  }
}
