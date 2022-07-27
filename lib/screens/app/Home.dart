import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_cebimde/paginations/page_index_pagination.dart';
import 'package:market_cebimde/screens/app/HomePage.dart';
import 'package:market_cebimde/screens/app/ProfilePage.dart';
import 'package:market_cebimde/screens/app/ShoppingPage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

PageIndexPaginationController _pageIndexPaginationController = Get.put(PageIndexPaginationController());
int pageIndex = _pageIndexPaginationController.pageIndex.value;
final pages = [
  HomePage(),
  ShoppingPage(),
  ProfilePage(),
];

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);
  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  void changePage(int index) {
    setState(() {
      _pageIndexPaginationController.pageIndex.value = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_pageIndexPaginationController.pageIndex.value],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.blueAccent[700]),
        child: BottomNavigationBar(
          currentIndex: _pageIndexPaginationController.pageIndex.value,
          onTap: changePage,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Ana Sayfa",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Sepet",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil"
            ),
          ],
        ),
      ),
    );
  }
}