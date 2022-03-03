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
                  //email
                  ListTile(
                    leading: IconWidget(icon: Icons.email),
                    title: Text('Email*'),
                    subtitle: Text(email),
                  ),

                  //Phone Number
                  ListTile(
                      leading: IconWidget(icon: Icons.phone),
                      title: Text('Phone Number'),
                      subtitle: Text(phoneNumber),
                      trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                                  scrollable: true,
                                  title: Text('Phone Number'),
                                  insetPadding: EdgeInsets.zero,
                                  content: /* Padding(
                              padding: const EdgeInsets.all(8.0),  */
                                      Container(
                                          width: width * 0.7639,
                                          height: height * 0.1119,
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: <Widget>[
                                                TextFormField(
                                                  controller: _phone,
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      labelText: 'Phone Number',
                                                      hintText: phoneNumber),
                                                  validator: (phoneNumber) {
                                                    if (phoneNumber != null &&
                                                        phoneNumber.length >
                                                            9) {
                                                      return null;
                                                    }
                                                    return "Phone number can't be smaller than 9 digits";
                                                  },
                                                ),
                                              ],
                                            ),
                                          )),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('CANCEL'),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 15),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          return setState(() {
                                            phoneNumber = (_phone.text);
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      child: const Text('CHANGE'),
                                    ),
                                  ],
                                );
                              }))),
                  //password()
                  ListTile(
                      leading: IconWidget(icon: Icons.password),
                      title: Text('Password*'),
                      subtitle:
                          Text('${password.replaceAll(RegExp(r"."), "*")}'),
                              ),

                  //calendar
                  ListTile(
                      leading: IconWidget(icon: Icons.calendar_today),
                      title: Text('Date of Birth*'),
                      subtitle: Text('${date.month}/${date.day}/${date.year}'),
                      ),
                  //country
                  ListTile(
                    leading: Tab(
                      icon: Image.asset('assets/icons/country.png'),
                      iconMargin: EdgeInsets.only(right: 100),
                    ),
                    title: Text('Country*'),
                    subtitle: Text(countryName),
                  ),

                  //API token
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
  


// bool validateStructure(String value) {
//   String pattern =
//       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//   RegExp regExp = new RegExp(pattern);
//   return regExp.hasMatch(value);
// }

// Widget _buildDropdownItem(Country country) => Container(
//       child: Row(
//         children: <Widget>[
//           CountryPickerUtils.getDefaultFlagImage(country),
//           SizedBox(
//             width: 8.0,
//           ),
//           Text("+${country.phoneCode}(${country.isoCode})"),
//         ],
//       ),
//     );