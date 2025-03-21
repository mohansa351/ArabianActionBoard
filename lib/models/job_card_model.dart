class ProjectDetailsModel {
  const ProjectDetailsModel({
    required this.projectCode,
    required this.projectName,
    required this.clientName,
    required this.salesOrderNumber,
    required this.maxRevisionNo,
    required this.salesOrderDate,
    required this.lpo,
    required this.currency,
    required this.exchangeRate,
    required this.initialProjectValue,
    required this.variation,
    required this.totalProjectValue,
    required this.totalProjectVAT,
    required this.totalProjectValueWithVAT,
  });

  final String projectCode;
  final String projectName;
  final String clientName;
  final String salesOrderNumber;
  final String maxRevisionNo;
  final String salesOrderDate;
  final String lpo;
  final String currency;
  final String exchangeRate;
  final String initialProjectValue;
  final String variation;
  final String totalProjectValue;
  final String totalProjectVAT;
  final String totalProjectValueWithVAT;
}

class ProjectEstimationModel {
  const ProjectEstimationModel({
    required this.initialEstCost,
    required this.variation,
    required this.totalEstCost,
    required this.totalActCost,
    required this.overhead,
  });

  final String initialEstCost;
  final String variation;
  final String totalEstCost;
  final String totalActCost;
  final String overhead;
}

class SalesCollectionModel {
  const SalesCollectionModel({
    required this.collectAgainstDel,
    required this.advFromCustomer,
    required this.totalCollection,
    required this.advanceInvoice,
  });

  final String collectAgainstDel;
  final String advFromCustomer;
  final String totalCollection;
  final String advanceInvoice;
}

class PurchaseCollectionModel {
  const PurchaseCollectionModel({
    required this.paidAgainstDel,
    required this.advPaidToSupp,
    required this.paidFromPv,
    required this.debitNote,
    required this.reservation,
    required this.grossTotalPaid,
    required this.projectTransfer,
    required this.totalPaid,
    required this.cashFlow,
  });

  final String paidAgainstDel;
  final String advPaidToSupp;
  final String paidFromPv;
  final String debitNote;
  final String reservation;
  final String grossTotalPaid;
  final String projectTransfer;
  final String totalPaid;
  final String cashFlow;
}

class VariationsModel {
  const VariationsModel({
    required this.transactionNo,
    required this.lpo,
    required this.date,
    required this.sales,
    required this.cost,
  });

  final String transactionNo;
  final String lpo;
  final String date;
  final String sales;
  final String cost;
}

class SalesReceiptModel {
  const SalesReceiptModel({
    required this.totalSalesVal,
    required this.delieveredSIWVat,
    required this.delieveredSIWithVat,
    required this.delieveredReceivable,
    required this.projectReceivable,
  });

  final String totalSalesVal;
  final String delieveredSIWVat;
  final String delieveredSIWithVat;
  final String delieveredReceivable;
  final String projectReceivable;
}

class ProfitAndMarkupDetails {
  const ProfitAndMarkupDetails({
    required this.totalEstProfit,
    required this.totalActProfit,
    required this.estMargin,
    required this.actMargin,
    required this.estMarkup,
    required this.actMarkup,
  });

  final String totalEstProfit;
  final String totalActProfit;
  final String estMargin;
  final String actMargin;
  final String estMarkup;
  final String actMarkup;
}

class PurchasePaymentDetails {
  const PurchasePaymentDetails({
    required this.delieveredPI,
    required this.payablesAgainstPI,
    required this.projectPayablesWithVAT,
    required this.exchangeRates,
    required this.vatInput,
    required this.vatOutput,
    required this.netVat,
  });

  final String delieveredPI;
  final String payablesAgainstPI;
  final String projectPayablesWithVAT;
  final String exchangeRates;
  final String vatInput;
  final String vatOutput;
  final String netVat;
}

class PurchaseDetails {
  const PurchaseDetails({
    required this.orderRef,
    required this.date,
    required this.supplierName,
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.budgetValue,
    required this.foreignOrder,
    required this.orderAmt,
    required this.amtSettled,
    required this.balance,
  });

  final String orderRef;
  final String date;
  final String supplierName;
  final String itemCode;
  final String description;
  final String quantity;
  final String unitPrice;
  final String budgetValue;
  final String foreignOrder;
  final String orderAmt;
  final String amtSettled;
  final String balance;
}

class ReceiptsCollected {
  const ReceiptsCollected({
    required this.transactionNo,
    required this.againstReference,
    required this.amount,
  });

  final String transactionNo;
  final String againstReference;
  final String amount;
}

class InvoicesNotIssued {
  const InvoicesNotIssued({
    required this.transactionNo,
    required this.status,
    required this.amount,
  });

  final String transactionNo;
  final String status;
  final String amount;
}

class PendingInvoices {
  const PendingInvoices(
      {required this.transactionNo,
      required this.balance,
      required this.amount,
      required this.status});

  final String transactionNo;
  final String balance;
  final String amount;
  final String status;
}

class PendingSO {
  const PendingSO(
      {required this.transactionNo,
      required this.transactionDate,
      required this.pendingAmt,
      required this.status});

  final String transactionNo;
  final String transactionDate;
  final String pendingAmt;
  final String status;
}

class OverheadDirectInvoice {
  const OverheadDirectInvoice({
    required this.orderRef,
    required this.date,
    required this.supplierName,
    required this.itemCode,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.budgetValue,
    required this.foreignOrder,
    required this.orderAmt,
    required this.amtSettled,
    required this.balance,
  });

  final String orderRef;
  final String date;
  final String supplierName;
  final String itemCode;
  final String description;
  final String quantity;
  final String unitPrice;
  final String budgetValue;
  final String foreignOrder;
  final String orderAmt;
  final String amtSettled;
  final String balance;
}


class OverheadAgainstDirectPV {
  const OverheadAgainstDirectPV({
    required this.voucherNo,
    required this.date,
    required this.supplierName,
    required this.overheadCode,
    required this.description,
    required this.estAmt,
    required this.amtSettled,
    required this.balance,
    required this.total,
    required this.totalWithVA,
  });

  final String voucherNo;
  final String date;
  final String supplierName;
  final String overheadCode;
  final String description;
  final String estAmt;
  final String amtSettled;
  final String balance;
  final String total;
  final String totalWithVA;
}



class JournalVoucher {
  const JournalVoucher({
    required this.voucherNo,
    required this.date,
    required this.supplierName,
    required this.overheadCode,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  final String voucherNo;
  final String date;
  final String supplierName;
  final String overheadCode;
  final String description;
  final String debit;
  final String credit;
  final String balance;
}