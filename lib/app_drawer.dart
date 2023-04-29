import 'package:flutter/material.dart';
import 'package:flutter_layout/settings.dart';
import 'about.dart';
import 'image_picker.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFEC615A),
              image: DecorationImage(
                image: AssetImage("images/logo.png"),
                fit: BoxFit.contain,
              ),
            ),
            child: null,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Home'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.info,
              ),
              title: const Text('About'),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.train,
            ),
            title: const Text('Activity'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.settings_outlined,
              ),
              title: const Text('Settings'),
            ),
          ),
        ],
      ),
    );
  }
}
