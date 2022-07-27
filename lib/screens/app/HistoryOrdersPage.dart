import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryOrdersPage extends StatefulWidget {
  HistoryOrdersPage({Key? key}) : super(key: key);
  @override
  State<HistoryOrdersPage> createState() => _HistoryOrdersPageState();
}

class _HistoryOrdersPageState extends State<HistoryOrdersPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String orderID = "";
  @override
  void initState() {
    super.initState();
    _firestore.collection("users").doc(_auth.currentUser!.uid).collection("HistoryOrders").snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        setState(() {
          orderID = doc.data()["orderID"];
          inspect(orderID);
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: Text("Geçmiş Siparişler"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: StreamBuilder(
            stream: _firestore.collection("users").doc(_auth.currentUser!.uid).collection("HistoryOrders").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.shopping_bag_outlined),
                      title: Text(snapshot.data!.docs[index].data()["date"], style: TextStyle(fontSize: 16, fontFamily: "Montserrat")),
                      trailing: Text("₺ " + snapshot.data!.docs[index].data()["totalCost"].toString(), style: TextStyle(fontSize: 16, fontFamily: "Montserrat", color: Colors.blueAccent[700])),
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
        ),
      ),
    );
  }
}