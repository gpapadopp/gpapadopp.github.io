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
        _save(0);
      });
    } else if (selectedLanguage == "Greek") {
      setState(() {
        //Delete Saved Lang
        EasyLocalization.of(context).deleteSaveLocale();
        //Set new lang
        EasyLocalization.of(context).locale = Locale('el', 'GR');
        //Save lang string in shared prefs
        _save(1);
      });
    }
  }

  //Save Language in Shared Prefs
  _save(int currentLanguage) async {
    final langPrefsSave = await SharedPreferences.getInstance();
    langPrefsSave.setInt("Language", currentLanguage);
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
          onTap: () async {
            //First read the saved language value
            final langPrefsRead = await SharedPreferences.getInstance();
            final langVal = langPrefsRead.getInt("Language") ?? 0;
            //Call the widget function and send the language value for the selectedValue
            languageList(langVal);
          },
        )
      ],
    );
  }

  //Select languages view
  Future languageList(int languageChoosen) {
    List availableLangs = ["English", "Greek"];
    return SelectDialog.showModal<String>(context,
        label: "Select Language",
        selectedValue: availableLangs[languageChoosen],
        items: List.from(availableLangs), onChange: (String selected) {
      changeLang(selected);
    });
  }
}
