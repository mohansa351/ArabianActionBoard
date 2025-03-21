import 'package:bizlogika_app/controllers/task_controller.dart';
import 'package:bizlogika_app/utils/common_widgets.dart';
import 'package:bizlogika_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesDetailScreen extends StatefulWidget {
  const SalesDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<SalesDetailScreen> createState() => _SalesDetailScreenState();
}

class _SalesDetailScreenState extends State<SalesDetailScreen> {
  int _selectedIndex = 0;

  List<String> categories = [
    "Receipts collected",
    "Pending invoices",
    "Invoices not issued",
    "Pending SO",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Get.find<TaskController>().fetchSalesDetails(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: GetBuilder<TaskController>(
        builder: (TaskController controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        "Sales Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _selectedIndex = index;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: index == _selectedIndex
                                  ? primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: borderColor)),
                          margin: const EdgeInsets.only(right: 10),
                          child: Center(
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: index == _selectedIndex
                                      ? Colors.white
                                      : Colors.black54),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),
                controller.jobLoader
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      )
                    : _selectedIndex == 0
                        ? Expanded(
                            child: controller.receiptsList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: controller.receiptsList.length,
                                    itemBuilder: (context, index) {
                                      final receipt =
                                          controller.receiptsList[index];

                                      return Card(
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
                                              _buildRow("Transaction No",
                                                  receipt.transactionNo),
                                              _buildRow("Against Reference",
                                                  receipt.againstReference),
                                              _buildRow(
                                                  "Amount", receipt.amount),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      "No receipts available",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87),
                                    ),
                                  ),
                          )
                        : _selectedIndex == 1
                            ? Expanded(
                                child: controller.pendingInvoicesList.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: controller
                                            .pendingInvoicesList.length,
                                        itemBuilder: (context, index) {
                                          final invoice = controller
                                              .pendingInvoicesList[index];

                                          return Card(
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
                                                  _buildRow("Transaction No",
                                                      invoice.transactionNo),
                                                  _buildRow(
                                                      "Amount", invoice.amount),
                                                  _buildRow("Balance",
                                                      invoice.balance),
                                                  _buildRow(
                                                      "Status", invoice.status),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: Text(
                                          "No invoice available",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black87),
                                        ),
                                      ),
                              )
                            : _selectedIndex == 2
                                ? Expanded(
                                    child: controller
                                            .invoicesNotIssuedList.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: controller
                                                .invoicesNotIssuedList.length,
                                            itemBuilder: (context, index) {
                                              final invoice = controller
                                                  .invoicesNotIssuedList[index];

                                              return Card(
                                                elevation: 1,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _buildRow(
                                                          "Transaction No",
                                                          invoice
                                                              .transactionNo),
                                                      _buildRow("Amount",
                                                          invoice.amount),
                                                      _buildRow("Status",
                                                          invoice.status),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : const Center(
                                            child: Text(
                                              "No invoice available",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                  )
                                : _selectedIndex == 3
                                    ? Expanded(
                                        child: controller
                                                .pendingSOList.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: controller
                                                    .pendingSOList.length,
                                                itemBuilder: (context, index) {
                                                  final invoice = controller
                                                      .pendingSOList[index];

                                                  return Card(
                                                    elevation: 1,
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _buildRow(
                                                              "Transaction No",
                                                              invoice
                                                                  .transactionNo),
                                                          _buildRow(
                                                              "Transaction No",
                                                              formatDate(invoice
                                                                  .transactionDate)),
                                                          _buildRow(
                                                              "Pending amount",
                                                              invoice
                                                                  .pendingAmt),
                                                          _buildRow("Status",
                                                              invoice.status),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child: Text(
                                                  "No invoice available",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.black87),
                                                ),
                                              ),
                                      )
                                    : const SizedBox(),
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
