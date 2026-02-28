
class ProductModel {
  ProductModel({
    required this.status,
    required this.data,
  });

  final String? status;
  final List<Datum> data;

  factory ProductModel.fromJson(Map<String, dynamic> json){
    return ProductModel(
      status: json["status"],
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}

class Datum {
  Datum({
    this.id,
    required this.productName,
    this.productCode,
    required this.img,
    required this.qty,
    required this.unitPrice,
    required this.totalPrice,
  });

  final String? id;
  final String? productName;
  final int? productCode;
  final String? img;
  final int? qty;
  final int? unitPrice;
  final int? totalPrice;

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      id: json["_id"],
      productName: json["ProductName"],
      productCode: json["ProductCode"],
      img: json["Img"],
      qty: json["Qty"],
      unitPrice: json["UnitPrice"],
      totalPrice: json["TotalPrice"],

    );
  }

}
