import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_radio_20/about_app.dart';
import 'package:social_radio_20/customClasses/one_choice_dialog_class.dart';
import 'package:url_launcher/url_launcher.dart';

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

//Setup Choices for the "One Choice Dialog"
//  final SimpleDialog dialog;

  SimpleDialog pushNotificationDialog(bool value) {
    return SimpleDialog(
      title: Text("receiving_push_notifications".tr().toString()),
      children: [
        SimpleDialogItem(
          icon: Icons.circle,
          color: Colors.transparent,
          text: "i_like_to_receive".tr().toString(),
          textColor: getColor(1, value),
          onPressed: () async {
            //Set the push notification from the API
            //Save the push notification choice in shared prefs
            final pushNotification = await SharedPreferences.getInstance();
            pushNotification.setBool("pushNotification", true);
            //Remove the Dialog Box
            Navigator.of(context).pop();
          },
        ),
        SimpleDialogItem(
          icon: Icons.circle,
          color: Colors.transparent,
          text: "i_do_not_like_to_receive".tr().toString(),
          textColor: getColor(2, value),
          onPressed: () async {
            //Set the push notification from the API
            //Save the push notification choice in shared prefs
            final pushNotification = await SharedPreferences.getInstance();
            pushNotification.setBool("pushNotification", false);
            //Remove the Dialog Box
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  //Get the item color based on shared prefs value
  Color getColor(int item, bool valuePush) {
    if (item == 1) {
      if (valuePush) {
        return Colors.blue;
      } else {
        return Colors.black;
      }
    } else {
      if (valuePush) {
        return Colors.black;
      } else {
        return Colors.blue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("setting_title".tr().toString()),
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
          title: Text("about_app".tr().toString(), textAlign: TextAlign.center),
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
          title: Text("version_number".tr().toString(),
              textAlign: TextAlign.center),
          subtitle: Text(_appBasicInfo.version, textAlign: TextAlign.center),
        ),
        //Divider
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Terms of Use Item
        ListTile(
          leading: Icon(Icons.verified_user),
          title:
              Text("terms_of_use".tr().toString(), textAlign: TextAlign.center),
          onTap: () => _showExtURLDialog(
              "http://europeanschoolradio.eu"), //Show dialog and then open URL
        ),
        //Divider
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Privacy Policy
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined),
          title: Text("privacy_policy".tr().toString(),
              textAlign: TextAlign.center),
          onTap: () => _showExtURLDialog(
              "http://europeanschoolradio.eu"), //Show dialog and then open URL
        ),
        //Divider
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Enable Push Notifications
        ListTile(
            leading: Icon(Icons.notifications),
            title: Text("push_notifications".tr().toString(),
                textAlign: TextAlign.center),
            subtitle: Text("push_notifications_subtitle".tr().toString(),
                textAlign: TextAlign.center),
            onTap: () async {
              final pushNotification = await SharedPreferences.getInstance();
              final pushNotificationChoice =
                  pushNotification.getBool("pushNotification") ?? false;
              showDialog<void>(
                  context: context,
                  builder: (context) => pushNotificationDialog(
                      pushNotificationChoice)); //Display "One Choice Dialog"
            }),
        //Divider
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Choose Language Items
        ListTile(
          leading: Icon(Icons.language),
          title: Text("languages".tr().toString(), textAlign: TextAlign.center),
          subtitle: Text("choose_language".tr().toString(),
              textAlign: TextAlign.center),
          onTap: () async {
            //First read the saved language value
            final langPrefsRead = await SharedPreferences.getInstance();
            final langVal = langPrefsRead.getInt("Language") ?? 0;
            //Call the widget function and send the language value for the selectedValue
            languageList(langVal);
          },
        ),
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Delete All Downloads
        ListTile(
            leading: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            title: Text("delete_all_downloaded_episodes".tr().toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red)),
            onTap: () => _deleteAllDownloadsMSG() //Delete the statistics data
            ),
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Delete Statistics Data Item
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text("delete_anonymous_data".tr().toString(),
              textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
          subtitle: Text("delete_all_statistics_data".tr().toString(),
              textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
          //onTap: () => //Delete the statistics data
        ),
        const Divider(
          height: 20,
          thickness: 1,
          color: Colors.black,
        ),
        //Logout Account Item
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("logout".tr().toString(), textAlign: TextAlign.center),
          //onTap: () => //Logout the account from this device
        )
      ],
    );
  }

  //Select languages view
  Future languageList(int languageChoosen) {
    List availableLangs = ["English", "Greek"];
    return SelectDialog.showModal<String>(context,
        label: "select_language".tr().toString(),
        selectedValue: availableLangs[languageChoosen],
        items: List.from(availableLangs), onChange: (String selected) {
      changeLang(selected);
    });
  }

  //Show Alert Dialog to Open External URL
  Future<void> _showExtURLDialog(String url) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("open_external_link".tr().toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("open_external_link_text".tr().toString())
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("ok_txt".tr().toString()),
              onPressed: () {
                Navigator.of(context).pop();
                _launchBrowserURL(url);
              },
            ),
            TextButton(
              child: Text("cancel_txt".tr().toString()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Open Link in Browser
  Future<void> _launchBrowserURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      Fluttertoast.showToast(
          msg: "can_not_open_link".tr().toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  //Show confirmation message - Delete all downloads
  Future<void> _deleteAllDownloadsMSG() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("are_you_sure_u_want_to_procceed".tr().toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("delete_all_downloaded_episodes_message".tr().toString())
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("ok_txt".tr().toString()),
              onPressed: () {
                Navigator.of(context).pop();
                //Delete all downloads
              },
            ),
            TextButton(
              child: Text("cancel_txt".tr().toString()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
