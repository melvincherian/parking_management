import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_management/features/presentation/widgets/custom_appbar.dart';

class ParkingSlotCubit extends Cubit<List<bool>> {
  ParkingSlotCubit(int numberOfSlots) : super(List.generate(numberOfSlots, (index) => true));

  void toggleSlot(int index) {
    final updatedSlots = List<bool>.from(state);
    updatedSlots[index] = !updatedSlots[index];
    emit(updatedSlots);
  }
}

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final int numberOfSlots = 20;
    return BlocProvider(
      create: (context) => ParkingSlotCubit(numberOfSlots),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Home'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ParkingSlotCubit, List<bool>>(
            builder: (context, slots) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: numberOfSlots,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => context.read<ParkingSlotCubit>().toggleSlot(index),
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

  const ParkingSlotWidget({required this.slotNumber, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isAvailable ? Colors.black : Colors.yellow,
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
          // const Icon(
          //   Icons.local_parking,
          //   color: Colors.white,
          //   size: 36,
          // ),
          const SizedBox(height: 10),
          Text(
            'Slot $slotNumber',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
