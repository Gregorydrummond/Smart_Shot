import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatCard extends StatelessWidget {
  final String type;
  final String title;
  final double value;

  const StatCard({required this.type, required this.title, required this.value, super.key});

  Widget buildCard() {
    if (type == "time") {
      int min = value.toInt();
      int sec = ((value - min) * 60).round();
      return Card(
        color: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 3,
        margin: EdgeInsets.all(10.0),
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("$min" + "m " + "$sec" + "s", style: TextStyle( fontSize: 35.0),),
              Text(title, style: TextStyle(fontSize: 22.0),)
            ],
          ),
        ),
      );
    }
    else if (type == "percent") {
      String per = (value * 100).toStringAsFixed(2);
      return Card(
        color: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 3,
        margin: EdgeInsets.all(10.0),
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(per + "%", style: TextStyle( fontSize: 35.0),),
              Text(title, style: TextStyle(fontSize: 22.0),)
            ],
          ),
        ),
      );
    }
    else if (type == "count") {
      return Card(
        color: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 3,
        margin: EdgeInsets.all(10.0),
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(value.toInt().toString(), style: TextStyle( fontSize: 35.0),),
              Text(title, style: TextStyle(fontSize: 22.0),)
            ],
          ),
        ),
      );
    }
    else {
      return Card(
        color: Colors.orangeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        elevation: 3,
        margin: EdgeInsets.all(10.0),
        child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(value.toStringAsFixed(2), style: TextStyle( fontSize: 35.0),),
              Text(title, style: TextStyle(fontSize: 22.0),)
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildCard();
  }
}