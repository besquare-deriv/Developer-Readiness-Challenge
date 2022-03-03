//import 'dart:html';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';

import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import '../components/iconwidget.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({ Key? key }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  String? value;
  final  _phone = TextEditingController();
  final  _confirmPass = TextEditingController();
  final _pass = TextEditingController();
  final _api = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String firstName = 'John';
  String lastName = 'Doe';
  String email = 'johndoe@gmail.com';
  String phoneNumber = '+601123456789';
  String password = '********';
  String countryName = 'Indonesia';
  String apiToken = 'XXXXXXXXXXXXXXXX';
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return  Scaffold(
        backgroundColor: const Color.fromRGBO(234, 230, 230, 1) ,
        appBar:
            AppBar( 
              elevation: 0,
              leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),                             
                        onPressed: () => Navigator.of(context).pop(),
                      ), 
              //toolbarHeight: 90,
              backgroundColor: Color(0xFF1F96B0),
              title: Text('Settings',
                      style: TextStyle(
                       color:Colors.white, 
                       fontWeight: FontWeight.bold, 
                      ),
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
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'DM Sans'))),
            Card(
              elevation: 4.0,
              //margin: const EdgeInsets.only(left:10, right:10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              //padding: const EdgeInsets.all(0.5),
              child: Column(
                children: <Widget>[
                  //username
                  ListTile(
                    leading: IconWidget(icon: Icons.account_circle),
                    title: Row(children: [
                      Container(
                        width: width * 0.3819,
                        child: Text(
                          'First Name *',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: 'DM Sans'),
                        ),
                      ),
                      Text('Last Name *')
                    ]),
                    subtitle: Row(children: [
                      Container(
                        width: width * 0.3819,
                        child: Text(firstName),
                      ),
                      Text(lastName),
                    ]),
                  ),

                  ListTile(
                    leading: IconWidget(icon: Icons.email),
                    title: Text('Email*'),
                    subtitle: Text(email),
                  ),

                  ListTile(
                      leading: IconWidget(icon: Icons.phone),
                      title: Text('Phone Number'),
                      subtitle: Text(phoneNumber),
                      ),
 
                  ListTile(
                      leading: IconWidget(icon: Icons.password),
                      title: Text('Password*'),
                      subtitle:
                          Text('${password.replaceAll(RegExp(r"."), "*")}'),
                              ),

                  ListTile(
                      leading: IconWidget(icon: Icons.calendar_today),
                      title: Text('Date of Birth*'),
                      subtitle: Text('${date.month}/${date.day}/${date.year}'),
                      ),
         
                  ListTile(
                    leading: Tab(
                      icon: Image.asset('assets/icons/country.png'),
                      iconMargin: EdgeInsets.only(right: 100),
                    ),
                    title: Text('Country*'),
                    subtitle: Text(countryName),
                  ),

                  ListTile(
                      leading: IconWidget(icon: Icons.fingerprint),
                      title: Text('API Token*'),
                      subtitle: Text(apiToken),
                              ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }  
}