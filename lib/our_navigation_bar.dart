import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_learning_app/screens/mylearnings.dart';
import 'package:e_learning_app/screens/profile_page.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'navigation_screens/account.dart';
import 'navigation_screens/favourite.dart';
import 'navigation_screens/home.dart';

class OurNavigationbar extends StatefulWidget {
  const OurNavigationbar({super.key});

  @override
  State<OurNavigationbar> createState() => _OurNavigationbarState();
}

class _OurNavigationbarState extends State<OurNavigationbar> {
  var index = 3;

  List<Widget> pages = [
    const ProfilePage(),
    const Favourite(),
    const Mylearnings(),
    const Home()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          letIndexChange: (value) => true,
          index: 3,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          animationDuration: const Duration(milliseconds: 400),
          buttonBackgroundColor: myColorScheme.primary,
          color: myColorScheme.secondary,
          backgroundColor: myColorScheme.primaryContainer,
          items: const [
            Icon(Icons.account_circle_outlined),
            Icon(Icons.favorite_outline_outlined),
            Icon(Icons.school),
            Icon(Icons.home_outlined),
          ],
        ),
        body: pages[index]);
  }
}
