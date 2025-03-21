///// Task Estimation model

class TaskEstimationModel {
  TaskEstimationModel({
    required this.project,
    required this.customer,
    required this.estimation,
    required this.opportunity,
    required this.date,
    required this.grossProjectValue,
    required this.discount,
    required this.outputVAT,
    required this.projectValue,
    required this.totalCost,
    required this.totalsales,
    required this.overheads,
    required this.onBillDiscount,
    required this.vatOverCost,
    required this.vatActualSales,
    required this.totalOverCost,
    required this.actualSales,
    required this.totalMarkup,
    required this.totalMarkupPercent,
    required this.remarks,
  });


  final String project;
  final String customer;
  final String estimation;
  final String opportunity;
  final String date;
  final String grossProjectValue;
  final String discount;
  final String outputVAT;
  final String projectValue;
  final String totalCost;
  final String totalsales;
  final String overheads;
  final String onBillDiscount;
  final String vatOverCost;
  final String vatActualSales;
  final String totalOverCost;
  final String actualSales;
  final String remarks;
  final String totalMarkup;
  final String totalMarkupPercent;
}

////
class TaskItemModel {
  TaskItemModel({
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.salesAmount,
    required this.salesPrice,
    required this.estimatedCost,
    required this.totalEstimatedCost,
    required this.markup,
    required this.markupPercent,
  });

  final String itemCode;
  final String description;
  final String quantity;
  final String unit;
  final String salesPrice;
  final String salesAmount;
  final String estimatedCost;
  final String totalEstimatedCost;
  final String markup;
  final String markupPercent;

}
