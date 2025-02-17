import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:http/http.dart' as http;
import 'package:telemusic_v2/utils/services/iap/iap_service.dart';
import 'package:telemusic_v2/utils/services/network/api_end_points.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';
import '../../models/plan_model.dart';
import 'package:dio/dio.dart' as dio;

class PremiumDetailPage extends StatefulWidget {
  final PlanModel planModel;
  const PremiumDetailPage({super.key, required this.planModel});

  @override
  State<PremiumDetailPage> createState() => _PremiumDetailPageState();
}

class _PremiumDetailPageState extends State<PremiumDetailPage> {
  IAPService iapService = IAPService();
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  DataController dataController = Get.find();

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    super.dispose();
  }

  Future<void> initLoad() async {
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) async {
        if (purchaseDetailsList.isNotEmpty) {
          final firstPurchase = purchaseDetailsList.first;
          if (firstPurchase.status == PurchaseStatus.purchased) {
            superPrint(firstPurchase.purchaseID, title: "Pruchase ID");
            superPrint(firstPurchase.purchaseID);
            await proceedSavePlan(
                orderId: firstPurchase.transactionDate ?? "-",
                planId: widget.planModel.id.toString(),
                productId: firstPurchase.productID,
                amount: widget.planModel.planAmount,
                currency: dataController.currentUser.value!.currencyCode,
                paymentGateway: "In app purchase",
                paymentId: firstPurchase.purchaseID ?? "-",
                transactionId: firstPurchase.purchaseID ?? "-");
          }
        }
      },
      onError: (error) {
        print("Error in purchase stream: $error");
      },
    );
  }

  Future<void> proceedSavePlan(
      {required String orderId,
      required String planId,
      required String productId,
      required String amount,
      required String currency,
      required String paymentGateway,
      required String paymentId,
      required String transactionId}) async {
    // ignore: prefer_interpolation_to_compose_strings
    String paymentDataInJson = '[{"order_id":"' +
        orderId +
        '",'
            '"plan_id":"' +
        planId +
        '"'
            ',"product_id":"' +
        productId +
        '"'
            ',"amount":"' +
        amount +
        '","currency":"' +
        currency +
        '"'
            ',"discount":"' +
        "0" +
        '","taxAmount":"0","payment_gateway":"' +
        paymentGateway +
        '","user_email":"' +
        "" +
        '","user_name":"' +
        "" +
        '","taxPercent":"' +
        "0" +
        '"'
            ',"plan_exact_amount":"' +
        amount.toString() +
        '"'
            ',"payment_id":"' +
        paymentId +
        '","coupon_id":"' +
        "" +
        '"'
            ',"transaction_id":"' +
        transactionId +
        '"}]';

    final formData = dio.FormData.fromMap({
      "type": paymentGateway,
      "plan_id": planId,
      "payment_data": paymentDataInJson,
      "order_id": orderId,
    });

    superPrint(formData.fields);

    final dio.Dio _dio = dio.Dio();
    dio.Response<String>? response;
    try {
      response = await _dio.post(
          ApiService.baseUrl + ApiEndPoints.savePaymentTransaction,
          data: formData,
          options: dio.Options(headers: {
            "Accept": "application/json",
            "authorization": "Bearer ${dataController.apiToken}"
          }));
      log(response.data.toString(),
          name: "Save Plan - StatusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        DialogService().showConfirmDialog(
            context: Get.context!, label: "Payment detail successfully saved");
      } else {
        DialogService().showConfirmDialog(
            context: Get.context!, label: "Something went wrong");
      }
    } catch (e) {
      if (e is dio.DioException) {
        superPrint(e.response!.data,
            title: "Save plan ${e.response!.statusCode}");
      }
      DialogService().showConfirmDialog(
          context: Get.context!, label: "Something went wrong");
    }
  }

  Future<void> proceedOnClickStripePay() async {
    DataController dataController = Get.find();
    final stripeModel =
        dataController.allPaymentMethodModel.value!.stripePayModel;
    final stripe = Stripe.instance;
    superPrint(stripeModel);

    Stripe.publishableKey = stripeModel.clientId; // Replace with your key
    Stripe.merchantIdentifier =
        stripeModel.countryIdentifier; // Replace with your key
    await stripe.applySettings();

    final response = await getStripePaymentIntent(
        amount: widget.planModel.planAmount,
        currency: dataController.currentUser.value!.currencyCode,
        secretKey: stripeModel.secret);
    final intentClientSecret = response['client_secret'];
    superPrint(response);
    superPrint(intentClientSecret);

    // Step 2: Initialize Payment Sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: intentClientSecret,
        merchantDisplayName: stripeModel.merchantDisplayName,
      ),
    );

    // Step 3: Show Payment Sheet
    final result = await Stripe.instance.presentPaymentSheet();
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(content: Text("Payment successful!")),
    );
    await proceedSavePlan(
        orderId: response["id"].toString(),
        planId: widget.planModel.id.toString(),
        productId: response["id"].toString(),
        amount: widget.planModel.planAmount,
        currency: dataController.currentUser.value!.currencyCode,
        paymentGateway: "Stripe",
        paymentId: response["id"].toString(),
        transactionId: response["id"].toString());
  }

  Future<void> proceedOnClickIap() async {
    final result =
        await iapService.fetchProducts([widget.planModel.productId.toString()]);
    // await iapService.iap.restorePurchases();
    superPrint("restored");
    if (result.isNotEmpty) {
      await iapService.buyProduct(result.first);
    }
  }

  Future<void> proceedOnClickPayPal() async {
    superPrint("content");
    DataController dataController = Get.find();
    final payPalModel = dataController.allPaymentMethodModel.value!.payPalModel;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: payPalModel.mode == 'Live' ? false : true,
        clientId: payPalModel.clientId,
        secretKey: payPalModel.secret,
        transactions: [
          {
            "amount": {
              "total": widget.planModel.planAmount,
              "currency": dataController.currentUser.value!.currencyCode,
              "details": {
                "subtotal": widget.planModel.planAmount,
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": widget.planModel.planName,
            "item_list": {
              "items": [
                {
                  "name": widget.planModel.planName,
                  "quantity": 1,
                  "price": widget.planModel.planAmount,
                  "currency": dataController.currentUser.value!.currencyCode
                },
              ],
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          print("onSuccess: $params");
          int _nowstamp = DateTime.now().millisecondsSinceEpoch;

          await proceedSavePlan(
              orderId: _nowstamp.toString(),
              planId: widget.planModel.id.toString(),
              productId: widget.planModel.id.toString(),
              amount: widget.planModel.planAmount,
              currency: dataController.currentUser.value!.currencyCode,
              paymentGateway: "Paypal",
              paymentId: params["paymentId"].toString(),
              transactionId: params["paymentId"].toString());
        },
        onError: (error) {
          print("onError: $error");
          Navigator.pop(context);
        },
        onCancel: () {
          print('cancelled:');
        },
      ),
    ));
  }

  Future<Map<String, dynamic>> getStripePaymentIntent(
      {required String amount,
      required String currency,
      required String secretKey}) async {
    Map<String, dynamic> body = {
      'amount': ((double.parse(amount)) * 100).toInt().toString(),
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    // secretKey =
    //     "sk_test_51QrEC2D8cGLEFiSaP30bYDwqKSPnwEWfzmtgsYUOdguhopcKitALA0JNr5s0lGy5n18iSiu7ODZgWmwHx472iyGx00D1wtCzX0";
    var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                width: Get.width,
                imageUrl: widget.planModel.image,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.basePadding,
                    vertical: AppConstants.basePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.planModel.planName,
                      style: const TextStyle(
                          fontSize: AppConstants.baseFontSizeXL),
                    ),
                    Text(
                      "${widget.planModel.validity} days for ${widget.planModel.planAmount} \$",
                      style:
                          const TextStyle(fontSize: AppConstants.baseFontSizeL),
                    ),
                    (AppConstants.basePadding).heightBox(),
                    SizedBox(
                      width: Get.width * 0.6,
                      child: ElevatedButton(
                          onPressed: () {
                            vibrateNow();
                            proceedOnClickStripePay();
                          },
                          child: const Text("Purchase with Stripe Pay")),
                    ),
                    SizedBox(
                      width: Get.width * 0.6,
                      child: ElevatedButton(
                          onPressed: () {
                            vibrateNow();
                            proceedOnClickPayPal();
                          },
                          child: const Text("Purchase with Paypal")),
                    ),
                    if (Platform.isIOS)
                      SizedBox(
                        width: Get.width * 0.6,
                        child: ElevatedButton(
                            onPressed: () {
                              vibrateNow();
                              proceedOnClickIap();
                            },
                            child: Text(Platform.isIOS
                                ? "Purchase with Apple Pay"
                                : "Purchase with Google Pay")),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
