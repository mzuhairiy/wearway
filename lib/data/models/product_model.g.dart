// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      slug: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      priceIdr: (fields[4] as num).toInt(),
      stock: (fields[5] as num).toInt(),
      imageUrls: (fields[6] as List).cast<String>(),
      categoryId: fields[7] as String,
      sizes: (fields[8] as List).cast<String>(),
      colors: (fields[9] as List).cast<String>(),
      isFeatured: fields[10] as bool,
      rating: (fields[11] as num).toDouble(),
      reviewCount: (fields[12] as num).toInt(),
      badges: (fields[13] as List).cast<String>(),
      createdAtMs: (fields[15] as num).toInt(),
      discountPercent: (fields[14] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.slug)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.priceIdr)
      ..writeByte(5)
      ..write(obj.stock)
      ..writeByte(6)
      ..write(obj.imageUrls)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.sizes)
      ..writeByte(9)
      ..write(obj.colors)
      ..writeByte(10)
      ..write(obj.isFeatured)
      ..writeByte(11)
      ..write(obj.rating)
      ..writeByte(12)
      ..write(obj.reviewCount)
      ..writeByte(13)
      ..write(obj.badges)
      ..writeByte(14)
      ..write(obj.discountPercent)
      ..writeByte(15)
      ..write(obj.createdAtMs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
