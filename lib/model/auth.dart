import 'package:example_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  Future<FirebaseUser> handleSignIn() async {
 
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      UserModel().firstCreateRecord(user);

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void signOutGoogle() async{
    await _googleSignIn.signOut();
    print("User Sign Out");
  }

  String getCurrentUser() {
    FirebaseAuth.instance.currentUser().then((user){
      return user.uid;
    });
  }
}
