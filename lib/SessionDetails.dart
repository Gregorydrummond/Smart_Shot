import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'StatCard.dart';
import 'session.dart';

class SessionDetails extends StatelessWidget {
  Session session;
  SessionDetails(this.session, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Session Details'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: StatCard(title: "Shot Percent", type: "percent", value: session.getShotPercentage)),
              Expanded(child: StatCard(title: "Duration", type: "time", value: session.getSessionDuration)),
            ],
          ),
          Row(
            children: [
              Expanded(child: StatCard(title: "Swishes", type: "count", value: session.getSwishShots.toDouble())),
              Expanded(child: StatCard(title: "Shots Made", type: "count", value: session.getTotalMakes.toDouble())),
            ],
          ),
          Row(
            children: [
              Expanded(child: StatCard(title: "Total Shots", type: "count", value: session.getTotalShots.toDouble())),
              Expanded(child: StatCard(title: "Total Misses", type: "count", value: session.getTotalMisses.toDouble())),
            ],
          ),
        ],
      ),
    );
  }
}