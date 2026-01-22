import 'package:flutter/material.dart';

class AssignmentManager extends StatefulWidget {
  const AssignmentManager({super.key});

  @override
  State<AssignmentManager> createState() => _AssignmentManagerState();
}

class _AssignmentManagerState extends State<AssignmentManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Assignment",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  color: Colors.transparent,
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "0",
                          style: TextStyle(fontSize: 56, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ), //TODO: add pending task number
                        SizedBox(height: 28),
                        Text("pending Task",
                        style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  alignment: Alignment.topLeft,
                  color: Colors.transparent,
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "0",
                          style: TextStyle(fontSize: 56, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 28),
                        Text("completed Task",
                        style: TextStyle(color: Colors.grey),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
