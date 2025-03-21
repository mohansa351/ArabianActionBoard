import 'package:bizlogika_app/controllers/task_controller.dart';
import 'package:bizlogika_app/utils/common_widgets.dart';
import 'package:bizlogika_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PurchaseDetailsScreen extends StatefulWidget {
  const PurchaseDetailsScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<PurchaseDetailsScreen> createState() => _PurchaseDetailsScreenState();
}

class _PurchaseDetailsScreenState extends State<PurchaseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Get.find<TaskController>().fetchPurchaseDetails(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: GetBuilder<TaskController>(
        builder: (TaskController controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Purchase Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                controller.jobLoader
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      )
                    : Expanded(
                        child: controller.purchaseDetailsList.isNotEmpty
                            ? ListView.builder(
                                itemCount:
                                    controller.purchaseDetailsList.length,
                                itemBuilder: (context, index) {
                                  final purchase =
                                      controller.purchaseDetailsList[index];

                                  return Column(
                                    children: [
                                      purchase.orderRef == ""
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                Divider(
                                                    color: primaryColor,
                                                    thickness: 2),
                                                const SizedBox(height: 15),
                                                _buildRow("Order Ref",
                                                    purchase.orderRef),
                                                _buildRow(
                                                    "Date", formatDate(purchase.date)),
                                                _buildRow("Supplier Name",
                                                    purchase.supplierName),
                                              ],
                                            ),
                                      Card(
                                        elevation: 1,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildRow("Item Code",
                                                  purchase.itemCode),
                                              _buildRow("Description",
                                                  purchase.description),
                                              _buildRow("Quantity",
                                                  purchase.quantity),
                                              _buildRow("Unit Price",
                                                  purchase.unitPrice),
                                              _buildRow("Budget Value",
                                                  purchase.budgetValue),
                                              _buildRow("Foreign Order",
                                                  purchase.foreignOrder),
                                              _buildRow("Order Amount",
                                                  purchase.orderAmt),
                                              _buildRow("Amount Settled",
                                                  purchase.amtSettled),
                                              _buildRow(
                                                  "Balance", purchase.balance),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10)
                                    ],
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  "No purchase details available",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87),
                                ),
                              ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
