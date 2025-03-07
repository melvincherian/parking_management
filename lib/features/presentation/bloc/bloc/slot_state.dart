part of 'slot_bloc.dart';

@immutable
sealed class SlotState {}

final class SlotInitial extends SlotState {}


class Parkingstate {
  final Map<int,bool>slots;

  Parkingstate({required this.slots});

   Parkingstate copyWith({Map<int, bool>? slots}) {
    return Parkingstate(slots: slots ?? this.slots);
  }
}