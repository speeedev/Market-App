import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryOrdersPage extends StatefulWidget {
  const HistoryOrdersPage({Key? key}) : super(key: key);

  @override
  State<HistoryOrdersPage> createState() => _HistoryOrdersPageState();
}

class _HistoryOrdersPageState extends State<HistoryOrdersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("HistoryOrders")
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        setState(() {
          final orderID = doc.data()["orderID"];
          debugPrint(orderID);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: const Text("Geçmiş Siparişler"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection("users")
                .doc(_auth.currentUser!.uid)
                .collection("HistoryOrders")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Geçmiş sipariş bulunmamaktadır."),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data!.docs[index];
                  final orderData = order.data() as Map<String, dynamic>;
                  final date = orderData["date"];
                  final totalCost = orderData["totalCost"];

                  return ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    trailing: Text(
                      "₺ $totalCost",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        color: Colors.blueAccent[700],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
