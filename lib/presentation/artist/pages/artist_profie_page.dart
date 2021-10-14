import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/core/utils/helpers.dart';
import 'package:streaming_mobile/data/models/local_download_task.dart';
import 'package:streaming_mobile/presentation/auth/pages/reset_password_page.dart';
import 'package:streaming_mobile/presentation/auth/pages/welcome_page.dart';
import 'package:streaming_mobile/presentation/common_widgets/custom_dialog.dart';

class ArtistProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //the name and back navigator icon and vertical more option
              // _upperSection(),
              // Divider(),
              //circular artist image
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Container(
                    width: 130,
                    height: 130,
                    child: Image.asset(
                      'assets/images/artist_placeholder.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              //artist username
              // Text(
              //   '@dawitgetachew',
              //   style: TextStyle(
              //     fontSize: 15,
              //     color: Colors.black.withOpacity(0.5),
              //   ),
              // ),
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
              // _listSelectorTiles(
              //   title: 'Notification',
              //   icon: Icon(
              //     Icons.notification_important,
              //     color: Colors.grey,
              //     size: 25,
              //   ),
              // ),

              _listSelectorTiles(
                  title: 'Change Password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                        context, ResetPasswordPage.resetPasswordPageRouterName);
                  }),
              _listSelectorTiles(
                  title: 'Clear Cache',
                  icon: Icon(
                    Icons.cached,
                    color: Colors.grey,
                    size: 25,
                  ),
                  onTap: () async {
                    //LocalHelper clearCached(context)
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Are you sure you want to cahce?'),
                            title: Text('Clear Cache'),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    try {
                                      Navigator.pop(context);
                                      await clearCache(context);
                                      
                                    } catch (e) {
                                      // Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No')),
                            ],
                          );
                        });
                  }),
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
                    color: Colors.grey,
                    size: 25,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Are you sure you want to logout?'),
                            title: Text('Log Out'),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await AudioService.stop();
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(LogOutEvent());
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        WelcomePage.welcomePageRouteName,
                                        (route) => false);
                                  },
                                  child: Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No')),
                            ],
                          );
                        });
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

Future<void> clearCache(BuildContext context) async {
  Box<LocalDownloadTask> userDownloads =
      await Hive.openBox<LocalDownloadTask>('user_downloads');
  List<String> ids = userDownloads.values.map((e) => e.songId).toList();
  String dir = await LocalHelper.getLocalFilePath();
  Directory localDownloadDir = Directory(dir);
  if (localDownloadDir.listSync().length == 0) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CustomAlertDialog(
          type: AlertType.SUCCESS,
          message: 'Your cache is already clean!',
        )));
        // return Navigator.pop(context);
  }
  int counter = 0;
  localDownloadDir.listSync().forEach((folder) {
    String id = folder.path.split('/').last;

    if (!ids.contains(id)) {
      try {
        folder.deleteSync(recursive: true);
        counter++;
      } catch (e) {
        // throw Exception(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: CustomAlertDialog(
            type: AlertType.ERROR,
            message: 'Error deleting $id!',
          ),
        ));
        // return Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CustomAlertDialog(
          type: AlertType.SUCCESS,
          message: 'No cache to delete!',
        ),
      ));
      // return Navigator.pop(context);
    }
  });
  if (counter > 0) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CustomAlertDialog(
          type: AlertType.SUCCESS,
          message: '$counter Items cleared!',
        )));
        // return Navigator.pop(context);
  }

}
