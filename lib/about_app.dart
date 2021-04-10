import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutAppPage extends StatefulWidget {
  @override
  _AboutApp createState() => _AboutApp();
}

class _AboutApp extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("about_app_settings_title_txt".tr().toString()),
      ),
      body: new Center(
        child: new Text(
            "Εδώ θα βάλουμε ότι κείμενο θέλουμε, σε όποια γραμματοσειρά θέλουμε, και ότι χρώμα μας αρέσει !!!",
            textAlign: TextAlign.center),
      ),
    );
  }
}
