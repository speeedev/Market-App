import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_state.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:market_cebimde/paginations/temporary_hold_of_information.dart';
import 'package:market_cebimde/screens/app/ProductsPage.dart';
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
List campaignSliderItems = [
  "assets/Campaign/campaignSlider1.png",
  "assets/Campaign/campaignSlider2.png",
  "assets/Campaign/campaignSlider3.png",
  "assets/Campaign/campaignSlider4.jpg",
  "assets/Campaign/campaignSlider1.png",
  "assets/Campaign/campaignSlider6.jpg",
];
TemporaryHoldOfInformation _temporaryHoldOfInformation = Get.put(TemporaryHoldOfInformation());
List <CategoryManager> Categories = [CategoryManager(icon: Icon(Icons.shopping_basket_outlined), name: "Meyve & Zebse"), CategoryManager(icon: Icon(Icons.shopping_basket_outlined), name: "Fırın"), CategoryManager(icon: Icon(Icons.shopping_basket_outlined), name: "Temel Gıda"), CategoryManager(icon: Icon(Icons.shopping_basket_outlined), name: "Süt Ürünleri"), CategoryManager(icon: Icon(Icons.shopping_basket_outlined), name: "Atıştırmalık"), CategoryManager(icon: Icon(Icons.shopping_basket_outlined), name: "Su & içecek"), CategoryManager(icon: Icon(Icons.shopping_basket_outlined), name: "Teknoloji")];
var searchLabels = ["Süt", "Yağ", "Mandalina", "Çikolatalı Gofret", "Yoğurt", "Ekmek"];
final _random = new Random();
var randomSearchLabel =  (searchLabels.toList()..shuffle()).first;
class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: const Text("Market Cebimde"),
        centerTitle: true,
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                  color: Colors.white,
                    width: 1,
                  ),
                ),
                margin: const EdgeInsets.only(right: 10),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Center(
                    child: Text("12 dk", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[200],
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIconColor: Colors.green[400],
                    prefixIcon: Icon(Icons.search),
                    label: Text(randomSearchLabel.toString()),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(255, 237, 237, 237),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(), // here
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: campaignSliderItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(campaignSliderItems[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Kategoriler", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: "Montserrat"),),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 503,
              child: ListView.builder(
                itemCount: Categories.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(), // here
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Categories[index].icon,
                    title: Text(Categories[index].name, style: TextStyle(fontSize: 18, fontFamily: "Montserrat"),),
                    onTap: () {
                      if (Categories[index].name == "Meyve & Sebze") {
                        _temporaryHoldOfInformation.temporaryInformationProducts.value = ["Meyve & Sebze", "FruitAndVegetable"];
                        Get.to(ProductsPage());
                      }
                      else if (Categories[index].name == "Fırın") {
                        _temporaryHoldOfInformation.temporaryInformationProducts.value = ["Fırın", "Bakery"];
                        Get.to(ProductsPage());
                      }
                      else if (Categories[index].name == "Temel Gıda") {
                        _temporaryHoldOfInformation.temporaryInformationProducts.value = ["Temel Gıda", "Food"];
                        Get.to(ProductsPage());
                      }
                      else if (Categories[index].name == "Süt Ürünleri") {
                        _temporaryHoldOfInformation.temporaryInformationProducts.value = ["Süt Ürünleri", "DairyProducts"];
                        Get.to(ProductsPage());
                      }
                      else if (Categories[index].name == "Atıştırmalık") {
                        _temporaryHoldOfInformation.temporaryInformationProducts.value = ["Atıştırmalık", "Snacks"];
                        Get.to(ProductsPage());
                      }
                      else if (Categories[index].name == "Su & içecek") {
                        _temporaryHoldOfInformation.temporaryInformationProducts.value = ["Su & içecek", "Waters"];
                        Get.to(ProductsPage());
                      }
                      else if (Categories[index].name == "Teknoloji") {
                        _temporaryHoldOfInformation.temporaryInformationProducts.value = ["Teknoloji", "Tech"];
                        Get.to(ProductsPage());
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryManager {
  final Icon icon;
  final String name;
  CategoryManager({required this.icon, required this.name});
  }