import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/auth/auth_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/cache_bloc/cache_bloc.dart';
import 'package:streaming_mobile/blocs/cache_bloc/cache_event.dart';
import 'package:streaming_mobile/blocs/cache_bloc/cache_state.dart' as cs;
import 'package:streaming_mobile/presentation/auth/pages/reset_password_page.dart';
import 'package:streaming_mobile/presentation/auth/pages/welcome_page.dart';

class ArtistProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<CacheBloc, cs.CacheState>(
            listener: (context, state) {
          if (state is cs.ErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is cs.SuccessfulState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is cs.LoadingState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Clearing cache...')));
          }
        }, builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (context, AsyncSnapshot<SharedPreferences> s) {
                  
                  if (s.hasData) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, color: Colors.grey,size: 15,),
                        SizedBox(width: 5,),
                        Text(s.data.getString('phone_number') ?? '', style: TextStyle(color: Colors.grey, fontSize: 15),),
                      ],
                    );
                  }

                  return Container();
                }
              ),
              SizedBox(
                height: 13,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 10,
              ),
              _listSelectorTiles(
                  title: 'Change Password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 25,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context,
                        ResetPasswordPage.resetPasswordPageRouterName);
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
                                      BlocProvider.of<CacheBloc>(context)
                                          .add(ClearCache());
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
          );
        }),
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
}
