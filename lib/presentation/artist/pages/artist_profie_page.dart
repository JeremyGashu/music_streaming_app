import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/presentation/auth/pages/reset_password_page.dart';
import 'package:streaming_mobile/presentation/auth/pages/welcome_page.dart';

class ArtistProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //the name and back navigator icon and vertical more option
              _upperSection(),
              Divider(),
              //circular artist image
              Padding(
                padding: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Container(
                    width: 130,
                    height: 130,
                    child: Image.asset(
                      'assets/images/artist_image.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              //artist username
              Text(
                '@dawitgetachew',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              SizedBox(
                height: 13,
              ),

              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(40),
              //     color: Colors.purple,
              //   ),
              //   width: 160,
              //   height: 35,
              //   child: Center(
              //       child: Text(
              //     'Edit Profile',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 20,
              //     ),
              //   )),
              // ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              //ad container
              // _adContainer('ad.png'),

              SizedBox(
                height: 10,
              ),
              _listSelectorTiles(
                title: 'Notification',
                icon: Icon(
                  Icons.notification_important,
                  color: Colors.purple,
                  size: 25,
                ),
              ),

              _listSelectorTiles(
                title: 'Change Password',
                icon: Icon(
                  Icons.lock,
                  color: Colors.purple,
                  size: 25,
                ),
                onTap: () {
                  Navigator.pushNamed(context, ResetPasswordPage.resetPasswordPageRouterName);
                }
              ),
              // _listSelectorTiles(
              //   title: 'Setting',
              //   icon: Icon(
              //     Icons.settings,
              //     color: Colors.purple,
              //     size: 25,
              //   ),
              // ),
              _listSelectorTiles(
                  title: 'Log Out',
                  icon: Icon(
                    Icons.logout,
                    color: Colors.purple,
                    size: 25,
                  ),
                  onTap: () async {
                    await AudioService.stop();
                    BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
                    Navigator.pushNamedAndRemoveUntil(context, WelcomePage.welcomePageRouteName, (route) => false);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _listSelectorTiles({String title, Icon icon, Function onTap}) {
  return ListTile(
    onTap: onTap ?? () {},
    leading: icon,
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    ),
    trailing: Icon(
      Icons.arrow_forward_ios_rounded,
      color: Colors.grey,
      size: 15,
    ),
  );
  // return Row(
  //   children: [
  //     SizedBox(
  //       width: 5,
  //     ),
  //     icon,
  //     SizedBox(
  //       width: 17,
  //     ),
  //     Expanded(
  //         child: Text(
  //       '$title',
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontSize: 18,
  //         fontWeight: FontWeight.w700,
  //       ),
  //     )),
  //     Icon(
  //       Icons.arrow_forward_ios_rounded,
  //       color: Colors.grey,
  //       size: 15,
  //     ),
  //     SizedBox(
  //       width: 10,
  //     ),
  //   ],
  // );
}

//back nav, name and more vertical iconBuilder
Widget _upperSection() {
  return Padding(
    padding: EdgeInsets.all(5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black.withOpacity(0.5),
          ),
          onPressed: () {},
        ),
        Text(
          'Dawit Getachew',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black.withOpacity(0.5),
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}

//the add image under the upper section
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
