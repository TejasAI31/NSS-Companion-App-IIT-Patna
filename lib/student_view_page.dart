import 'package:flutter/material.dart';

import 'package:nss_project/sprofile_page.dart';
import 'package:nss_project/secretary_wing_changepage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:io';

class StudentViewPage extends StatefulWidget {
  const StudentViewPage({super.key,required this.person});
  final QueryDocumentSnapshot<Map<String, dynamic>> person;
  @override
  State<StudentViewPage> createState() => _StudentViewPageState();
}

class _StudentViewPageState extends State<StudentViewPage> {
  String rolechange = 'volunteer';

  int sem1buffer=0;
  int sem2buffer=0;

Future updateHours(int hours) async
{
  late final String semstatus;
  await FirebaseFirestore.instance.collection('configurables').doc('document').get().then((snapshot){if(snapshot['current-semester']==1){semstatus="sem-1-hours";}else{semstatus="sem-2-hours";} });
  await FirebaseFirestore.instance.collection('users').doc(widget.person.id).update({semstatus:FieldValue.increment(hours)});

  setState(() {
  Navigator.pop(context);
  if(semstatus=="sem-1-hours")
  {sem1buffer+=hours;}
  else
  {
    sem2buffer+=hours;
  }
  });
}

Future openAddDialog()
{
  TextEditingController searchcontroller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Hours"),
            content: SearchBar(
              keyboardType: TextInputType.number,
              controller: searchcontroller,
            ),
            actions: [
              FloatingActionButton(
                  child: const Text("Submit"),
                  onPressed: () async {

                    updateHours(int.parse(searchcontroller.text));
                  })
            ],
          );
        });
}

