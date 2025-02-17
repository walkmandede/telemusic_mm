import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';

class IAPService {
  final InAppPurchase iap = InAppPurchase.instance;
  late Stream<List<PurchaseDetails>> purchaseStream;

  IAPService() {
    purchaseStream = iap.purchaseStream;
    purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    });
  }

  Future<List<ProductDetails>> fetchProducts(List<String> productIds) async {
    final ProductDetailsResponse response =
        await iap.queryProductDetails(productIds.toSet());
    return response.productDetails;
  }

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    iap.buyConsumable(purchaseParam: purchaseParam);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    superPrint(purchases, title: "Handling");
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        print("Purchase Successful: ${purchase.productID}");

        // Grant the user access to the purchased item
        // _deliverProduct(purchase);

        // COMPLETE the transaction to remove the pending state
        if (purchase.pendingCompletePurchase) {
          InAppPurchase.instance.completePurchase(purchase);
        } else {
          InAppPurchase.instance.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        InAppPurchase.instance.completePurchase(purchase);
        print("Purchase Error: ${purchase.error}");
      } else if (purchase.status == PurchaseStatus.canceled) {
        InAppPurchase.instance.completePurchase(purchase);
        print("Purchase Error: ${purchase.error}");
      } else {}
    }
  }
}
