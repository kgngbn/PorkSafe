import 'package:flutter/material.dart';
import 'package:flutter_layout/immutable_widget.dart';
import 'package:flutter_layout/text_layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_drawer.dart';

class BasicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown.shade900,
        title: Text('Flora',
            style: GoogleFonts.sassyFrass(
                fontSize: 50, color: Colors.brown.shade50)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset('images/icon.jpg'),
          TextLayout(),
        ],
      ),

      drawer: AppDrawer(),
          );
 
  }
}
