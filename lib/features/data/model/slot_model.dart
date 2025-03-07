// 


class ParkingSlot {
  final String slotNumber;
  final bool isReserved;
  final DateTime? entryTime;

  ParkingSlot({
    required this.slotNumber,
    this.isReserved = false,
    this.entryTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'slotNumber': slotNumber,
      'isReserved': isReserved,
      'entryTime': entryTime?.toIso8601String(),
    };
  }

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      slotNumber: json['slotNumber'],
      isReserved: json['isReserved'],
      entryTime: json['entryTime'] != null ? DateTime.parse(json['entryTime']) : null,
    );
  }
}
