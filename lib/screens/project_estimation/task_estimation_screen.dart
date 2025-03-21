import 'package:bizlogika_app/controllers/auth_controller.dart';
import 'package:bizlogika_app/controllers/task_controller.dart';
import 'package:bizlogika_app/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';

class TaskEstimationScreen extends StatefulWidget {
  const TaskEstimationScreen(
      {super.key, required this.taskId, required this.docType});

  final String taskId;
  final String docType;

  @override
  State<TaskEstimationScreen> createState() => _TaskEstimationScreenState();
}

class _TaskEstimationScreenState extends State<TaskEstimationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Get.find<TaskController>()
        .fetchEstimation(widget.taskId, widget.docType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: GetBuilder<TaskController>(
        builder: (TaskController controller) {
          return controller.jobLoader
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
                                "Project Estimation",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        controller.taskEstimation != null
                            ? _buildSection(
                                Get.find<AuthController>()
                                    .userData!
                                    .companyName,
                                [
                                    _buildRow("Project",
                                        controller.taskEstimation!.project),
                                    _buildRow("Customer",
                                        controller.taskEstimation!.customer),
                                    _buildRow("Estimation",
                                        controller.taskEstimation!.estimation),
                                    _buildRow("Opportunity",
                                        controller.taskEstimation!.opportunity),
                                    _buildRow(
                                        "Date",
                                        formatDate(
                                            controller.taskEstimation!.date)),
                                    _buildRow(
                                        "Gross Project Value",
                                        controller
                                            .taskEstimation!.grossProjectValue),
                                    _buildRow("Discount",
                                        controller.taskEstimation!.discount),
                                    _buildRow("Output VAT",
                                        controller.taskEstimation!.outputVAT),
                                    _buildRow(
                                        "Project Value",
                                        controller
                                            .taskEstimation!.projectValue),
                                    _buildRow("Total Cost",
                                        controller.taskEstimation!.totalCost),
                                    _buildRow("Total Sales",
                                        controller.taskEstimation!.totalsales),
                                    _buildRow("Overheads",
                                        controller.taskEstimation!.overheads),
                                    _buildRow(
                                        "On Bill discount",
                                        controller
                                            .taskEstimation!.onBillDiscount),
                                    _buildRow("VAT over cost",
                                        controller.taskEstimation!.vatOverCost),
                                    _buildRow(
                                        "VAT actual sales",
                                        controller
                                            .taskEstimation!.vatActualSales),
                                    _buildRow(
                                        "Total over cost",
                                        controller
                                            .taskEstimation!.totalOverCost),
                                    _buildRow("Actual sales",
                                        controller.taskEstimation!.actualSales),
                                    _buildRow("Total markup",
                                        controller.taskEstimation!.totalMarkup),
                                    _buildRow(
                                        "Total markup %",
                                        controller.taskEstimation!
                                            .totalMarkupPercent),
                                    _buildRow("Remarks",
                                        controller.taskEstimation!.remarks),
                                  ])
                            : const SizedBox(),

                        const SizedBox(height: 25),
                        // Text(
                        //   "Variations",
                        //   style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w600,
                        //       color: primaryColor),
                        // ),
                        controller.estimatedItemsList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.estimatedItemsList.length,
                                itemBuilder: (context, index) {
                                  final estimation =
                                      controller.estimatedItemsList[index];
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
                                          _buildRow(
                                              "Item Code", estimation.itemCode),
                                          _buildRow("Description",
                                              estimation.description),
                                          _buildRow("Quantity",
                                              formatDate(estimation.quantity)),
                                          _buildRow("Unit", estimation.unit),
                                          _buildRow("Sales price",
                                              estimation.salesPrice),
                                          _buildRow("Sales Amount",
                                              estimation.salesAmount),
                                          _buildRow("Estimated cost",
                                              estimation.estimatedCost),
                                          _buildRow("Total Estimated cost",
                                              estimation.totalEstimatedCost),
                                          _buildRow(
                                              "Markup", estimation.markup),
                                          _buildRow("Markup %",
                                              estimation.markupPercent),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  "No data available",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87),
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
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
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
