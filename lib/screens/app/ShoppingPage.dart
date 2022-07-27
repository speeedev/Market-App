import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_cebimde/functions/modern_alert.dart';
import 'package:market_cebimde/main.dart';
import 'package:market_cebimde/screens/app/HomePage.dart';

class ShoppingPage extends StatefulWidget {
  ShoppingPage({Key? key}) : super(key: key);
  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  double _totalCost = 0;
  List products = [];
  DateTime _date = DateTime.now();
  int? day;
  int? month;
  int? year;
  String? fullDate;
  @override
  void initState() {
    super.initState();
    _firestore.collection("users").doc(_auth.currentUser!.uid).collection("Shopping").snapshots().listen((snapshot) {
        _totalCost = 0;
        setState(() {
          for (var doc in snapshot.docs) {
            _totalCost += doc.data()["totalCost"];
          }
        });
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: Text("Sepet"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _firestore.collection("users").doc(_auth.currentUser!.uid).collection("Shopping").snapshots().listen((snapshot) {
                snapshot.docs.forEach((doc) {
                  doc.reference.delete();
                });
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("Sepet", style: TextStyle(fontSize: 30, fontFamily: "Montserrat", fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              StreamBuilder(
                stream: _firestore.collection("users").doc(_auth.currentUser!.uid).collection("Shopping").snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // here
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(snapshot.data!.docs[index].data()["productImageLink"]),
                            title: Text(snapshot.data!.docs[index].data()["productName"]),
                            subtitle: Text(snapshot.data!.docs[index].data()["totalCost"].toString()),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      snapshot.data!.docs[index].reference.update({
                                        "productQuantity": snapshot.data!.docs[index].data()["productQuantity"] + 1,
                                        "totalCost": snapshot.data!.docs[index].data()["totalCost"] + snapshot.data!.docs[index].data()["productCost"],
                                      });
                                      setState(() {
                                        _totalCost += snapshot.data!.docs[index].data()["productCost"];
                                      });
                                    },
                                  ),
                                  Text(snapshot.data!.docs[index].data()["productQuantity"].toString()),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      if (snapshot.data!.docs[index].data()["productQuantity"] == 0) {
                                        snapshot.data!.docs[index].reference.delete();
                                      }
                                      else {
                                        snapshot.data!.docs[index].reference.update({
                                          "productQuantity": snapshot.data!.docs[index].data()["productQuantity"] - 1,
                                          "totalCost": snapshot.data!.docs[index].data()["totalCost"] - snapshot.data!.docs[index].data()["productCost"],
                                        });
                                        setState(() {
                                          _totalCost -= snapshot.data!.docs[index].data()["productCost"];
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text("Sepetiniz boş"),
                    );
                  }
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent[700],
        icon: const Icon(Icons.shopping_cart),
        label: Text('Sipariş Ver: ₺${_totalCost}', style: TextStyle(fontSize: 20)),
        onPressed: () {
          products.clear();
          setState(() {
            day = _date.day;
            month = _date.month;
            year = _date.year;
            fullDate = "${day}/${month}/${year}";
          });
          _firestore.collection("users").doc(_auth.currentUser!.uid).collection("Shopping").snapshots().listen((snapshot) {
            setState(() {
              for (var doc in snapshot.docs) {
                products.add(doc.data()["productID"]);
              }
            });
          });
          if (_totalCost == 0) {
            ModernAlert(
              context,
              "Hata",
              "Sepetinizde bir ürün yok.",
              "Tamam",
              () {
              },
            );
          } else {
            _firestore.collection("users").doc(_auth.currentUser!.uid).collection("Shopping").snapshots().listen((snapshot) {
              snapshot.docs.forEach((doc) {
                doc.reference.delete();
              });
            });
            Timer(Duration(seconds: 1), () {
              firestore.collection("users").doc(_auth.currentUser!.uid).collection("HistoryOrders").add({
                "orderID": DateTime.now().toString(),
                "products": products,
                "totalCost": _totalCost,
                "date": fullDate,
              });
              ModernAlert(
                context,
                "Başarılı",
                "Siparişiniz başarıyla alındı",
                "Tamam",
                () {
                },
              );
            });
              Timer(Duration(seconds: 1500), () {
                _firestore.collection("users").doc(_auth.currentUser!.uid).collection("Shopping").snapshots().listen((snapshot) {
                  snapshot.docs.forEach((doc) {
                    doc.reference.delete();
                  });
                });
              });
            }
          },
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}