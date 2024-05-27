import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imgur/core/controller/paginations/temporary_hold_of_information.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TemporaryHoldOfInformation _temporaryHoldOfInformation = Get.put(TemporaryHoldOfInformation());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: Text(
          _temporaryHoldOfInformation.temporaryInformationProducts.value[0],
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("products")
                  .where("category", isEqualTo: _temporaryHoldOfInformation.temporaryInformationProducts.value[1])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Ürün bulunamadı."),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 190,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    final productName = product['productName'];
                    final productImageLink = product['productImageLink'];
                    final productWeight = product['productWeight'];
                    final productUnit = product['productUnit'];
                    final productCost = product['productCost'];

                    return SizedBox(
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
                                      child: Image.network(productImageLink, fit: BoxFit.cover),
                                    ),
                                    Center(
                                      child: Text(
                                        "$productName ($productWeight $productUnit)",
                                        style: const TextStyle(fontFamily: "Montserrat", fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "₺ $productCost",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 17,
                                        color: Colors.blueAccent[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      child: Icon(
                                        Icons.add_box,
                                        color: Colors.blueAccent[700],
                                        size: 35,
                                      ),
                                      onTap: () {
                                        _firestore
                                            .collection("users")
                                            .doc(_auth.currentUser!.uid)
                                            .collection("Shopping")
                                            .add({
                                          "productName": productName,
                                          "productCost": productCost,
                                          "totalCost": productCost,
                                          "productWeight": productWeight,
                                          "productUnit": productUnit,
                                          "productQuantity": 1,
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