Future openRemoveDialog()
{
  TextEditingController searchcontroller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Hours"),
            content: SearchBar(
              keyboardType: TextInputType.number,
              controller: searchcontroller,
            ),
            actions: [
              FloatingActionButton(
                  child: const Text("Submit"),
                  onPressed: () async {

                    updateHours(-int.parse(searchcontroller.text));
                  })
            ],
          );
        });
}

  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Student View'), 
      ),
      body: Container(
        color: Colors.transparent,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('configurables').doc('document').snapshots(),
          builder: (context, snapshot) {

            if(!snapshot.hasData)
            {return const CircularProgressIndicator();}

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top:15.0),
                  child: Container(
                    width:width/3,
                    height:width/3,
                    child: ClipRRect(
                            borderRadius: BorderRadius.circular(width),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              'assets/images/defaultprofilepic.jpg',
                            )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:30.0),
                  child: Center(
                    child: SizedBox(
                      width: width/1.1,
                      child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        height: 1.3,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: getCapitalizedName(widget.person['full-name'] + '\n'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700, fontSize: 26)),
                                        TextSpan(
                                          text: '${widget.person['roll-number']}\n',
                                        ),
                                        TextSpan(text: '${widget.person['email']}'),
                                      ]),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                    const SizedBox(
                      height: 50,
                    ),
                (widget.person['role'] == 'volunteer') ? 
                Container(
                  child: Column(
                    children: [
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  height: 0.7,
                                  fontStyle: FontStyle.normal),
                              children: [
                                const TextSpan(
                              text: 'Sem 1: ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 59, 129, 2)),
                            ),
                      
                            TextSpan(
                              text: '${widget.person['sem-1-hours']+sem1buffer}',
                              style: TextStyle(
                                  color:(widget.person['sem-1-hours']<(snapshot.data!['mandatory-hours'])/2)? Colors.red:Colors.green),
                            ),
                            const TextSpan(text: '/', style: TextStyle(fontSize: 33.0)),
                            TextSpan(
                                text: '${(snapshot.data!['mandatory-hours'])/2}',
                                style: const TextStyle(color: Colors.blue)),
                          ])),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0,end: 1),
                            duration: const Duration(seconds: 1),
                            builder: (context, value, child) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(width/8,5,width/8,0),
                                child: LinearProgressIndicator(borderRadius: BorderRadius.circular(20),minHeight: 10, backgroundColor: Colors.blue,color: Colors.green,value:(widget.person['sem-1-hours']/snapshot.data!['mandatory-hours'])*value),
                              );
                            },
                            ),
                            
                            
                    ],
                  ),

                ) : const SizedBox(height: 20,),
                SizedBox(
                  height: height / 8,
                ),
                (widget.person['role'] == 'volunteer') ? Container(
                  child: Column(
                    children: [
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  height: 0.7,
                                  fontStyle: FontStyle.normal),
                              children: [
                                const TextSpan(
                              text: 'Sem 2: ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 59, 129, 2)),
                            ),
                      
                            TextSpan(
                              text: '${widget.person['sem-2-hours']+sem2buffer}',
                              style: TextStyle(
                                  color:(widget.person['sem-2-hours']<(snapshot.data!['mandatory-hours'])/2)? Colors.red:Colors.green),
                            ),
                            const TextSpan(text: '/', style: TextStyle(fontSize: 33.0)),
                            TextSpan(
                                text: '${(snapshot.data!['mandatory-hours'])/2}',
                                style: const TextStyle(color: Colors.blue)),
                          ])),
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0,end: 1),
                            duration: const Duration(seconds: 1),
                            builder: (context, value, child) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(width/8,5,width/8,0),
                                child: LinearProgressIndicator(borderRadius: BorderRadius.circular(20),minHeight: 10, backgroundColor: Colors.blue,color: Colors.green,value:(widget.person['sem-2-hours']/snapshot.data!['mandatory-hours'])*value),
                              );
                            },
                            ),
                            
                            
                    ],
                  ),

                ) : const SizedBox(height: 20,),

                    (widget.person['role']=='volunteer')?
                    Padding(
                      padding: const EdgeInsets.only(top:30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        InkWell(
                          onTap: (){openAddDialog();},

                          child: Card.filled(
                          color: Colors.green,
                          child: SizedBox(
                            width:width/2-20,
                            height: 50,
                            child: const Center(child: Text("Add Hours",style: TextStyle(fontSize: 20,color: Colors.white),))
                            ),
                          ),
                        ),


                         InkWell
                         (
                          onTap: (){openRemoveDialog();},
                           child: Card.filled(color: Colors.red,
                           child: SizedBox(
                            width:width/2-20,
                            height: 50,
                            child: const Center(child: Text("Remove Hours",style: TextStyle(fontSize: 20,color: Colors.white),))
                            ),
                                                   ),
                         )
                      ],),
                    ):Container(),
                
                    Padding(
                      padding: EdgeInsets.only(top:25),
                      child: SizedBox(
                        width: width-10,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('roles').snapshots(),
                          builder:(context,snaphot){
                            List<String> roles = ['secretary','mentor','volunteer'];
                      
                            // ignore: non_constant_identifier_names
                            List<DropdownMenuEntry<String>> RoleEntries =
                              roles.map((option) => DropdownMenuEntry<String>(
                                  value: option, label: option)).toList();
                            return DropdownMenu<String>(
                              initialSelection: 'volunteer',
                              requestFocusOnTap: false,
                              expandedInsets: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              textStyle: const TextStyle(color: Colors.white),
                              inputDecorationTheme: const InputDecorationTheme(
                              fillColor: Color.fromARGB(255, 120, 88, 174),
                              filled: true,
                              ),
                              label: const Text('Role',style: TextStyle(color: Colors.white),),
                              onSelected: (String? role){setState(() {
                                if(role != null){
                                  rolechange = role;
                                }
                              });},
                              dropdownMenuEntries: RoleEntries,
                            );
                          }),
                      ),
                    ),
                      SizedBox(
                        width: width-20,
                        child: Card.outlined(
                          clipBehavior: Clip.hardEdge,
                          child: ListTile(
                            tileColor: const Color.fromARGB(255, 8, 21, 125),
                            title: const Center (child: Text('Change Role',style: TextStyle(color: Colors.white),)),
                            onTap: () {
                              setState(() async {
                                if(rolechange  == 'volunteer' || rolechange == 'mentor'){
                                  await FirebaseFirestore.instance.collection('users').doc(widget.person.id).update({"role": rolechange}).then(
                                  (value) => print("DocumentSnapshot successfully updated!"),
                                  onError: (e) => print("Error updating document $e"));
                                }
                                if(rolechange == 'secretary'){
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => SecretaryWingChangepage(id: widget.person.id,)));
                                }

                              });
                            },
                          ),
                        ),
                      )
              ],
            );
          }
        ),
      ),
    );
  }
}


String getCapitalizedName(String name){
  String ret = '';
  bool doCap = true;
    for(int i = 0;i<name.length;i++){
      if(doCap){
        ret = ret + name[i].toUpperCase();
        doCap = false;
      }
      else{
        ret = ret + name[i];
        if(name[i] == ' '){
        doCap = true;
        }
      }
    }
  return ret;
}