import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imgur/utils/modern_alert.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double _totalCost = 0;
  List<String> products = [];
  final DateTime _date = DateTime.now();
  late String fullDate;

  @override
  void initState() {
    super.initState();
    _calculateTotalCost();
  }

  void _calculateTotalCost() {
    _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("Shopping")
        .snapshots()
        .listen((snapshot) {
      double total = 0;
      for (var doc in snapshot.docs) {
        total += doc.data()["totalCost"];
      }
      setState(() {
        _totalCost = total;
      });
    });
  }

  void _clearCart() {
    _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("Shopping")
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  void _addToOrderHistory() {
    _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("HistoryOrders")
        .add({
      "orderID": DateTime.now().toString(),
      "products": products,
      "totalCost": _totalCost,
      "date": fullDate,
    });
  }

  void _placeOrder() {
    setState(() {
      fullDate = "${_date.day}/${_date.month}/${_date.year}";
    });
    if (_totalCost == 0) {
      ModernAlert(context, "Hata", "Sepetinizde bir ürün yok.", "Tamam", () {});
    } else {
      _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("Shopping")
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          products.add(doc.data()["productID"]);
        }
        _clearCart();
        Timer(const Duration(seconds: 1), () {
          _addToOrderHistory();
          ModernAlert(context, "Başarılı", "Siparişiniz başarıyla alındı",
              "Tamam", () {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: const Text("Sepet"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearCart,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("Sepet",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: _firestore
                    .collection("users")
                    .doc(_auth.currentUser!.uid)
                    .collection("Shopping")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data!.docs[index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(product["productImageLink"]),
                            title: Text(product["productName"]),
                            subtitle: Text(product["totalCost"].toString()),
                            trailing: _buildQuantityControls(product),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Sepetiniz boş"));
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent[700],
        icon: const Icon(Icons.shopping_cart),
        label: Text('Sipariş Ver: ₺$_totalCost',
            style: const TextStyle(fontSize: 20)),
        onPressed: _placeOrder,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildQuantityControls(DocumentSnapshot product) {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              product.reference.update({
                "productQuantity": product["productQuantity"] + 1,
                "totalCost": product["totalCost"] + product["productCost"],
              });
              setState(() {
                _totalCost += product["productCost"];
              });
            },
          ),
          Text(product["productQuantity"].toString()),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (product["productQuantity"] == 0) {
                product.reference.delete();
              } else {
                product.reference.update({
                  "productQuantity": product["productQuantity"] - 1,
                  "totalCost": product["totalCost"] - product["productCost"],
                });
                setState(() {
                  _totalCost -= product["productCost"];
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
