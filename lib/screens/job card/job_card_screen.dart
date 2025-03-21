import 'package:bizlogika_app/controllers/task_controller.dart';
import 'package:bizlogika_app/screens/job%20card/journal_voucher.dart';
import 'package:bizlogika_app/screens/job%20card/overhead_against_pv.dart';
import 'package:bizlogika_app/screens/job%20card/overhead_direct_invoice.dart';
import 'package:bizlogika_app/screens/job%20card/purchase_details.dart';
import 'package:bizlogika_app/screens/job%20card/sales_screen.dart';
import 'package:bizlogika_app/utils/common_widgets.dart';
import 'package:bizlogika_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobCardScreen extends StatefulWidget {
  const JobCardScreen({
    super.key,
    required this.projectId,
  });
  final String projectId;

  @override
  State<JobCardScreen> createState() => _JobCardScreenState();
}

class _JobCardScreenState extends State<JobCardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Get.find<TaskController>().fetchJobCardDetails(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: GetBuilder<TaskController>(
        builder: (TaskController controller) {
          return controller.taskLoader
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: SingleChildScrollView(
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
                                "Job Card",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        controller.projectDetails != null
                            ? _buildSection("Project Details", [
                                _buildRow("Project Code",
                                    controller.projectDetails!.projectCode),
                                _buildRow("Project Name",
                                    controller.projectDetails!.projectName),
                                _buildRow("Client Name",
                                    controller.projectDetails!.clientName),
                                _buildRow(
                                    "Sales Order Number",
                                    controller
                                        .projectDetails!.salesOrderNumber),
                                _buildRow("Max Revision No",
                                    controller.projectDetails!.maxRevisionNo),
                                _buildRow(
                                    "Sales Order Date",
                                    formatDate(controller
                                        .projectDetails!.salesOrderDate)),
                                _buildRow(
                                    "LPO", controller.projectDetails!.lpo),
                                _buildRow("Currency",
                                    controller.projectDetails!.currency),
                                _buildRow("Exchange Rate",
                                    controller.projectDetails!.exchangeRate),
                                _buildRow(
                                    "Initial Project Value",
                                    controller
                                        .projectDetails!.initialProjectValue),
                                _buildRow("Variation",
                                    controller.projectDetails!.variation),
                                _buildRow(
                                    "Total Project Value",
                                    controller
                                        .projectDetails!.totalProjectValue),
                                _buildRow("Total Project VAT",
                                    controller.projectDetails!.totalProjectVAT),
                                _buildRow(
                                    "Total Project Value With VAT",
                                    controller.projectDetails!
                                        .totalProjectValueWithVAT),
                              ])
                            : const SizedBox(),
                        controller.projectEstimation != null
                            ? _buildSection("Estimation Details", [
                                _buildRow(
                                    "Initial Estimation Cost",
                                    controller
                                        .projectEstimation!.initialEstCost),
                                _buildRow("Variation",
                                    controller.projectEstimation!.variation),
                                _buildRow("Total Estimation Cost",
                                    controller.projectEstimation!.totalEstCost),
                                _buildRow("Total Actual Cost",
                                    controller.projectEstimation!.totalActCost),
                                _buildRow("Overhead",
                                    controller.projectEstimation!.overhead),
                              ])
                            : const SizedBox(),
                        controller.salesCollections != null
                            ? _buildSection("Sales Collection Details", [
                                _buildRow(
                                    "Collect Against Delivery",
                                    controller
                                        .salesCollections!.collectAgainstDel),
                                _buildRow(
                                    "Advance From Customer",
                                    controller
                                        .salesCollections!.advFromCustomer),
                                _buildRow(
                                    "Total Collection",
                                    controller
                                        .salesCollections!.totalCollection),
                                _buildRow(
                                    "Advance Invoice",
                                    controller
                                        .salesCollections!.advanceInvoice),
                              ])
                            : const SizedBox(),

                        /// Purchase collection details
                        controller.purchaseCollections != null
                            ? _buildSection("Purchase Collection Details", [
                                _buildRow(
                                    "Paid Against Delivery",
                                    controller
                                        .purchaseCollections!.paidAgainstDel),
                                _buildRow(
                                    "Advance Paid To Supplier",
                                    controller
                                        .purchaseCollections!.advPaidToSupp),
                                _buildRow("Paid From PV",
                                    controller.purchaseCollections!.paidFromPv),
                                _buildRow("Debit Note",
                                    controller.purchaseCollections!.debitNote),
                                _buildRow(
                                    "Reservation",
                                    controller
                                        .purchaseCollections!.reservation),
                                _buildRow(
                                    "Gross Total Paid",
                                    controller
                                        .purchaseCollections!.grossTotalPaid),
                                _buildRow(
                                    "Project Transfer",
                                    controller
                                        .purchaseCollections!.projectTransfer),
                                _buildRow("Total Paid",
                                    controller.purchaseCollections!.totalPaid),
                                _buildRow("Cash Flow",
                                    controller.purchaseCollections!.cashFlow),
                              ])
                            : const SizedBox(),

                        /// Sales receipt details
                        controller.salesReceipt != null
                            ? _buildSection("Sales Receipt Details", [
                                _buildRow("Total Sales Value",
                                    controller.salesReceipt!.totalSalesVal),
                                _buildRow(
                                    "Delivered SI With VAT",
                                    controller
                                        .salesReceipt!.delieveredSIWithVat),
                                _buildRow("Delivered SIW VAT",
                                    controller.salesReceipt!.delieveredSIWVat),
                                _buildRow(
                                    "Delivered Receivable",
                                    controller
                                        .salesReceipt!.delieveredReceivable),
                                _buildRow("Project Receivable",
                                    controller.salesReceipt!.projectReceivable),
                              ])
                            : const SizedBox(),

                        /// Profit and markup details
                        controller.profitAndMarkupDetails != null
                            ? _buildSection("Profit & Markup Details", [
                                _buildRow(
                                    "Total Estimated Profit",
                                    controller.profitAndMarkupDetails!
                                        .totalEstProfit),
                                _buildRow(
                                    "Total Actual Profit",
                                    controller.profitAndMarkupDetails!
                                        .totalActProfit),
                                _buildRow(
                                    "Estimated Margin",
                                    controller
                                        .profitAndMarkupDetails!.estMargin),
                                _buildRow(
                                    "Actual Margin",
                                    controller
                                        .profitAndMarkupDetails!.actMargin),
                                _buildRow(
                                    "Estimated Markup",
                                    controller
                                        .profitAndMarkupDetails!.estMarkup),
                                _buildRow(
                                    "Actual Markup",
                                    controller
                                        .profitAndMarkupDetails!.actMarkup),
                              ])
                            : const SizedBox(),

                        /// Profit and markup details
                        controller.purchasePaymentDetails != null
                            ? _buildSection("Purchase Payment Details", [
                                _buildRow(
                                    "Delivered PI",
                                    controller
                                        .purchasePaymentDetails!.delieveredPI),
                                _buildRow(
                                    "Payables Against PI",
                                    controller.purchasePaymentDetails!
                                        .payablesAgainstPI),
                                _buildRow(
                                    "Project Payables With VAT",
                                    controller.purchasePaymentDetails!
                                        .projectPayablesWithVAT),
                                _buildRow(
                                    "Exchange Rates",
                                    controller
                                        .purchasePaymentDetails!.exchangeRates),
                                _buildRow(
                                    "VAT Input",
                                    controller
                                        .purchasePaymentDetails!.vatInput),
                                _buildRow(
                                    "VAT Output",
                                    controller
                                        .purchasePaymentDetails!.vatOutput),
                                _buildRow("Net VAT",
                                    controller.purchasePaymentDetails!.netVat),
                              ])
                            : const SizedBox(),
                        const SizedBox(height: 25),
                        Text(
                          "Variations",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor),
                        ),
                        controller.variationsList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.variationsList.length,
                                itemBuilder: (context, index) {
                                  final variation =
                                      controller.variationsList[index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildRow("Transaction No",
                                              variation.transactionNo),
                                          _buildRow("LPO", variation.lpo),
                                          _buildRow("Date",
                                              formatDate(variation.date)),
                                          _buildRow("Sales", variation.sales),
                                          _buildRow("Cost", variation.cost),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  "No variations available",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87),
                                ),
                              ),

                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => PurchaseDetailsScreen(projectId: widget.projectId),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const ListTile(
                              title: Text(
                                "Purchase Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                              Get.to(
                              () => SalesDetailScreen(projectId: widget.projectId),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const ListTile(
                              title: Text(
                                "Sales Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                               Get.to(
                              () => OverheadDirectInvoiceScreen(projectId: widget.projectId),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const ListTile(
                              title: Text(
                                "Overhead Direct Invoice",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                              Get.to(
                              () => OverheadAgainstPvScreen(projectId: widget.projectId),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const ListTile(
                              title: Text(
                                "Overhead Against Direct PV",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                              Get.to(
                              () => JournalVoucherScreen(projectId: widget.projectId),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const ListTile(
                              title: Text(
                                "Journal Voucher",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  // Helper function to build a row with label and value
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

  // Helper function to build a collapsible section
  Widget _buildSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
          ),
        ),
        ...rows,
        const Divider(),
      ],
    );
  }

}
