import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wearway_flutter/data/models/address_model.dart';
import 'package:wearway_flutter/data/models/order_item_model.dart';
import 'package:wearway_flutter/data/models/order_model.dart';
import 'package:wearway_flutter/data/models/order_status.dart';
import 'package:wearway_flutter/data/providers/repository_providers.dart';
import 'package:wearway_flutter/features/address/providers/address_providers.dart';
import 'package:wearway_flutter/features/cart/providers/cart_providers.dart';

part 'checkout_controller.g.dart';

const int _freeShippingThresholdIdr = 300000;

/// Opsi pengiriman (id stabil untuk ValueKey `delivery_method_{id}`).
class DeliveryMethod {
  const DeliveryMethod({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.feeIdr,
    required this.etaDays,
  });

  final String id;
  final String label;
  final String subtitle;
  final int feeIdr;
  final int etaDays;
}

const DeliveryMethod kDeliveryRegular = DeliveryMethod(
  id: 'regular',
  label: 'Regular',
  subtitle: '2-3 hari kerja',
  feeIdr: 15000,
  etaDays: 3,
);
const DeliveryMethod kDeliveryExpress = DeliveryMethod(
  id: 'express',
  label: 'Express',
  subtitle: 'Same day',
  feeIdr: 35000,
  etaDays: 1,
);
const DeliveryMethod kDeliveryFree = DeliveryMethod(
  id: 'free',
  label: 'Gratis Ongkir',
  subtitle: 'Subtotal di atas Rp 300rb • 2-3 hari',
  feeIdr: 0,
  etaDays: 3,
);

const List<DeliveryMethod> kDeliveryMethods = [
  kDeliveryRegular,
  kDeliveryExpress,
  kDeliveryFree,
];

/// Metode pembayaran (mock — tidak ada integrasi nyata).
class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.label,
    required this.subtitle,
  });

  final String id;
  final String label;
  final String subtitle;
}

const List<PaymentMethod> kPaymentMethods = [
  PaymentMethod(id: 'cod', label: 'COD', subtitle: 'Bayar di tempat'),
  PaymentMethod(
    id: 'bank_transfer',
    label: 'Transfer Bank',
    subtitle: 'Virtual account (mock)',
  ),
  PaymentMethod(id: 'gopay', label: 'GoPay', subtitle: 'E-wallet (mock)'),
  PaymentMethod(id: 'ovo', label: 'OVO', subtitle: 'E-wallet (mock)'),
];

/// State form checkout (multi-step). Immutable → copyWith untuk update.
class CheckoutState {
  const CheckoutState({
    this.step = 0,
    this.selectedAddressId,
    this.recipientName = '',
    this.phone = '',
    this.street = '',
    this.city = '',
    this.postalCode = '',
    this.label = 'Alamat Baru',
    this.saveAddress = false,
    this.deliveryId = 'regular', // = kDeliveryRegular.id (const literal)
    this.paymentId = 'cod',
    this.termsAccepted = false,
    this.isPlacing = false,
  });

  final int step;
  final String? selectedAddressId;
  final String recipientName;
  final String phone;
  final String street;
  final String city;
  final String postalCode;
  final String label;
  final bool saveAddress;
  final String deliveryId;
  final String paymentId;
  final bool termsAccepted;
  final bool isPlacing;

  bool get usingSavedAddress => selectedAddressId != null;

  /// Step 1 (Address) valid: pakai alamat tersimpan, atau field wajib terisi.
  bool get addressValid {
    if (usingSavedAddress) return true;
    return recipientName.trim().isNotEmpty &&
        phone.trim().isNotEmpty &&
        street.trim().isNotEmpty &&
        city.trim().isNotEmpty &&
        postalCode.trim().isNotEmpty;
  }

  DeliveryMethod get delivery =>
      kDeliveryMethods.firstWhere((m) => m.id == deliveryId);

  PaymentMethod get payment =>
      kPaymentMethods.firstWhere((m) => m.id == paymentId);

  CheckoutState copyWith({
    int? step,
    String? Function()? selectedAddressId,
    String? recipientName,
    String? phone,
    String? street,
    String? city,
    String? postalCode,
    String? label,
    bool? saveAddress,
    String? deliveryId,
    String? paymentId,
    bool? termsAccepted,
    bool? isPlacing,
  }) {
    return CheckoutState(
      step: step ?? this.step,
      selectedAddressId: selectedAddressId != null
          ? selectedAddressId()
          : this.selectedAddressId,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      label: label ?? this.label,
      saveAddress: saveAddress ?? this.saveAddress,
      deliveryId: deliveryId ?? this.deliveryId,
      paymentId: paymentId ?? this.paymentId,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isPlacing: isPlacing ?? this.isPlacing,
    );
  }
}

