// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_management/features/presentation/widgets/custom_appbar.dart';
import 'package:parking_management/firebase/services.dart';

class ParkingSlotCubit extends Cubit<List<bool>> {
  final FirebaseService _firebaseService;
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
    await _firebaseService.reserveSlot(index + 1, entryTime);
    emit(List.from(state)..[index] = false);
  }
}




}


class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParkingSlotCubit(FirebaseService()),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Home'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ParkingSlotCubit, List<bool>>(
            builder: (context, slots) {
              if (slots.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
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
    DateTime entryTime = DateTime.now();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Reservation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Slot: ${index + 1}"),
            Text("Entry Time: ${entryTime.toLocal()}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              cubit.reserveSlot(index);
              Navigator.pop(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text("Slot ${index + 1} is already booked")),
    );
  }
},

                    child: ParkingSlotWidget(
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
}

class ParkingSlotWidget extends StatelessWidget {
  final int slotNumber;
  final bool isAvailable;

  const ParkingSlotWidget(
      {required this.slotNumber, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isAvailable
            ? Colors.black
            : Colors.red,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
        border: Border.all(color: Colors.black54, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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