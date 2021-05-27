import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.blue.withOpacity(0.8),
                ),
                onPressed: () {},
              ),
              Text(
                'Featured',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 20,
                ),
              ),
              Container(height: 160, child: _buildFeaturedLists([1, 2, 3])),
              _adContainer('ad.png'),
              SizedBox(
                height: 10,
              ),
              _searchBar(),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 200,
                  child: _albumsListTile(
                    [1, 2, 3, 4, 5],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFeaturedLists(List<dynamic> featured) {
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: featured.length,
      itemBuilder: (ctx, index) {
        return Container(
          margin: EdgeInsets.all(10),
          child: Material(
            shadowColor: Colors.black,
            elevation: 8,
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 2,
                        color: Color(0x882D2D2D),
                      )
                    ]),
                child: Image.asset(
                  'assets/images/singletrack_one.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      });
}

Widget _searchBar() {
  return Container(
    color: Colors.purple.withOpacity(0.15),
    padding: EdgeInsets.symmetric(
      vertical: 2,
      horizontal: 20,
    ),
    child: Row(
      children: [
        SvgPicture.asset(
          'assets/svg/search.svg',
          width: 22,
        ),
        Expanded(
            child: TextField(
          autofocus: false,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        )),
        SvgPicture.asset(
          'assets/svg/order.svg',
          width: 22,
        ),
      ],
    ),
  );
}

Widget _adContainer(String path) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 10,
    ),
    width: double.infinity,
    height: 120,
    child: Image.asset(
      'assets/images/$path',
      fit: BoxFit.cover,
    ),
  );
}

Widget _albumsListTile(List<dynamic> albums) {
  return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: albums.length,
      itemBuilder: (ctx, index) {
        return ListTile(
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    color: Color(0x882D2D2D),
                  )
                ]),
            width: 50,
            height: 50,
            child: Image.asset(
              'assets/images/image3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            'Amelkalew',
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              letterSpacing: 1.05,
              fontSize: 20,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                'Zema Songs',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                '12 Songs - 1 hr 18 min',
                style: TextStyle(color: Colors.yellow, fontSize: 16),
              )
            ],
          ),
          trailing: Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
        );
      });
}
