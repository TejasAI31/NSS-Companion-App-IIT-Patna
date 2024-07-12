import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:nss_project/sprofile_page.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SHomePage(),
    );
  }
}

class SHomePage extends StatefulWidget {
  const SHomePage({super.key});

  @override
  SHomePageState createState() => SHomePageState();
}

class SHomePageState extends State<SHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _sem1Hours = 40;
  int _sem2Hours = 20;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setSem1Hours(int hours) {
    setState(() {
      _sem1Hours = hours;
    });
  }

  int getSem1Hours() {
    return _sem1Hours;
  }

  void setSem2Hours(int hours) {
    setState(() {
      _sem2Hours = hours;
    });
  }

  int getSem2Hours() {
    return _sem2Hours;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const ProfilePage()));
            },
          ),

          IconButton(onPressed: (){FirebaseAuth.instance.signOut();}, icon:const Icon(Icons.exit_to_app)),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Hours Completed'),
            Tab(text: 'Upcoming Events'),
            Tab(text: 'Attended Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HoursCompletedTab(
            sem1Hours: _sem1Hours,
            sem2Hours: _sem2Hours,
          ),
          const UpcomingEventsTab(),
          const AttendedEventsTab(),
        ],
      ),
    );
  }
}



class HoursCompletedTab extends StatefulWidget
{
  final int sem1Hours;
  final int sem2Hours;

  const HoursCompletedTab({super.key, 
    required this.sem1Hours,
    required this.sem2Hours,});

  @override
    // ignore: no_logic_in_create_state
    State createState()=>HoursCompletedState(sem1Hours: sem1Hours,sem2Hours: sem2Hours);
}


class HoursCompletedState extends State {
  final int sem1Hours;
  final int sem2Hours;


  HoursCompletedState({ 
    required this.sem1Hours,
    required this.sem2Hours,
  });

  @override
  Widget build(BuildContext context) {

    double screenwidth=MediaQuery.sizeOf(context).width;
    double screenheight=MediaQuery.sizeOf(context).height;


    return Scaffold( 
      resizeToAvoidBottomInset: true,
      body:Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your Progress So Far',
              textScaler: TextScaler.linear(2),
            ),
                SizedBox(
                  width: screenwidth-50,
                  height:screenheight/2,
                  child: SfRadialGauge(
                  enableLoadingAnimation: true,
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 80,
                      showLabels: false,
                      showTicks: false,
                      axisLineStyle: const AxisLineStyle(
                        thickness: 0.2,
                        cornerStyle: CornerStyle.bothCurve,
                        color: Color.fromARGB(30, 0, 169, 181),
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: (sem1Hours + sem2Hours).toDouble(),
                          cornerStyle: CornerStyle.bothCurve,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          positionFactor: 0,
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (sem1Hours + sem2Hours).toStringAsFixed(0),
                                    style: TextStyle(fontSize: 40,color:(sem1Hours+sem2Hours<80)?Colors.red:Colors.green),
                                  ),
                                  
                                  const Text(
                                    "/80",
                                    style: TextStyle(fontSize: 40,color:Colors.green),
                                  )
                                ],
                              ),

                              const Text(
                                "Hours Completed",
                                style: TextStyle(fontSize: 15,color:Colors.green),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                                ),
                ),

                SizedBox(
                  width:screenwidth/2,
                  child: TextButton(
                    onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>HourDetailPage(sem1Hours: sem1Hours,sem2Hours: sem2Hours,)));
                    },
                    style:const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 127, 112, 180))
                    ),
                    child: const Text("Details",style:TextStyle(color:Colors.white)),
                    ),
                )

            /*Row(
              children: <Widget>[
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 30,
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.5,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: sem1Hours.toDouble(),
                            cornerStyle: CornerStyle.bothCurve,
                            width: 0.2,
                            sizeUnit: GaugeSizeUnit.factor,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            positionFactor: 0,
                            widget: Text(
                              '${sem1Hours.toStringAsFixed(0)} Hours\n(Sem 1)',
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                                  ]),


                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 30,
                        showLabels: false,
                        showTicks: false,
                        radiusFactor: 0.5,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: sem2Hours.toDouble(),
                            cornerStyle: CornerStyle.bothCurve,
                            width: 0.2,
                            sizeUnit: GaugeSizeUnit.factor,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            positionFactor: 0,
                            widget: Text(
                              '${sem2Hours.toStringAsFixed(0)} Hours\n(Sem 2)',
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                                  ]),
              ],
            ),*/
          ],
      ),
    )
    );
  }
}


class HourDetailPage extends StatefulWidget
{
  final int sem1Hours;
  final int sem2Hours;
  const HourDetailPage({super.key,required this.sem1Hours,required this.sem2Hours});

  @override
  State createState()
  {
    // ignore: no_logic_in_create_state
    return HourDetailState(sem1Hours,sem2Hours);
  }
}

class HourDetailState extends State with SingleTickerProviderStateMixin
{
  final int sem1Hours;
  final int sem2Hours;


  HourDetailState(this.sem1Hours,this.sem2Hours);


  @override
  Widget build(BuildContext context)
  {

    final screenwidth=MediaQuery.sizeOf(context).width;
    final screenheight=MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar:AppBar(
        title: const Text("Semester Details",style: TextStyle(color:Colors.white),),
        backgroundColor: const Color.fromARGB(255, 127, 112, 180),
        foregroundColor:  Colors.white,
      ),

      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, screenheight/10),
              child: Stack(
                children:[ Center(
                  child: SizedBox(
                    width:screenwidth/2,
                    height:screenwidth/2,
                    child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: sem1Hours/40),
                            duration: const Duration(seconds: 2),
                            builder: (context, value, _) => CircularProgressIndicator(strokeCap: StrokeCap.round,
                            strokeWidth: 10,
                            backgroundColor: (sem1Hours<40)?Colors.red:Colors.white,
                           color: (sem1Hours<40)?Colors.green:Colors.blue,
                            value:value),),
                  ),
                ),

                

                Center(child: Padding(
                  padding: EdgeInsets.fromLTRB(0, screenwidth/5, 0, 0),
                  child: Text("Semester 1:\n     $sem1Hours/40",style: const TextStyle(fontSize: 20),),
                ))
              ]
              ),
            ),

            const Divider(color: Color.fromARGB(255, 127, 112, 180),thickness: 4,),

            Padding(
              padding: EdgeInsets.fromLTRB(0, screenheight/10, 0, 0),
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                    width:screenwidth/2,
                    height:screenwidth/2,
                    child: 
                    TweenAnimationBuilder<double>(
                      tween:Tween(begin:0,end:sem2Hours/40),
                      duration: const Duration(seconds: 2),
                      builder:(context,value, _)=>CircularProgressIndicator(
                        
                        strokeCap: StrokeCap.round,
                        strokeWidth: 10,
                        backgroundColor: Colors.red,
                        color: Colors.green,
                        value: value,
                      ),
                    ),
                   ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(0, screenwidth/5, 0, 0),
                    child: Center(child: Text("Semester 2:\n     $sem2Hours/40",style:const TextStyle(fontSize:20 ))),
                  )
              ]
              ),
            )
          ]
          )
        )
      );
  }
}

class UpcomingEventsTab extends StatelessWidget {
  const UpcomingEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Upcoming Events Content'),
    );
  }
}

class AttendedEventsTab extends StatelessWidget {
  const AttendedEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Attended Events Content'),
    );
  }
}
