import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imgur/core/controller/paginations/page_index_pagination.dart';
import 'package:imgur/screens/app/HomePage.dart';
import 'package:imgur/screens/app/ProfilePage.dart';
import 'package:imgur/screens/app/ShoppingPage.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final PageIndexPaginationController pageIndexPaginationController =
      Get.find();

  final List<Widget> pages = [
    HomePage(),
    const ShoppingPage(),
    const ProfilePage(),
  ];

  void _changePage(int index) {
    setState(() {
      pageIndexPaginationController.pageIndex.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[pageIndexPaginationController.pageIndex.value]),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.blueAccent[700]),
        child: BottomNavigationBar(
          currentIndex: pageIndexPaginationController.pageIndex.value,
          onTap: _changePage,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          items: const [
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
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}
