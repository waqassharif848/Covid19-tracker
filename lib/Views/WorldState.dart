import 'package:covid19_tracker/Views/countries_list.dart';
import 'package:covid19_tracker/WorldStatesModel.dart';
import 'package:covid19_tracker/Services/states_services.dart';
import 'package:flutter/material.dart';
import "package:pie_chart/pie_chart.dart" show ChartType, ChartValuesOptions, LegendOptions, LegendPosition, PieChart;
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitFadingCircle;

class WorldState extends StatefulWidget {
  const WorldState({Key? key}) : super(key: key);

  @override
  State<WorldState> createState() => _WorldStateState();
}

class _WorldStateState extends State<WorldState> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices= StatesServices();

    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01),
              FutureBuilder(
                  future: statesServices.fetchWorldStatesRecords(),
                  builder: (context,AsyncSnapshot<WorldStatesModel> snapshot){

                if(!snapshot.hasData){
                  return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _controller,

                      ),
                  );
                }
                else {
                  return Column(
                    children: [
                      PieChart  (
                        dataMap: {
                          "Total":double.parse(snapshot.data!.cases!.toString()),
                          "Recovered":double.parse(snapshot.data!.recovered.toString()),
                          "Deaths":double.parse(snapshot.data!.deaths.toString()),
                        },
                        chartValuesOptions:  const ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        chartRadius: MediaQuery.of(context).size.width/2.2,
                        legendOptions:const LegendOptions(
                          legendPosition: LegendPosition.left,
                        ),
                        animationDuration: Duration(milliseconds: 1279),
                        chartType: ChartType.ring,
                        colorList: colorList,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * -1.06),
                        child: Card(
                          color: Colors.black12,
                          child:Column(
                            children: [
                              ReuseableRow(title: 'Total Cases', value: snapshot.data!.cases.toString()),
                              ReuseableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                              ReuseableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                              ReuseableRow(title: 'Active', value: snapshot.data!.active.toString()),
                              ReuseableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                              ReuseableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths.toString()),
                              ReuseableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString()),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CountriesList() ));
                        },
                        child: Container(
                          height: 49,
                          decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              borderRadius: BorderRadius.circular(9)
                          ),
                          child: Center(child: Text("Tracking Countries", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)),
                        ),
                      ),
                    ],
                  );
                }


                  }),


            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  String title,value;
  ReuseableRow({key, required this.title, required this.value}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title ,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
              Text(value, style: TextStyle(fontSize: 15),),
            ],
          ),

          SizedBox(height: 5,),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(height: 5,),
        ],
      ),
    );
  }
}
