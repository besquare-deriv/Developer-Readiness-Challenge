import 'package:flutter/material.dart';

import '../components/button_widget.dart';
import '../components/profile_widget.dart';
import '../constants.dart';
import '../utils/user_information.dart';
import 'graph_page.dart';
import 'history_page.dart';
import 'login_page.dart';
import 'market_list_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    const user = UserInformation.myUser;

    return Scaffold(
      backgroundColor: Colors.white,
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
              decoration: BoxDecoration(color: Color(0xFF1F96B0)),
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
            Center(child: buildBalanceAcc(user)),

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
                    primary: Color(0xFFFFC4C4C4),
                    onPrimary: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    minimumSize: const Size(200.0, 50.0)),
                onPressed: () {}),

            const SizedBox(height: 25),
            ElevatedButton(
                child: Text(
                  'FAQs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFFC4C4C4),
                    onPrimary: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    minimumSize: const Size(200.0, 50.0)),
                onPressed: () {}),

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
                onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: <Widget>[
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.white),
          )
        ],
      );

  Widget buildBalanceAcc(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Account Balance:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Text(
                user.accbalance,
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
