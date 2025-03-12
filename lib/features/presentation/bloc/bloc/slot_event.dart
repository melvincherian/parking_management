part of 'slot_bloc.dart';

@immutable
sealed class SlotEvent {}


class LoadSlots extends SlotEvent {}


class ToggleslotStatus extends SlotEvent{
  final int slotId;
  ToggleslotStatus(this.slotId);
}

class ReserveSlot extends SlotEvent {
  final String slotId;
  final DateTime entryTime;

  ReserveSlot(this.slotId, this.entryTime);
}


class ReleaseSlot extends SlotEvent {
  final int slotId;
  ReleaseSlot(this.slotId);
}

