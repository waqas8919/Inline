import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class FirebaseAuthProvider {
  static final FirebaseAuth _auth = FirebaseAuth.instance;



  Future signInWithEmail(String email, String password) async {

    FirebaseUser user;

    String errorMessage;


     try {
       var value = await _auth.signInWithEmailAndPassword(
           email: email, password: password);
       return value.user;
     }catch ( e) {
       return e.message;
     }
  }


  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        case "ERROR_INVALID_EMAIL":
          return "Your email address appears to be malformed.";
           break;
         case "ERROR_WRONG_PASSWORD":
           return "Your password is wrong.";
           break;
         case "ERROR_USER_NOT_FOUND":
           return "User with this email doesn't exist.";
           break;
         case "ERROR_USER_DISABLED":
           return "User with this email has been disabled.";
           break;
         case "ERROR_TOO_MANY_REQUESTS":
           return "Too many requests. Try again later.";
           break;
         case "ERROR_OPERATION_NOT_ALLOWED":
           return "Signing in with Email and Password is not enabled.";
           break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

  Future<bool> isUserSignIn() async {
    var currUser = await _auth.currentUser();
    return currUser != null;
  }

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }

  Future<void> signOut() async {
//    _googleSignIn.signOut();
//    _googleSignIn.isSignedIn().then((value) {
//      if(value==true){
//        _googleSignIn.signOut();
//      }
//    });
//   if(_facebookSignIn.isLoggedIn==true){
//     _facebookSignIn.logOut();
//   }
//   firebaseAuthProvider.signOut();
    return  _auth.signOut();
  }

//  Future<FirebaseUser> handleGoogleSignIn() async {
//    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//    googleUser.authHeaders.then((value){
//
//    });
//
//    if (googleUser == null || googleUser.authentication == null) {
//      throw new PlatformException(
//          message: 'Google token is null', code: GOOGLE_TOKEN_NOT_FOUND_CODE);
//    }
//    final GoogleSignInAuthentication googleAuth =
//        await googleUser.authentication;
//
//    if (googleAuth == null ||
//        googleAuth.accessToken == null ||
//        googleAuth.idToken == null) {
//      throw new PlatformException(
//          message: 'Google token is null', code: GOOGLE_TOKEN_NOT_FOUND_CODE);
//    }
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    final AuthResult user = await _auth.signInWithCredential(credential);
//    print("signed in with google as" + user.user.displayName);
//    //repository.getProjects();
//    return user.user;
//  }
//
//  Future<FirebaseUser> handleFacebookSignIn() async {
//    final FacebookLoginResult result =
//        await _facebookSignIn.logIn(['email']);
//    print("Facebook status ${result.status} error msg ${result.errorMessage}, result is result") ;
//
//    if (result.accessToken == null || result.accessToken.token == null) {
//      throw new PlatformException(
//          message: 'Facebook accessToken ${result.accessToken} ${result.accessToken?.token}',
//          code: FACEBOOK_TOKEN_NOT_FOUND_CODE);
//    }
//    final AuthCredential credential = FacebookAuthProvider.getCredential(
//        accessToken: result.accessToken.token);
//
//    var fbUser = await _auth.signInWithCredential(credential);
//    //load avatar uri in normal resolution
//    var updateUser = UserUpdateInfo();
//    updateUser.photoUrl =
//        "https://graph.facebook.com/${result.accessToken.userId}/picture?height=500";
//    await fbUser.user.updateProfile(updateUser);
//    return await getCurrentUser();
//  }

  Future<FirebaseUser> createOrUpdate(String email,String password,String name,String image) async {
    var currUser = await getCurrentUser();
    if (currUser == null) {
      currUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) => currUser = value.user);
    }
    var updateUser = UserUpdateInfo();
    updateUser.displayName = name;
    if(image!=null && image !=''){
      updateUser.photoUrl = image;
    }


    await currUser.updateProfile(updateUser);
    var user= await getCurrentUser();

    return user;
  }


  static Future<bool> checkDocumentExists(String queueId,String docId) async {
    bool exists = false;
    try {
      await Firestore.instance.document(queueId+"/"+docId).get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }



  static Future<void> forgotPasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

/*static Stream<User> getUserFirestore(String userId) {
    print("...getUserFirestore...");
    if (userId != null) {
      //try firestore
      return Firestore.instance
          .collection("users")
          .where("userId", isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return User.fromDocument(doc);
        }).first;
      });
    } else {
      print('firestore user not found');
      return null;
    }
  }*/

/*static Stream<Settings> getSettingsFirestore(String settingsId) {
    print("...getSettingsFirestore...");
    if (settingsId != null) {
      //try firestore
      return Firestore.instance
          .collection("settings")
          .where("settingsId", isEqualTo: settingsId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return Settings.fromDocument(doc);
        }).first;
      });
    } else {
      print('no firestore settings available');
      return null;
    }
  }*/
}

var FACEBOOK_TOKEN_NOT_FOUND_CODE = "facebook_token_not_found";
var GOOGLE_TOKEN_NOT_FOUND_CODE = "google_token_not_found";

var PATH_AVATARS_IMAGE = "avatars/";
