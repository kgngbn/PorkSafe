import 'package:flutter/material.dart';
import 'package:flutter_layout/immutable_widget.dart';
import 'package:flutter_layout/textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_drawer.dart';

class HomeScreen extends StatelessWidget {
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
          HomeScreenTextField(),
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildItem('Bears Breeches', 'Acanthus balanicus',
                    'images/bearsbreeches.jpg'),
                _buildItem('Green Chiretta / Serpentina',
                    'Andrographis paniculate', 'images/serpentina.jpg'),
                _buildItem('Zebra Plant', 'Aphelandra squarrosa',
                    'images/zebraplant.jpg'),
                _buildItem('Chinese Violet', 'Asystasia gangetica',
                    'images/chineseviolet.jpg'),
                _buildItem('Api Api Putih / Bungalon', 'Avicennia alba',
                    'images/bungalon.jpg'),
                _buildItem('Grey Barleria ', 'Barleria albostellata',
                    'images/barleria.jpg'),
                _buildItem('Peristrophe', 'Dicliptera inaequalis',
                    'images/peristrophe.jpg'),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }

  Widget _buildItem(String title, String description, String imagePath) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.brown[100],
        boxShadow: [
          BoxShadow(
            color: Colors.brown[900].withOpacity(0.5),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
