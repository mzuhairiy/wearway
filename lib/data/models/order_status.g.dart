// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final typeId = 5;

  @override
  OrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatus.placed;
      case 1:
        return OrderStatus.preparing;
      case 2:
        return OrderStatus.shipped;
      case 3:
        return OrderStatus.delivered;
      case 4:
        return OrderStatus.cancelled;
      default:
        return OrderStatus.placed;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    switch (obj) {
      case OrderStatus.placed:
        writer.writeByte(0);
      case OrderStatus.preparing:
        writer.writeByte(1);
      case OrderStatus.shipped:
        writer.writeByte(2);
      case OrderStatus.delivered:
        writer.writeByte(3);
      case OrderStatus.cancelled:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
