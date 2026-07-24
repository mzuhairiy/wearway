// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final typeId = 6;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as String,
      orderNumber: fields[1] as String,
      userId: fields[2] as String,
      addressId: fields[3] as String,
      subtotalIdr: (fields[4] as num).toInt(),
      deliveryFeeIdr: (fields[5] as num).toInt(),
      discountIdr: (fields[6] as num).toInt(),
      totalIdr: (fields[7] as num).toInt(),
      status: fields[8] as OrderStatus,
      paymentMethod: fields[9] as String,
      placedAtMs: (fields[10] as num).toInt(),
      estimatedDeliveryMs: (fields[11] as num).toInt(),
      items: (fields[12] as List).cast<OrderItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderNumber)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.addressId)
      ..writeByte(4)
      ..write(obj.subtotalIdr)
      ..writeByte(5)
      ..write(obj.deliveryFeeIdr)
      ..writeByte(6)
      ..write(obj.discountIdr)
      ..writeByte(7)
      ..write(obj.totalIdr)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.paymentMethod)
      ..writeByte(10)
      ..write(obj.placedAtMs)
      ..writeByte(11)
      ..write(obj.estimatedDeliveryMs)
      ..writeByte(12)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
