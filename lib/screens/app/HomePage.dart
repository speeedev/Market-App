import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imgur/core/controller/paginations/temporary_hold_of_information.dart';
import 'package:imgur/core/models/category_model.dart';
import 'package:imgur/screens/app/ProductsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TemporaryHoldOfInformation _temporaryHoldOfInformation =
      Get.put(TemporaryHoldOfInformation());
  final List<String> campaignSliderItems = List.of([
    "assets/Campaign/campaignSlider1.png",
    "assets/Campaign/campaignSlider2.png",
    "assets/Campaign/campaignSlider3.png",
    "assets/Campaign/campaignSlider4.jpg",
    "assets/Campaign/campaignSlider1.png",
    "assets/Campaign/campaignSlider6.jpg",
  ]);

  final List<CategoryModel> categories = [
    CategoryModel(
        icon: const Icon(Icons.shopping_basket_outlined),
        name: "Meyve & Zebse"),
    CategoryModel(
        icon: const Icon(Icons.shopping_basket_outlined), name: "Fırın"),
    // Add other categories here
  ];

  final List<String> searchLabels = [
    "Süt",
    "Yağ",
    "Mandalina",
    "Çikolatalı Gofret",
    "Yoğurt",
    "Ekmek"
  ];
  late final String randomSearchLabel =
      (searchLabels.toList()..shuffle()).first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCampaignSlider(),
            const SizedBox(height: 10),
            _buildCategoryTitle(),
            _buildCategoryList(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent[700],
      title: const Text("Market Cebimde"),
      centerTitle: true,
      elevation: 0,
      actions: [_buildAppBarAction()],
    );
  }

  Widget _buildAppBarAction() {
    return Container(
      width: 70,
      height: 30,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: const Center(
        child: Text("12 dk",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey[200],
        child: TextFormField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            label: Text(randomSearchLabel),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignSlider() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 237, 237, 237),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: campaignSliderItems.length,
        itemBuilder: (context, index) => _buildSliderItem(index),
      ),
    );
  }

  Widget _buildSliderItem(int index) {
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
  }

  Widget _buildCategoryTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 8),
      child: Text(
        "Kategoriler",
        style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: "Montserrat"),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 503,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) => _buildCategoryItem(categories[index]),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return ListTile(
      leading: category.icon,
      title: Text(category.name,
          style: const TextStyle(fontSize: 18, fontFamily: "Montserrat")),
      onTap: () => _navigateToProductsPage(category.name),
    );
  }

  void _navigateToProductsPage(String categoryName) {
    _temporaryHoldOfInformation.temporaryInformationProducts.value = [
      categoryName,
      "${categoryName}Products"
    ];
    Get.to(const ProductsPage());
  }
}
