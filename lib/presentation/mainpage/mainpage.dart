import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_profie_page.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/library/pages/library_page.dart';
import 'package:streaming_mobile/presentation/search/pages/search_page.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<Widget> _widgets = [
    AudioServiceWidget(child: HomePage()),
    SearchPage(),
    LibraryPage(),
    ArtistProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _widgets[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.search,
              color: _currentIndex == 1
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.library_books_outlined,
              color: _currentIndex == 2
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.person,
              color: _currentIndex == 3
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}