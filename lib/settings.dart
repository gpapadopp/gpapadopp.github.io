import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_radio_20/about_app.dart';
import 'package:social_radio_20/about_app.dart';

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

  //App Basic Info
  PackageInfo _appBasicInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _appBasicInfo = info;
    });
  }

  //Initialize State Function
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("setting_title_txt".tr().toString()),
        ),
        body: getListView());
  }

  //ListView Widget
  Widget getListView() {
    return ListView(
      children: <Widget>[
        //About App Item
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("about_app_settings_title_txt".tr().toString(),
              textAlign: TextAlign.center),
          onTap: () async {
            //Go to the about app page
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutAppPage()));
          },
        ),
        //Divider
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Version Number Item
        ListTile(
          leading: Icon(Icons.format_list_numbered),
          title: Text("version_number_settings_title_txt".tr().toString(),
              textAlign: TextAlign.center),
          subtitle: Text(_appBasicInfo.version, textAlign: TextAlign.center),
        ),
        //Divider
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Choose Language Items
        ListTile(
          leading: Icon(Icons.language),
          title: Text("languages_settings_title_txt".tr().toString(),
              textAlign: TextAlign.center),
          subtitle: Text("languages_settings_subtitle_txt".tr().toString(),
              textAlign: TextAlign.center),
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
