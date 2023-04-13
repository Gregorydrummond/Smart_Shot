import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'StatCard.dart';
import 'session.dart';

class SessionDetails extends StatelessWidget {
  Session session;
  SessionDetails(this.session, {super.key});

  Widget buildPiChart(){
    List<ChartData> chartdata = [
      ChartData("Shots Made", session.getTotalMakes,Color(0xff6ee810) ),
      ChartData('Missed Shots', session.getTotalMisses, Color(0xffe81010))
    ];
    return  SafeArea(
      child: Column(
        children: [
          SfCircularChart(
            legend: Legend(
              isVisible: true,
              toggleSeriesVisibility: false,
              borderColor: Colors.black,
              borderWidth: 2,
            ),
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: chartdata,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                innerRadius: "60%",
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
              ),
            ],
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                height: '100%',
                width: '100%',
                widget: Container(
                  child: PhysicalModel(
                    child: Container(),
                    shape: BoxShape.circle,
                    elevation: 10,
                    shadowColor: Colors.black,
                    color: Colors.white,
                  ),
                ),
              ),
              CircularChartAnnotation(
                widget: Container(
                  child: Text(
                    '${(session.getShotPercentage* 100).toStringAsFixed(2)}%',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Session Details', style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          buildPiChart(),
          Row(
            children: [
            
              Expanded(child: StatCard(title: "Duration", type: "time", value: session.getSessionDuration)),
            ],
          ),
          Row(
            children: [
              Expanded(child: StatCard(title: "Swishes", type: "count", value: session.getSwishShots.toDouble())),
              Expanded(child: StatCard(title: "Airballs", type: "count", value: session.getAirballShots.toDouble())),
             
              
            ],
          ),
          Row(
            children: [
              Expanded(child: StatCard(title: "Total Shots", type: "count", value: session.getTotalShots.toDouble())),
              Expanded( child: StatCard(value: session.getHotStreak.toDouble(), title: "Longest Streak", type: "count"),
               ) ,
            
            ],
          )
          
        ],
      ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final int y;
  final Color? color;
}