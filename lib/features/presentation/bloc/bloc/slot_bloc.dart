// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'slot_event.dart';
part 'slot_state.dart';

// class SlotBloc extends Bloc<SlotEvent, SlotState> {
//   SlotBloc() : super(SlotInitial()) {
//     on<SlotEvent>((event, emit) {
     
//     });
//   }
// }







class ParkingSlotCubit extends Cubit<List<Map<String, dynamic>>> {
  ParkingSlotCubit() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchSlots() {
    _firestore.collection('slots').snapshots().listen((snapshot) {
      emit(snapshot.docs.map((doc) => doc.data()).toList());
    });
  }

  void toggleSlot(int index, bool isAvailable, String slotId, DateTime entryTime) async {
    if (isAvailable) {
      await _firestore.collection('slots').doc(slotId).update({
        'isAvailable': false,
        'entryTime': entryTime.toIso8601String(),
      });
    } else {
      DateTime exitTime = DateTime.now();
      Duration timeSpent = exitTime.difference(entryTime);
      int fee = calculateFee(timeSpent);

      await _firestore.collection('slots').doc(slotId).update({
        'isAvailable': true,
        'exitTime': exitTime.toIso8601String(),
        'fee': fee,
      });
    }
  }

  int calculateFee(Duration timeSpent) {
    if (timeSpent.inMinutes <= 10) {
      return 0;
    }
    return (timeSpent.inHours + 1) * 100;
  }
}

