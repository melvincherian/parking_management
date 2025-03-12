// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:parking_management/features/data/model/slot_model.dart';
part 'slot_event.dart';
part 'slot_state.dart';

class SlotBloc extends Bloc<SlotEvent, SlotState> {
  List<ParkingSlot> slots = List.generate(21, (index) => ParkingSlot(id: index));

  SlotBloc() : super(ParkLoading()) {
    on<LoadSlots>((event, emit) => emit(ParkLoaded(slots)));

    on<ToggleslotStatus>((event, emit) {
      slots = slots.map((slot) {
        if (slot.id == event.slotId && !slot.isOccupied) {
          return slot.copyWith(isOccupied: true, entryTime: DateTime.now());
        }
        return slot;
      }).toList();
      emit(ParkLoaded(slots));
    });

    on<ReleaseSlot>((event, emit) {
      slots = slots.map((slot) {
        if (slot.id == event.slotId && slot.isOccupied) {
          final duration = DateTime.now().difference(slot.entryTime!);
          final fee = calculateParkingFee(duration);

          print('Parking Fee: ₹$fee');

          return slot.copyWith(isOccupied: false, entryTime: null);
        }
        return slot;
      }).toList();
      emit(ParkLoaded(slots));
    });
  }

  double calculateParkingFee(Duration duration) {
    double ratePerHour = 20.0;
    return (duration.inMinutes / 60) * ratePerHour;
  }
}








// class ParkingSlotCubit extends Cubit<List<Map<String, dynamic>>> {
//   ParkingSlotCubit() : super([]);

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   void fetchSlots() {
//     _firestore.collection('slots').snapshots().listen((snapshot) {
//       emit(snapshot.docs.map((doc) => doc.data()).toList());
//     });
//   }

//   void toggleSlot(int index, bool isAvailable, String slotId, DateTime entryTime) async {
//     if (isAvailable) {
//       await _firestore.collection('slots').doc(slotId).update({
//         'isAvailable': false,
//         'entryTime': entryTime.toIso8601String(),
//       });
//     } else {
//       DateTime exitTime = DateTime.now();
//       Duration timeSpent = exitTime.difference(entryTime);
//       int fee = calculateFee(timeSpent);

//       await _firestore.collection('slots').doc(slotId).update({
//         'isAvailable': true,
//         'exitTime': exitTime.toIso8601String(),
//         'fee': fee,
//       });
//     }
//   }

//   int calculateFee(Duration timeSpent) {
//     if (timeSpent.inMinutes <= 10) {
//       return 0;
//     }
//     return (timeSpent.inHours + 1) * 100;
//   }
// }

