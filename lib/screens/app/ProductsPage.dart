import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_cebimde/paginations/temporary_hold_of_information.dart';

class ProductsPage extends StatefulWidget {
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

TemporaryHoldOfInformation _temporaryHoldOfInformation = Get.put(TemporaryHoldOfInformation());
String _productName = _temporaryHoldOfInformation.temporaryInformationProducts.value[0];
String _productCategory = _temporaryHoldOfInformation.temporaryInformationProducts.value[1];
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: Text('${_temporaryHoldOfInformation.temporaryInformationProducts.value[0]}', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            StreamBuilder(
              stream: _firestore.collection("products").where("category", isEqualTo: _temporaryHoldOfInformation.temporaryInformationProducts.value[1]).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 190,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(snapshot.data!.docs[index].data()['productImageLink'], fit: BoxFit.cover),
                                      ),
                                      Center(child: Text(snapshot.data!.docs[index].data()['productName'] + " (${snapshot.data!.docs[index].data()["productWeight"]} " + "${snapshot.data!.docs[index].data()["productUnit"]})", style: TextStyle(fontFamily: "Montserrat", fontSize: 16), textAlign: TextAlign.center)),
                                      SizedBox(height: 10),
                                      Text("₺ " + snapshot.data!.docs[index].data()['productCost'].toString(), style: TextStyle(fontFamily: "Montserrat", fontSize: 17, color: Colors.blueAccent[700], fontWeight: FontWeight.bold), textAlign: TextAlign.center,),                                  
                                      SizedBox(height: 10),
                                      InkWell(
                                        child: Icon(Icons.add_box, color: Colors.blueAccent[700], size: 35,),
                                        onTap: () {
                                          _firestore.collection("users").doc(_auth.currentUser!.uid).collection("Shopping").doc().set(
                                            {
                                              "productName": snapshot.data!.docs[index].data()['productName'],
                                              "productCost": snapshot.data!.docs[index].data()['productCost'],
                                              "totalCost": snapshot.data!.docs[index].data()['productCost'],
                                              "productWeight": snapshot.data!.docs[index].data()['productWeight'],
                                              "productUnit": snapshot.data!.docs[index].data()['productUnit'],
                                              "productQuantity": 1,
                                            }
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}

/*
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: _firestore.collection("products").where("category", isEqualTo: _productCategory).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(snapshot.data!.docs[index].data()["productImageLink"]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(snapshot.data!.docs[index].data()["productName"]),
                            Text(snapshot.data!.docs[index].data()["productCost"]),
                            Text(snapshot.data!.docs[index].data()["category"]),
                            Text(snapshot.data!.docs[index].data()["productWeight"]),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
*/
