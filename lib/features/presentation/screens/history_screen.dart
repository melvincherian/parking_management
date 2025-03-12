// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:parking_management/features/presentation/widgets/custom_appbar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: 'Reservation Details'),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('parkingSlots').where('isBooked', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Reservations"));
          }
          final reservations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final data = reservations[index].data();
              final slotNumber = reservations[index].id; 
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate(); 
              final formattedDate = timestamp != null 
                  ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp) 
                  : 'Unknown';

              return ListTile(
                title: Text("Slot Number: $slotNumber"),
                subtitle: Text("Entry Time: $formattedDate"),
                trailing: const Icon(Icons.check, color: Colors.green),
              );
            },
          );
        },
      ),
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('users')
      //       .doc('user_id')
      //       .collection('parking_history')
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) return const CircularProgressIndicator();
      //     final history = snapshot.data!.docs;
      //     return ListView.builder(
      //       itemCount: history.length,
      //       itemBuilder: (context, index) {
      //         final data = history[index].data();
      //         return ListTile(
      //           title: Text("Slot ${data['slotId']}"),
      //           subtitle: Text(
      //               "Entry: ${data['entryTime']}\nExit: ${data['exitTime']}"),
      //           trailing: Text("\$${data['fee']}"),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
      // body: StreamBuilder(
      //   stream: FirebaseFirestore.instance.collection('parkingSlots').where('isBooked', isEqualTo: true).snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return const Center(child: Text("No Reservations"));
      //     }
      //     final reservations = snapshot.data!.docs;
      //     return ListView.builder(
      //       itemCount: reservations.length,
      //       itemBuilder: (context, index) {
      //         final data = reservations[index].data();
      //         final slotNumber = reservations[index].id; 
      //         final timestamp = (data['timestamp'] as Timestamp?)?.toDate(); 
      //         final formattedDate = timestamp != null 
      //             ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp) 
      //             : 'Unknown';

      //         return ListTile(
      //           title: Text("Slot Number: $slotNumber"),
      //           subtitle: Text("Entry Time: $formattedDate"),
      //           trailing: const Icon(Icons.check, color: Colors.green),
      //         );
      //       },
      //     );
      //   },
      // ),
    
  }
}
