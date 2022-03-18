//import 'dart:html';

import 'dart:convert';
import 'package:drc/components/change_theme_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../components/iconwidget.dart';

class SettingsPage extends StatefulWidget {
  final String value;

  const SettingsPage({Key? key, required this.value}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState(value);
}

class _SettingsPageState extends State<SettingsPage> {
  String value;
  _SettingsPageState(this.value);
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _phone = TextEditingController();
  final _confirmPass = TextEditingController();
  final _pass = TextEditingController();
  final _api = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String firstName = 'John';
  String lastName = 'Doe';
  String email = 'johndoe@gmail.com';
  String phoneNumber = '+601123456789';
  String password = '********';
  String countryName = 'Indonesia';
  String apiToken = '***********';
  DateTime date = DateTime.now();

  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

  void sendMessageAuthorize() {
    channel.sink.add('{"authorize": "$value"}');
  }

  void getAccountSettings() {
    channel.sink.add('{"get_settings": 1}');
  }

  void initState() {
    sendMessageAuthorize();
    getAccountSettings();
    getAuthorize();
    super.initState();
  }

  void getAuthorize() {
    channel.stream.listen((event) {
      final data = jsonDecode(event);

      if (data['msg_type'] == 'authorize') {
        getAccountSettings();
      }

      if (data['msg_type'] == 'get_settings') {
        setState(() {
          firstName = data['get_settings']['first_name'];
          lastName = data['get_settings']['last_name'];
          email = data['get_settings']['email'];
          phoneNumber = data['get_settings']['phone'];
          countryName = data['get_settings']['country'];
          apiToken = value;
          date = (DateTime.fromMillisecondsSinceEpoch(
              data['get_settings']['date_of_birth'] * 1000));
          // String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(time);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var hiddenToken = apiToken.replaceRange(0, 11, 'XXXXXXXXXXX');
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        //backgroundColor: Theme.of(context).backgroundColor,//const Color.fromRGBO(234, 230, 230, 1) ,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back, /* color: Colors.black, size: 35, */
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
          //toolbarHeight: 90,
          //backgroundColor: Color(0xFF1F96B0),
          title: Text(
            'Settings',
            style: TextStyle(
                //color: Theme.of(context).colorScheme.onSurface,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'DM Sans'),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Text('Account Infomation',
                      style: TextStyle(
                          //color:Theme.of(context).colorScheme.onSurface,
                          fontSize: 24,
                          fontFamily: 'DM Sans'))),
              Card(
                color: Color(0xFFFFF4F4F4),
                elevation: 4.0,
                margin: const EdgeInsets.only(left: 10, right: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                //padding: const EdgeInsets.all(0.5),
                child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text('GENERAL',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    alignment: Alignment.centerLeft,
                  ),

                  //username
                  ListTile(
                    leading: IconWidget(icon: Icons.account_circle),
                    title: Row(children: [
                      Container(
                        width: width * 0.3819,
                        child: Text(
                          'First Name *',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'DM Sans', color: Colors.black),
                        ),
                      ),
                      Text(
                        'Last Name *',
                        style: TextStyle(color: Colors.black),
                      )
                    ]),
                    subtitle: Row(children: [
                      Container(
                        width: width * 0.3819,
                        child: Text(
                          '$firstName',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Text(
                        '$lastName',
                        style: TextStyle(color: Colors.black),
                      ),
                    ]),
                  ),
                  //email
                  ListTile(
                    leading: IconWidget(icon: Icons.email),
                    title: Text(
                      'Email*',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      '$email',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  ListTile(
                    leading: IconWidget(icon: Icons.phone),
                    title: Text(
                      'Phone Number',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      '$phoneNumber',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  //calendar
                  ListTile(
                    leading: IconWidget(icon: Icons.calendar_today),
                    title: Text(
                      'Date of Birth*',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      '${date.month}/${date.day}/${date.year}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  //country
                  ListTile(
                    leading: Tab(
                      icon: Image.asset('assets/icons/country.png'),
                      iconMargin: EdgeInsets.only(right: 100),
                    ),
                    title: Text(
                      'Country*',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      countryName,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    leading: IconWidget(icon: Icons.fingerprint),
                    title: Text(
                      'API Token*',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      '$hiddenToken',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 0,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                    color: Color.fromRGBO(196, 196, 196, 1),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text('THEME',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                    alignment: Alignment.centerLeft,
                  ),

                  ListTile(
                      leading: IconWidget(icon: Icons.dark_mode),
                      title: Text(
                        'Dark mode',
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: ChangeThemeButtonWidget()),
                ]),
              )
            ],
          ),
        ));
  }
}
