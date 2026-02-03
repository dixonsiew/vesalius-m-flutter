import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:vesalius_m_flutter/components/app-shared.dart';
import 'package:vesalius_m_flutter/components/back_btn.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/cart_model.dart';

import 'package/cart.dart';
import 'package/package_detail.dart';

class Package extends StatefulWidget {

  static const String routeName = '/Package';

  const Package({Key? key}) : super(key: key);

  @override
  State<Package> createState() => _PackageState();
}

class _PackageState extends State<Package> {

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 21.0,
                  mainAxisSpacing: 20.0,
                  mainAxisExtent: 232.0,
                ),
                children: const [
                  PackageItem(
                    image: 'pck1.png',
                    name: 'Premier Health Screening Packages',
                    price: 670.00,
                  ),
                  PackageItem(
                    image: 'pck2.png',
                    name: 'Comprehensive Screening Package',
                    price: 988.00,
                  ),
                  PackageItem(
                    image: 'pck3.png',
                    name: 'Post Covid-19 Screening Package',
                    price: 450.00,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: Color(0xFFF8F8F8)),
        toolbarHeight: kAppToolbarHeight,
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: const Color(0xFFF8F8F8),
        leading: const BackBtn(color: Color(0xFF002E50)),
        centerTitle: true,
        title: Text(
          'Packages',
          style: kMainTextStyle.copyWith(
            fontSize: 16.0,
            color: const Color(0xFF002E50),
          ),
        ),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 23.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: Image.asset(
                    'images/icon/cart.png',
                    width: 21.33,
                    height: 18.91,
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    Get.to(() => const Cart());
                  },
                ),
                Positioned(
                  top: 6.0,
                  right: 8.0,
                  child: Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6BE7F),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Center(
                      child: Text(
                        '${context.watch<CartModel>().cartItemCount}',
                        style: kBodyTextStyle.copyWith(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: buildContent(),
      ),
    );
  }
}

class PackageItem extends StatelessWidget {
  
  final String image;
  final String name;
  final double price;

  const PackageItem({
    Key? key, 
    required this.image,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const PackageDetail());
      },
      child: Container(
        width: 152.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(219, 219, 219, 0.3),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'images/imgs/$image',
              width: 152.0,
              height: 152.0,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: kMainTextStyle.copyWith(
                  fontFamily: kBodyFont,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
              child: Text(
                'RM ${price.toStringAsFixed(2)}',
                style: kTitleTextStyle.copyWith(
                  fontSize: 16.0,
                  color: kMainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}