import 'package:equatable/equatable.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';

class PaymentMethodModel extends Equatable {
  final StripePayModel stripePayModel;
  final PayPalModel payPalModel;

  const PaymentMethodModel(
      {required this.stripePayModel, required this.payPalModel});

  factory PaymentMethodModel.fromMap({required Map<String, dynamic> data}) {
    // superPrint(data, title: "Payment");
    return PaymentMethodModel(
      stripePayModel: StripePayModel.fromMap(data: data["stripe"] ?? {}),
      payPalModel: PayPalModel.fromMap(data: data["paypal"] ?? {}),
    );
  }

  @override
  List<Object?> get props => [stripePayModel];
}

class StripePayModel extends Equatable {
  @override
  List<Object?> get props => [
        clientId,
        secret,
        merchantDisplayName,
        countryCode,
        countryIdentifier
      ].map((each) => "\n$each").toList();

  final String clientId;
  final String secret;
  final String merchantDisplayName;
  final String countryCode;
  final String countryIdentifier;

  const StripePayModel(
      {required this.clientId,
      required this.secret,
      required this.merchantDisplayName,
      required this.countryCode,
      required this.countryIdentifier});

  factory StripePayModel.fromMap({required Map<String, dynamic> data}) {
    return StripePayModel(
      clientId: data["stripe_client_id"].toString(),
      secret: data["stripe_secret"].toString(),
      merchantDisplayName: data["stripe_merchant_display_name"].toString(),
      countryCode: data["stripe_merchant_country_code"].toString(),
      countryIdentifier: data["stripe_merchant_country_identifier"].toString(),
    );
  }
}

class PayPalModel extends Equatable {
  final String clientId;
  final String secret;
  final String mode;

  const PayPalModel(
      {required this.clientId, required this.mode, required this.secret});

  factory PayPalModel.fromMap({required Map<String, dynamic> data}) {
    return PayPalModel(
        clientId: data["paypal_client_id"].toString(),
        secret: data["paypal_secret"].toString(),
        mode: data["paypal_mode"].toString());
  }

  @override
  List<Object?> get props => [clientId, secret, mode];
}
