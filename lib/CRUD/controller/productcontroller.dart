import 'dart:convert';

import 'package:crudapp/CRUD/model/productModel.dart';
import 'package:crudapp/CRUD/utils/urls.dart';
import 'package:http/http.dart' as http;

class ProductController{
  List <Datum> products=[];

  Future<void> getProduct()async {
    final url=Uri.parse(Urls.readProduct);
    final response=await http.get(url);
    // print('Api url=$url');
    // print('Status Code=${response.statusCode}');
    // print('Response Body=${response.body}');

    if(response.statusCode==200){
      final jsonResponse=jsonDecode(response.body);
      ProductModel model=ProductModel.fromJson(jsonResponse);
      products=model.data??[];
    }

  }
  Future<bool>deleteProduct(String productId) async {
    final url=Uri.parse(Urls.deleteProduct(productId));
    final response=await http.get(url);

    if(response.statusCode==200){
      await getProduct();
      return true;
    }else{
      return false;
    }
  }

  Future<bool>createProduct(Datum data) async {
    final url=Uri.parse(Urls.createProduct);
    final response= await http.post(url,

        headers: {'Content-Type': 'application/json'},
    body: jsonEncode(
        {
          "ProductName": data.productName,
          'ProductCode':DateTime.now().microsecondsSinceEpoch,
          "Img": data.img,
          "Qty": data.qty,
          "UnitPrice": data.unitPrice,
          "TotalPrice": data.totalPrice,
        }
   )
    );
    if(response.statusCode==200){
      getProduct();
      return true;
    }else{
      return false;
    }
  }

  Future<bool>updateProduct(String productID, Datum data) async {
    final url=Uri.parse(Urls.updateProduct(productID));
    final response=await http.post(url,

      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {
            "ProductName": data.productName,
            'ProductCode':DateTime.now().microsecondsSinceEpoch,
            "Img": data.img,
            "Qty": data.qty,
            "UnitPrice": data.unitPrice,
            "TotalPrice": data.totalPrice,
          }
      ),
    );
    if(response.statusCode==200){
      getProduct();
      return true;
    }else{
      return false;
    }
  }
}