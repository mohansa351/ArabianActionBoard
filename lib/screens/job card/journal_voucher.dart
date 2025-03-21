import 'package:bizlogika_app/controllers/task_controller.dart';
import 'package:bizlogika_app/utils/common_widgets.dart';
import 'package:bizlogika_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalVoucherScreen extends StatefulWidget {
  const JournalVoucherScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<JournalVoucherScreen> createState() => _JournalVoucherScreenState();
}

class _JournalVoucherScreenState extends State<JournalVoucherScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Get.find<TaskController>().fetchJournalVoucher(widget.projectId));
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
                        "Journal Vouchers",
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
                        child: controller.journalVoucherList.isNotEmpty
                            ? ListView.builder(
                                itemCount: controller.journalVoucherList.length,
                                itemBuilder: (context, index) {
                                  final journal =
                                      controller.journalVoucherList[index];

                                  return Column(
                                    children: [
                                      journal.voucherNo == ""
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                Divider(
                                                    color: primaryColor,
                                                    thickness: 2),
                                                const SizedBox(height: 15),
                                                _buildRow("Voucher No",
                                                    journal.voucherNo),
                                                _buildRow("Date",
                                                    formatDate(journal.date)),
                                                _buildRow("Remarks", ""),
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
                                          padding: EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildRow("Supplier Name",
                                                  journal.supplierName),
                                              _buildRow("Overhead code",
                                                  journal.overheadCode),
                                              _buildRow("Description",
                                                  journal.description),
                                              _buildRow("Debit", journal.debit),
                                              _buildRow(
                                                  "Credit", journal.credit),
                                              _buildRow(
                                                  "Balance", journal.balance),
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
                                  "No voucher available",
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
