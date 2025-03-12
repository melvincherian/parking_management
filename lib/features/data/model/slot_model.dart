




class ParkingSlot {
  final int id;
  final bool isOccupied;
  final DateTime? entryTime;

  ParkingSlot({required this.id,  this.isOccupied=false,this.entryTime});

  ParkingSlot copyWith({bool? isOccupied,DateTime?entryTime}) {
    return ParkingSlot(
      id: id,
      isOccupied: isOccupied ?? this.isOccupied,
      entryTime: entryTime??this.entryTime
    );
  }
}
