import 'dart:convert';

import 'package:crudapp/CRUD/controller/productcontroller.dart';
import 'package:crudapp/CRUD/model/productModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {

  ProductController productController=ProductController();
  Future fetchData() async {
    await productController.getProduct();
    if(mounted){
      setState(() {

      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  productDialog(bool isUpdate,{Datum? data}){
    TextEditingController productNameController=TextEditingController();
    TextEditingController productIMGController=TextEditingController();
    TextEditingController productQTYController=TextEditingController();
    TextEditingController productUnitPriceController=TextEditingController();
    TextEditingController productTotalPriceController=TextEditingController();

    if(isUpdate){
      productNameController.text=data!.productName.toString();
      productIMGController.text=data.img.toString();
      productQTYController.text=data.qty.toString();
      productUnitPriceController.text=data.unitPrice.toString();
      productTotalPriceController.text=data.totalPrice.toString();
    }

    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(isUpdate?'Update product':'Add product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: 'name'),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: productIMGController,
              decoration: InputDecoration(labelText: 'image'),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: productQTYController,
              decoration: InputDecoration(labelText: 'QTY'),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: productUnitPriceController,
              decoration: InputDecoration(labelText: 'Unit Price'),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: productTotalPriceController,
              decoration: InputDecoration(labelText: 'Total Price'),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Cancel')),
                ElevatedButton(onPressed: () async {
                  if(isUpdate){
                    await productController.updateProduct(data!.id.toString(),Datum(
                      productName: productNameController.text,
                      img: productIMGController.text,
                      qty: int.parse(productQTYController.text),
                      unitPrice: int.parse(productUnitPriceController.text),
                      totalPrice: int.parse(productTotalPriceController.text),
                    ));
                  }else{
                    await productController.createProduct(Datum(
                      productName: productNameController.text,
                      img: productIMGController.text,
                      qty: int.parse(productQTYController.text),
                      unitPrice: int.parse(productUnitPriceController.text),
                      totalPrice: int.parse(productTotalPriceController.text),
                    ));
                  }
                  Navigator.pop(context);
                  await fetchData();
                }, child: Text('Submit')),
              ],
            ),
          ],
        ),
      ),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD'),
      ),
      body:GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
          crossAxisSpacing: 4,
            childAspectRatio: 0.78,
          ),
          itemCount: productController.products.length,
          itemBuilder: (context, index){
            final item = productController.products[index];
            return Card(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.network(
                        item.img.toString() ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                    Text(item.productName.toString(),),
                    Text('Price:${item.unitPrice}'),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: (){
                          productDialog(true, data: item);
                        }, icon: Icon(Icons.edit,color: Colors.green,)),

                        IconButton(onPressed: () {
                          print('Delete ID: ${item.id}');
                          productController.deleteProduct(item.id.toString()).then((value) async {
                            await fetchData();

                            if(value){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Product deleted')),
                              );
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('something wrong....'))
                            );
                            }
                          });
                        }, icon: Icon(Icons.delete,color: Colors.red,)),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        productDialog(false);
      },child: Icon(Icons.add),),
    );
  }
}
