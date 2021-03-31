import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //Change default language
  void changeLang(String selectedLanguage) {
    if (selectedLanguage == "English") {
      setState(() {
        //Delete Saved Lang
        EasyLocalization.of(context).deleteSaveLocale();
        //Set new lang
        EasyLocalization.of(context).locale = Locale('en', 'US');
        //Save lang string in shared prefs
        _save("English");
      });
    } else if (selectedLanguage == "Greek") {
      setState(() {
        //Delete Saved Lang
        EasyLocalization.of(context).deleteSaveLocale();
        //Set new lang
        EasyLocalization.of(context).locale = Locale('el', 'GR');
        //Save lang string in shared prefs
        _save("Greek");
      });
    }
  }

  //Save Language in Shared Prefs
  _save(String currentLanguage) async {
    final SharedPreferences langPrefsSave =
        await SharedPreferences.getInstance();
    await langPrefsSave.setString("Language", currentLanguage);
  }

  //Read Language from Shared Prefs
  _read() async {
    final SharedPreferences langPrefsRead =
        await SharedPreferences.getInstance();
    return langPrefsRead.getString("Language") ?? "Engish";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Settings"),
        ),
        body: getListView());
  }

  //ListView Widget
  Widget getListView() {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.language),
          title: Text("langs".tr().toString()),
          subtitle: Text("Choose the app's language"),
          onTap: () {
            String test = _read().toString();
            //languageList();
            Fluttertoast.showToast(
                msg: test,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          },
        )
      ],
    );
  }

  //Select languages view
  Future languageList() {
    List availableLangs = ["English", "Greek"];
    return SelectDialog.showModal<String>(context,
        label: "Select Language",
        selectedValue: _read().toString(),
        items: List.from(availableLangs), onChange: (String selected) {
      changeLang(selected);
    });
  }
}
