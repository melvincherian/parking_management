// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_management/features/presentation/widgets/custom_appbar.dart';
import 'package:parking_management/firebase/services.dart';

class ParkingSlotCubit extends Cubit<List<bool>> {
  final FirebaseService _firebaseService;
  final Map<int, DateTime> _entryTimeMap = {};

  ParkingSlotCubit(this._firebaseService) : super([]) {
    _fetchParkingSlots();
  }

  void _fetchParkingSlots() async {
    _firebaseService.getParkingSlotsStream().listen((slotsData) {
      emit(slotsData);
    });
  }

  void reserveSlot(int index) async {
    if (state[index]) {
      DateTime entryTime = DateTime.now();
      _entryTimeMap[index] = entryTime; 
      await _firebaseService.reserveSlot(index + 1, entryTime);
      emit(List.from(state)..[index] = false);
    }
  }

  Future<double> calculateFee(int index) async {
    DateTime exitTime = DateTime.now();
    DateTime entryTime = _entryTimeMap[index] ?? exitTime;

    Duration duration = exitTime.difference(entryTime);
    int minutes = duration.inMinutes;

    if (minutes <= 10) {
      return 0.0; // Free
    } else {
      int hours = (minutes / 60).ceil(); // Round up to the nearest hour
      return hours * 100;
    }
  }

  void releaseSlot(int index) async {
    if (!state[index]) {
      double fee = await calculateFee(index);
      await _firebaseService.releaseSlot(index + 1);
      _entryTimeMap.remove(index); // Remove entry time after release
      emit(List.from(state)..[index] = true);

      // Show fee dialog
      emitFeeDialog(fee);
    }
  }

  void emitFeeDialog(double fee) {

  }

  
  }


class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParkingSlotCubit(FirebaseService()),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Parking Slots'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ParkingSlotCubit, List<bool>>(
            builder: (context, slots) {
              if (slots.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final cubit = context.read<ParkingSlotCubit>();
                      if (slots[index]) {
                        _showReservationDialog(context, cubit, index);
                      } else {
                        _showReleaseDialogBox(context, cubit, index);
                      }
                    },
                    child: ParkingSlotCard(
                      slotNumber: index + 1,
                      isAvailable: slots[index],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showReleaseDialogBox(BuildContext context, ParkingSlotCubit cubit, int index) async {
  double fee = await cubit.calculateFee(index);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Release Slot", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Do you want to release Slot ${index + 1}?", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            fee == 0 ? "Parking is Free (Less than 10 min)" : "Parking Fee: \$$fee",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            cubit.releaseSlot(index);
            Navigator.pop(context);
          },
          child: const Text("Release"),
        ),
      ],
    ),
  );
}


  void _showReservationDialog(
      BuildContext context, ParkingSlotCubit cubit, int index) {
    DateTime entryTime = DateTime.now();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Reservation",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Slot: ${index + 1}", style: const TextStyle(fontSize: 16)),
            Text("Entry Time: ${entryTime.toLocal()}",
                style: const TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              cubit.reserveSlot(index);
              Navigator.pop(context);
            },
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );




  }


  

  void _showReleaseDialogb(
      BuildContext context, ParkingSlotCubit cubit, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Release Slot",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Do you want to release Slot ${index + 1}?",
            style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.releaseSlot(index);
              Navigator.pop(context);
            },
            child: const Text("Release"),
          ),
        ],
      ),
    );
  }
}

class ParkingSlotCard extends StatelessWidget {
  final int slotNumber;
  final bool isAvailable;

  const ParkingSlotCard(
      {required this.slotNumber, required this.isAvailable, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green[600] : Colors.red[600],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
        border: Border.all(color: Colors.black54, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAvailable ? Icons.directions_car_filled_outlined : Icons.lock,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            'Slot $slotNumber',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isAvailable ? 'Available' : 'Booked',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
