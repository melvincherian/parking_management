part of 'slot_bloc.dart';

@immutable
sealed class SlotState {}

final class SlotInitial extends SlotState {}


class ParkLoading extends SlotState{}

class ParkError extends SlotState {
  final String error;
  ParkError(this.error);
}

class ParkLoaded extends SlotState{
  final List<ParkingSlot>slot;
  ParkLoaded(this.slot);
}
