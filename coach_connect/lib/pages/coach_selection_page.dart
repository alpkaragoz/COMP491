import 'package:coach_connect/models/client_account.dart';
import 'package:coach_connect/models/coach_account.dart';
import 'package:coach_connect/pages/client_home_page.dart';
import 'package:coach_connect/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';

class CoachSelection extends StatelessWidget {
  const CoachSelection({super.key, required this.coachList, required this.coachId});
  final List<CoachAccountModel> coachList;
  final String coachId;
  //final List<CoachAccountModel> coachList;
  //final String coachId;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coach List'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2.0, // Adjust this value as needed
        ),
      itemCount: coachList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap:() async{
              await setCoach(coachId, coachList[index].name);
              //await setClient(clientId, clientList.add());
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientHomePage()));
            },
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text(coachList[index].name),
              ),
              ),
          ),
        );
        },
      ),
    );
  }
}