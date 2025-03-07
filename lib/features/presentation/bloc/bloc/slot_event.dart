part of 'slot_bloc.dart';

@immutable
sealed class SlotEvent {}


class ToggleslotStatus extends SlotEvent{
  final int slotnumber;
  ToggleslotStatus(this.slotnumber);
}