/// Controller flow checkout: navigasi step, isi form, place order.
@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  CheckoutState build() {
    // Default delivery: gratis kalau eligible, else regular.
    final subtotal = ref.read(cartSubtotalProvider);
    final eligibleFree = subtotal > _freeShippingThresholdIdr;
    return CheckoutState(
      deliveryId: eligibleFree ? kDeliveryFree.id : kDeliveryRegular.id,
    );
  }

  void goTo(int step) => state = state.copyWith(step: step.clamp(0, 3));
  void next() => goTo(state.step + 1);
  void back() => goTo(state.step - 1);

  void selectSavedAddress(String? addressId) =>
      state = state.copyWith(selectedAddressId: () => addressId);

  void setAddressFields({
    String? recipientName,
    String? phone,
    String? street,
    String? city,
    String? postalCode,
  }) {
    state = state.copyWith(
      // Mengisi manual → lepas pilihan alamat tersimpan.
      selectedAddressId: () => null,
      recipientName: recipientName,
      phone: phone,
      street: street,
      city: city,
      postalCode: postalCode,
    );
  }

  void setSaveAddress({required bool value}) =>
      state = state.copyWith(saveAddress: value);

  void selectDelivery(String id) => state = state.copyWith(deliveryId: id);

  void selectPayment(String id) => state = state.copyWith(paymentId: id);

  void setTerms({required bool value}) =>
      state = state.copyWith(termsAccepted: value);

  /// Buat order + item snapshot ke Hive, clear cart & promo.
  /// Return orderId (untuk navigasi ke confirmation), atau null kalau gagal.
  Future<String?> placeOrder() async {
    final userId = ref.read(currentUserIdProvider);
    final lines = ref.read(cartLinesProvider);
    if (userId == null || lines.isEmpty) return null;

    state = state.copyWith(isPlacing: true);
    try {
      final addressId = await _resolveAddressId(userId);
      // Hitung ringkasan inline (JANGAN read checkoutSummaryProvider di sini →
      // provider itu watch controller ini = circular dependency).
      final subtotal = ref.read(cartSubtotalProvider);
      final discount = ref.read(cartSummaryProvider).discountIdr;
      final deliveryFee = state.delivery.feeIdr;
      final total = (subtotal + deliveryFee - discount).clamp(0, 1 << 31);

      final items = [
        for (final line in lines)
          OrderItemModel(
            productId: line.product.id,
            productName: line.product.name,
            pricePerUnitIdr: line.unitPriceIdr,
            size: line.item.selectedSize,
            color: line.item.selectedColor,
            quantity: line.item.quantity,
            subtotalIdr: line.lineSubtotalIdr,
          ),
      ];

      final now = DateTime.now();
      final existing = await ref.read(orderRepositoryProvider).list(userId);
      final seq = existing.length + 1;
      final order = OrderModel(
        id: 'order_${userId}_${now.millisecondsSinceEpoch}',
        orderNumber: _orderNumber(now, seq),
        userId: userId,
        addressId: addressId,
        subtotalIdr: subtotal,
        deliveryFeeIdr: deliveryFee,
        discountIdr: discount,
        totalIdr: total,
        status: OrderStatus.placed,
        paymentMethod: state.payment.label,
        placedAtMs: now.millisecondsSinceEpoch,
        estimatedDeliveryMs: now
            .add(Duration(days: state.delivery.etaDays))
            .millisecondsSinceEpoch,
        items: items,
      );

      await ref.read(orderRepositoryProvider).create(order);
      await ref.read(cartControllerProvider.notifier).clearCart();
      ref.read(promoControllerProvider.notifier).remove();
      return order.id;
    } finally {
      state = state.copyWith(isPlacing: false);
    }
  }

  /// Pakai alamat tersimpan, atau persist alamat manual (isSaved sesuai
  /// checkbox — kalau tidak disimpan tetap dipersist agar order bisa
  /// mereferensikannya).
  Future<String> _resolveAddressId(String userId) async {
    if (state.selectedAddressId != null) return state.selectedAddressId!;
    final now = DateTime.now();
    final address = AddressModel(
      id: 'addr_${userId}_${now.millisecondsSinceEpoch}',
      userId: userId,
      label: state.saveAddress ? state.label : 'Alamat Pengiriman',
      recipientName: state.recipientName.trim(),
      phone: state.phone.trim(),
      streetAddress: state.street.trim(),
      city: state.city.trim(),
      postalCode: state.postalCode.trim(),
      isDefault: false,
      isSaved: state.saveAddress,
    );
    await ref.read(addressRepositoryProvider).create(address);
    return address.id;
  }

  String _orderNumber(DateTime d, int seq) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final seqStr = seq.toString().padLeft(5, '0');
    return 'ORD-${d.year}$m$day-$seqStr';
  }
}

/// Ringkasan biaya checkout: subtotal + ongkir (metode dipilih) - diskon.
class CheckoutSummary {
  const CheckoutSummary({
    required this.subtotalIdr,
    required this.deliveryFeeIdr,
    required this.discountIdr,
    required this.totalIdr,
  });

  final int subtotalIdr;
  final int deliveryFeeIdr;
  final int discountIdr;
  final int totalIdr;
}

@riverpod
CheckoutSummary checkoutSummary(Ref ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final cart = ref.watch(cartSummaryProvider);
  final delivery = ref.watch(checkoutControllerProvider).delivery;
  final discount = cart.discountIdr;
  final total = (subtotal + delivery.feeIdr - discount).clamp(0, 1 << 31);
  return CheckoutSummary(
    subtotalIdr: subtotal,
    deliveryFeeIdr: delivery.feeIdr,
    discountIdr: discount,
    totalIdr: total,
  );
}
