import 'package:flutter/material.dart';
import 'package:flutter_layout/basic_screen.dart';
import 'package:flutter_layout/home.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
              image: DecorationImage(
                image: AssetImage("images/icon.jpg"),
                fit: BoxFit.contain,
              ),
            ),
            child: null,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
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
                MaterialPageRoute(builder: (context) => BasicScreen()),
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
          ListTile(
            leading: Icon(
              Icons.settings_outlined,
            ),
            title: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
