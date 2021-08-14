import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streaming_mobile/blocs/config/config_bloc.dart';
import 'package:streaming_mobile/blocs/config/config_state.dart';
import 'package:streaming_mobile/presentation/artist/pages/artist_profie_page.dart';
import 'package:streaming_mobile/presentation/homepage/pages/homepage.dart';
import 'package:streaming_mobile/presentation/info/force_update_page.dart';
import 'package:streaming_mobile/presentation/library/pages/library_page.dart';
import 'package:streaming_mobile/presentation/search/pages/search_page.dart';

class MainPage extends StatefulWidget {
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
    return BlocListener<ConfigBloc, ConfigState>(
      listener: (context, state) async {
        if (state is LoadedConfigData) {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String version = packageInfo.version;

          print('app version => $version');

          if (state.configData.forceUpdate &&
              state.configData.version != version) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => ForceUpdate()),
                (route) => false);
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          children: _widgets,
          index: _currentIndex,
        ),
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
                color: _currentIndex == 0 ? Colors.black : Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.search,
                color: _currentIndex == 1 ? Colors.black : Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.library_books_outlined,
                color: _currentIndex == 2 ? Colors.black : Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.person,
                color: _currentIndex == 3 ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
