import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_connect/models/client_account.dart';
import 'package:coach_connect/models/coach_account.dart';
import 'package:coach_connect/mvvm/viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends EventViewModel {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String returnMessage = "";

  Future<String?> login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          
          email: usernameController.text, password: passwordController.text);
          final id = credential.user!.uid;
      debugPrint("Signed in");
      return id;
    } on FirebaseAuthException catch (e) {
      String? error = e.message;
      returnMessage = 'Login failed. $error';
    }
    return null;
  }
}


Future <ClientAccountModel?> getClient({required String id}) async{
  try {
  final client = await FirebaseFirestore.instance.collection('clients').doc(id.toString()).get();
  if (client.exists) {
    final data = client.data() as Map <String, dynamic>;
  if (data != null) {
    final clientModel = ClientAccountModel(data["id"], data["name"], data["email"], data["age"], data["accountType"], data["coach"], (data["workouts"] as Iterable<dynamic>).map((e) => e.toString()).toList());
    return clientModel;
  }
  else {debugPrint("failed to sign in");}
  return null;
  }
  
  
} on Exception catch (e) {
  // TODO
}
  return null;
}

Future <List<CoachAccountModel>?> getCoaches() async{
  try {
    final coachData = await FirebaseFirestore.instance.collection('coaches').get();
    final coachList = <CoachAccountModel>[];
    for (final doc in coachData.docs) {
      final coaches = CoachAccountModel.fromJson(doc.data());
      coachList.add(coaches);
      
    }
    return coachList;
  } on Exception catch (e) {
  // TODO
}
  return [];
}

Future<void> setCoach(String clientId, String coachSet) async {

      try {
        await FirebaseFirestore.instance.collection('clients').doc(clientId).update({"coach": coachSet});
      } on Exception catch (e) {
  // TODO
  } 
  }
