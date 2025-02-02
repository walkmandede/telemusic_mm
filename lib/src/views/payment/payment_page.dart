import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/models/plan_model.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';
import 'package:telemusic_v2/utils/constants/app_extensions.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/constants/app_theme.dart';
import 'package:telemusic_v2/utils/services/network/api_repo.dart';
import 'package:telemusic_v2/utils/services/overlay/dialog_service.dart';

final supportedPayments = [
  "KBZ Bank Account",
  "KBZ Pay",
  "AYA Bank Account",
  "AYA Pay",
  "CB Bank Account",
  "CB Pay",
  "Wave Money",
];

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  ValueNotifier<bool> xLoading = ValueNotifier(false);
  ValueNotifier<String> selectedPayment =
      ValueNotifier(supportedPayments.first);
  ValueNotifier<int> paidAmount = ValueNotifier(0);

  TextEditingController txtHolderName = TextEditingController(text: "");
  TextEditingController txtPaymentNumber = TextEditingController(text: "");

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  initLoad() async {
    xLoading.value = true;
    try {
      final apiResponse = await ApiRepo().getMyPayment();
      txtHolderName.text = apiResponse.bodyData["payment_holder_name"] ?? "";
      txtPaymentNumber.text = apiResponse.bodyData["payment_value"] ?? "";
      selectedPayment.value = apiResponse.bodyData["payment_type"] ?? "";
      paidAmount.value = apiResponse.bodyData["total_payment_value"] ?? 0;
      superPrint(selectedPayment.value);
    } catch (e) {
      superPrint(e);
    }
    xLoading.value = false;
  }

  void updatePaymentMethod() async {
    superPrint("s");
    DialogService().showLoadingDialog(context: context);
    final result = await ApiRepo().updatePaymentMethod(
        type: selectedPayment.value,
        holderName: txtHolderName.text,
        accountNumber: txtPaymentNumber.text);
    DialogService().dismissDialog(context: Get.context!);
    DialogService().showConfirmDialog(context: Get.context!, label: "Success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Method"),
        centerTitle: false,
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.basePadding,
              vertical: AppConstants.basePadding),
          child: ValueListenableBuilder(
            valueListenable: xLoading,
            builder: (context, xLoading, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                    valueListenable: paidAmount,
                    builder: (context, paidAmount, child) {
                      return TextField(
                        controller:
                            TextEditingController(text: paidAmount.toString()),
                        style: const TextStyle(
                            fontSize: AppConstants.baseFontSizeXXL),
                        decoration: const InputDecoration(
                            fillColor: AppTheme.primaryBlack,
                            labelText: "Total Earning",
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                fontSize: AppConstants.baseFontSizeXL),
                            enabledBorder: InputBorder.none),
                      );
                    },
                  ),
                  (AppConstants.basePadding).heightBox(),
                  const Text("Account Type"),
                  ValueListenableBuilder(
                    valueListenable: selectedPayment,
                    builder: (context, sp, child) {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 0,
                        children: [
                          ...supportedPayments.map((each) {
                            final xSelected = sp == each;
                            return InkWell(
                              onTap: () {
                                vibrateNow();
                                selectedPayment.value = each;
                              },
                              child: Chip(
                                label: Text(
                                  each,
                                  style: TextStyle(
                                      color: xSelected
                                          ? AppTheme.primaryBlack
                                          : AppTheme.white),
                                ),
                                backgroundColor: xSelected
                                    ? AppTheme.primaryYellow
                                    : AppTheme.darkGray,
                              ),
                            );
                          })
                        ],
                      );
                    },
                  ),
                  (AppConstants.basePadding).heightBox(),
                  TextField(
                    controller: txtHolderName,
                    decoration: const InputDecoration(
                      fillColor: AppTheme.primaryBlack,
                      border: OutlineInputBorder(),
                      labelText: "Account Holder",
                    ),
                  ),
                  (AppConstants.basePadding).heightBox(),
                  TextField(
                    controller: txtPaymentNumber,
                    decoration: const InputDecoration(
                      fillColor: AppTheme.primaryBlack,
                      border: OutlineInputBorder(),
                      labelText: "Account Number",
                    ),
                  ),
                  (AppConstants.basePadding).heightBox(),
                  SizedBox(
                    width: double.infinity,
                    height: AppConstants.baseButtonHeight,
                    child: ElevatedButton(
                        onPressed: () {
                          vibrateNow();
                          updatePaymentMethod();
                        },
                        child: const Text("Update Payment Method")),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
