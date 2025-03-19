import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;
  
  User? get currentuser => _auth.currentUser;

  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<String> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await _firestore.collection('users').doc(credential.user!.uid).set(
            ({'username': name, 'email': email, 'uid': credential.user!.uid}));

        return 'Success';
      } else {
        return 'Please fill all the details';
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occcured while signing up';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return 'Success';
      } else {
        return 'Please Enter email and password';
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occured while loggin in';
    } catch (e) {
      return e.toString();
    }
  }
  Future<void>logout()async{

     await _auth.signOut();

  }
}
