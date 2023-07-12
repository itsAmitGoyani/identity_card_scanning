class EntryReceiptModel {
  String receiptId;

  EntryReceiptModel(this.receiptId);

  EntryReceiptModel.fromJson(Map<String, dynamic> json)
      : receiptId = json['receiptId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['receiptId'] = receiptId;
    return data;
  }
}
