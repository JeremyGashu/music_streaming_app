import 'package:flutter/material.dart';
import 'package:streaming_mobile/presentation/manual_download/widgets/downloaded_page.dart';
import 'package:streaming_mobile/presentation/manual_download/widgets/downloading_page.dart';

class ManualDownloadPage extends StatefulWidget {
  @override
  _ManualDownloadPageState createState() => _ManualDownloadPageState();
}

class _ManualDownloadPageState extends State<ManualDownloadPage> {
  List<Widget> _widgets = [
    DownloadingPage(),
    DownloadedPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: TabBar(
                unselectedLabelColor: Colors.black54,
                labelColor: Colors.black87,
                indicatorColor: Colors.grey,
                onTap: (index) {
                  print(index);
                },
                tabs: [
                  Tab(
                    text: 'Downloading',
                  ),
                  Tab(
                    text: 'Downloaded',
                  ),
                ]),
          ),
          body: TabBarView(
            children: _widgets,
          ),
        ),
      ),
    );
  }
}
