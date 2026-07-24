import 'package:hive_ce/hive_ce.dart';

part 'order_status.g.dart';

/// Status lifecycle sebuah order (dipakai untuk notif simulation di Prompt 7).
@HiveType(typeId: 5)
enum OrderStatus {
  @HiveField(0)
  placed,
  @HiveField(1)
  preparing,
  @HiveField(2)
  shipped,
  @HiveField(3)
  delivered,
  @HiveField(4)
  cancelled,
}
