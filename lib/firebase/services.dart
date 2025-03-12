import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Stream<List<bool>> getParkingSlotsStream() {
  return _firestore.collection('parkingSlots').snapshots().map((snapshot) {
    return List.generate(20, (index) {
      final doc = snapshot.docs.where((doc) => doc.id == '${index + 1}').firstOrNull;
      return doc != null ? !(doc['isBooked'] ?? false) : true;
    });
  });
}


  Future<void> reserveSlot(int slotNumber, DateTime timestamp) async {
    await _firestore.collection('parkingSlots').doc('$slotNumber').set({
      'isBooked': true,
      'timestamp': timestamp,
    }, SetOptions(merge: true));
  }
}



