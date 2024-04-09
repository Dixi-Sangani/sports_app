import 'package:demoproject/notifications/notification_service.dart';
import 'package:flutter/material.dart';
/*import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';*/

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*
    Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        return authResult.user;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<User?> _signInWithFacebook() async {
    try {
      final AccessToken? accessToken = await FacebookAuth.instance.login();
      if (accessToken != null) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        return authResult.user;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }*/




  NotificationsServices notificationsServices = NotificationsServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationsServices.initialiseNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          ElevatedButton(onPressed: () {
            notificationsServices.sendNotification('This is a title', 'This is a body');
          }, child: const Text('Push Notification')),
          ElevatedButton(onPressed: () {

          }, child: const Text('Schedule Notification')),
          ElevatedButton(onPressed: () {

          }, child:
          const Text('Cancel/Stop Notification')),
        ],
      ),
    );
  }
}


/*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final User? user = await _signInWithGoogle();
                if (user != null) {
                  print('Signed in with Google: ${user.displayName}');
                }
              },
              child: Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                final User? user = await _signInWithFacebook();
                if (user != null) {
                  print('Signed in with Facebook: ${user.displayName}');
                }
              },
              child: Text('Sign in with Facebook'),
            ),
          ],
        ),
      ),*/