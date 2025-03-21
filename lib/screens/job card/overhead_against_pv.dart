import 'package:bizlogika_app/controllers/task_controller.dart';
import 'package:bizlogika_app/utils/common_widgets.dart';
import 'package:bizlogika_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverheadAgainstPvScreen extends StatefulWidget {
  const OverheadAgainstPvScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<OverheadAgainstPvScreen> createState() =>
      _OverheadAgainstPvScreenState();
}

class _OverheadAgainstPvScreenState extends State<OverheadAgainstPvScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Get.find<TaskController>()
        .fetchOverheadAgainstDirectPV(widget.projectId));
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
                        "Overhead Against Direct PV",
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
                        child: controller.overheadAgainstDirectPVList.isNotEmpty
                            ? ListView.builder(
                                itemCount: controller
                                    .overheadAgainstDirectPVList.length,
                                itemBuilder: (context, index) {
                                  final overhead = controller
                                      .overheadAgainstDirectPVList[index];

                                  return Card(
                                    elevation: 1,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildRow(
                                              "Voucher No", overhead.voucherNo),
                                          _buildRow("Date",
                                              formatDate(overhead.date)),
                                          _buildRow("Supplier Name",
                                              overhead.supplierName),
                                          _buildRow("Overhead code",
                                              overhead.overheadCode),
                                          _buildRow("Description",
                                              overhead.description),
                                          _buildRow("Estimated Amount",
                                              overhead.estAmt),
                                          _buildRow("Amount Settled",
                                              overhead.amtSettled),
                                          _buildRow(
                                              "Balance", overhead.balance),
                                          _buildRow("Total", overhead.total),
                                          _buildRow("Total with VA",
                                              overhead.totalWithVA),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  "No overhead available",
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
