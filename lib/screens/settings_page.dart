//import 'dart:html';

import 'package:drc/screens/contract_details.dart';
import 'package:drc/screens/explorer_page.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import '../components/iconwidget.dart';
import 'graph_page.dart';
import 'history_page.dart';
import 'login_page.dart';
import 'market_list_page.dart';
import 'profile_page.dart';

class Setting extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Settings",
      home: SettingsPage(),
    );
  }
}
class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final  _phone = TextEditingController();
  final  _confirmPass = TextEditingController();
  final _pass = TextEditingController();
  final  _api = TextEditingController();
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
                        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35,),                                   
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContractDetails()));
                        }, 
                      ),
              //toolbarHeight: 90,
              backgroundColor: Color(0xFF1F96B0),
              title: Text('Settings',
                      style: TextStyle(
                       color:Colors.black, 
                       fontSize: 28, 
                       fontWeight: FontWeight.bold, 
                       fontFamily:'DM Sans'
                      ),
                     ),
              centerTitle: true,
            ),
  
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child:
          Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(vertical:28) ,
                child: 
              Text('Account Infomation',
                style: TextStyle(
                color:Colors.black, 
                fontSize: 24,
                fontFamily:'DM Sans'))),
              Card(
                elevation: 4.0,
                  //margin: const EdgeInsets.only(left:10, right:10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), 
                  //padding: const EdgeInsets.all(0.5),
                    child: Column(
                    children: <Widget>[
                  //username
                  ListTile(
                    leading: IconWidget(icon:Icons.account_circle),
                    title: Row(
                      children: [
                        Container(
                          width: width*0.3819,    
                          child:  
                              Text('First Name *', 
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily:'DM Sans'
                                      ),
                              ),
                        ),
                        Text ('Last Name *')
                      ]
                    ),
                    subtitle: Row(
                        children: [
                          Container(
                            width: width*0.3819, 
                            child: 
                              Text(firstName),
                              ),
                          Text (lastName) ,
                        ]
                    ),
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
                      onPressed: () => 
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                            scrollable: true,
                            title: Text('Phone Number'),
                            insetPadding: EdgeInsets.zero,
                            content: /* Padding(
                              padding: const EdgeInsets.all(8.0),  */
                              Container(
                              width: width*0.7639,
                              height: height*0.1119,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: _phone,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Phone Number',
                                        hintText: phoneNumber
                                      ),
                                      validator: (phoneNumber) {
                                        if (phoneNumber != null && phoneNumber.length > 9) {
                                          return null;
                                        }
                                        return "Phone number can't be smaller than 9 digits";
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ),
                          actions: [
                            TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 15),
                                ),
                                onPressed: () {
                                    Navigator.pop(context);
                                },
                                child: const Text('CANCEL'),
                              ),
                            TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 15),
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
                        }
                        )
                    )
                  ),
                    //password()
                  ListTile(
                    leading: IconWidget(icon: Icons.password),
                    title: Text('Password*'),
                    subtitle: Text('${password.replaceAll(RegExp(r"."), "*")}'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit), 
                      onPressed: () => 
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                            scrollable: true,
                            title: Text('Password'),
                            insetPadding: EdgeInsets.zero,
                            content: /* Padding(
                              padding: const EdgeInsets.all(8.0),  */
                              Container(
                              width: width*0.7639,
                              height: height*0.2239,
                              child: Form(
                                key: _formKey,
                                child: ListView(
                                      children: <Widget>[
                                            TextFormField(
                                                  obscureText: true,
                                                  controller: _pass,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'New Password',
                                                    hintText: 'New password',
                                                  ),
                                                  validator: (val){
                                                      if(val!.isEmpty)
                                                          return 'Password is required';
                                                      else if(validateStructure (_pass.text))
                                                          return null;
                                                      }
                                            ),
                                            SizedBox(height: 10,),
                                            TextFormField(
                                                obscureText: true,
                                                controller: _confirmPass,
                                                decoration: InputDecoration(
                                                                  border: OutlineInputBorder(),
                                                                  labelText: 'Re-type Password',
                                                                  hintText: 'Re-type password',
                                                                ),
                                                validator: (val){
                                                    if(val!.isEmpty){
                                                        return 'Password is required';
                                                    }
                                                    if(validateStructure (_pass.text))
                                                                if(val != _pass.text){
                                                                    return 'Not Match';
                                                                }
                                                                else return null;
                                                        return 'Please input at least 1 Uppercase, 1 Lowercase, 1 Numeric and 1 Special Character';
                                                }
                                            ),
                                      ]
                                  )
                             )
                             ),
                    actions: [
                     TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                            Navigator.pop(context);
                        },
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            return setState(() {
                            password = (_api.text);
                            Navigator.pop(context);
                          }); 
                          }                         
                        },
                        child: const Text('CONFIRM'),
                      ),
                    ],
                  );
                }))),
                  
                  //calendar
                  ListTile(
                    leading: IconWidget(icon: Icons.calendar_today),
                    title: Text('Date of Birth*'),
                    subtitle: Text('${date.month}/${date.day}/${date.year}'),
                    trailing: IconButton(icon: Icon(Icons.calendar_month), onPressed: () => pickDate(context) ,)   
                  ),
                  //country
                  ListTile(
                    leading: Tab(icon: Image.asset('assets/icons/country.png'), iconMargin: EdgeInsets.only(right: 100) ,),
                    title: Text('Country*'),
                    subtitle: Text(countryName),
                    trailing: CountryPickerDropdown(
                                  initialValue: 'ID',
                                  itemBuilder: _buildDropdownItem,
                                  onValuePicked: (Country country) {
                                    setState(() {
                                      countryName = "${country.name}";
                                    });
                                  },
                                ) ,
                    ),

                  //API token 
                  ListTile(
                    leading: IconWidget(icon: Icons.fingerprint),
                    title: Text('API Token*'),
                    subtitle: Text(apiToken),
                    trailing: IconButton(icon: Icon(Icons.edit), onPressed: () => showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                    scrollable: true,
                    title: Text('API Token'),
                    insetPadding: EdgeInsets.zero,
                    content: /* Padding(
                      padding: const EdgeInsets.all(8.0),  */
                      Container(
                      width: width*0.7639,
                      height: height*0.1119,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _api,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'API Token',
                                hintText: apiToken
                              ),
                              validator: (value) {
                                if (value != null && value.length > 9) {
                                  return null;
                                }
                                return "API token must contains at least 9 letters";
                              },
                            ),
                          ],
                        ),
                      )
                    ),
                   actions: [
                     TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                            Navigator.pop(context);
                        },
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            return setState(() {
                            apiToken = (_api.text);
                            Navigator.pop(context);
                          }); 
                          }                         
                        },
                        child: const Text('ADD'),
                      ),
                    ],
                  );
                }))),
                ],
                ),
             )
                ],
      ),
      ),
      
         bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.home), 
                          iconSize: 40,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                        ),
              
              IconButton(icon: Image.asset('assets/icons/explore.png'), 
                          iconSize: 40,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ExplorePage()));
                          }
                        ),
                        
              IconButton(icon: Image.asset('assets/icons/plus.png'), 
                          iconSize: 70,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MarketScreen()));
                          }
                        ),
        
              IconButton(icon: Image.asset('assets/icons/history.png'), 
                          iconSize: 40,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HistoryScreen()));
                          }
                        ),

              IconButton(icon: Image.asset('assets/icons/user.png'), 
                          iconSize: 40,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()));
                          }
                        ),
            ],
          ),
          shape: CircularNotchedRectangle(),
          color: Colors.black,
        ),
        
      );
  }
  pickDate(BuildContext context) async {
    final initialDate = DateTime.now().year - 18;
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime(initialDate),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year - 17,DateTime.now().month - 11, DateTime.now().day - 30),
    );

    if (newDate != null && newDate != date) 
    setState(() {
      date = newDate;
    });
  }
}
bool validateStructure(String value){
        String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp regExp = new RegExp(pattern);
        return regExp.hasMatch(value);
  }

Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );