import 'dart:convert';

import 'package:drc/screens/faq_page.dart';
import 'package:drc/Authorization/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import '../components/button_widget.dart';
import '../components/profile_widget.dart';
import '../constants.dart';
import '../utils/user_information.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  final String value1;

  const ProfilePage(this.value1, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(value1);
}

class _ProfilePageState extends State<ProfilePage> {
  String value1;
  _ProfilePageState(this.value1, {Key? key});

  String email = 'hello@email.com';
  String username = 'JohnDoe';
  num balance = 0.0;

  final channel = IOWebSocketChannel.connect(
        Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'));

    void sendMessageAuthorize() {
      channel.sink.add('{"authorize": "$value1"}');
    }

    void sendMessageStatement() {
      channel.sink.add('{"statement": 1, "description": 1, "limit": 999}');
    }

    void initState() {
        sendMessageAuthorize();
        sendMessageStatement();
        getAuthorize();
        super.initState();
      }


    void getAuthorize() {
    channel.stream.listen((event) {
      final data = jsonDecode(event);
      
      List<dynamic> time = [];
      List<String> currency = [];
      List<String> typeCurrency = [];
      List<String> displayName = [];


      
      if (data['msg_type'] == 'authorize') {
         sendMessageStatement();
       }

      if (data['msg_type'] == 'authorize') {
        sendMessageStatement();
        setState(() {
          balance = data['authorize']['balance'];

          email = data['authorize']['email'];

          username = data['authorize']['email']
              .substring(0, data['authorize']['email'].indexOf('@'));
        });
      }
    

      if (data['msg_type'] == 'statement') {
        // initialize the length of contracts
        int loopCount = data['statement']['count'];

        // Starts the first for loop
        int i = loopCount - 1;
        balance = data['statement']['transaction'][i]['balance'];
      }
    });
    }
  @override
  Widget build(BuildContext context) {
    const user = UserInformation.myUser;

    return Scaffold(
      //backgroundColor: Colors.white,

      //appBar: buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 24,
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.color),
              child: Row(
                children: [
                  const SizedBox(
                    width: 24,
                  ),
                  ProfileWidget(
                    imagePath: user.imagePath,
                    onClicked: () async {},
                  ),
                  const SizedBox(width: 50),
                  Column(
                    children: [
                      const SizedBox(height: 80),
                      Center(child: buildName(user)),
                    ],
                  ),
                ],
              ),
            ),
            // SizesWidget(),
            const SizedBox(height: 30),
            Center(
              child: buildBalanceAcc(user),
            ),

            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                const SizedBox(width: 50),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'API Token:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 120),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit',
                          style: TextStyle(color: Color(0xFFF3F72AF)),
                        ),
                      ],
                    ), //style: TextButton.styleFrom(),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            Center(child: buildTokenButton()),

            const SizedBox(height: 25),
            ElevatedButton(
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.tertiaryContainer,
                    onPrimary: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    minimumSize: const Size(200.0, 50.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => SettingsPage(value: value1),
                      ),
                    );
                  }),

            const SizedBox(height: 25),
            ElevatedButton(
                child: Text(
                  'FAQs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.tertiaryContainer,
                    onPrimary: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    minimumSize: const Size(200.0, 50.0)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFAQsPage(),
                    ),
                  );
                }),

            const SizedBox(height: 25),
            ElevatedButton(
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFF305FAD),
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    minimumSize: const Size(200.0, 50.0)),
                onPressed: () {
                  AuthHelper().logOut();
                }),
          ],
        ),
      ),
    );
  }
    

  Widget buildName(User user) => Column(
        children: <Widget>[
          Text(
            '$username',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            '$email',
            //style: const TextStyle(color: Colors.white),
          )
        ],
      );

  Widget buildBalanceAcc(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              'Account Balance:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Text(
                '$balance',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );

  Widget buildTokenButton() => ButtonWidget(
        text: 'xxxx-xxxx-xxxx-xxxx',
        onClicked: () {},
      );
}
