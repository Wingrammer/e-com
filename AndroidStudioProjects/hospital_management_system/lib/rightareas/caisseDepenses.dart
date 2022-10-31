import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_management_system/components/PricedListTile.dart';
import 'package:hospital_management_system/config/size_config.dart';
import 'package:hospital_management_system/data.dart';
import 'package:hospital_management_system/models/invoice.dart';
import 'package:hospital_management_system/models/product.dart';
import 'package:hospital_management_system/models/productEntry.dart';
import 'package:hospital_management_system/providers/drawer_provider.dart';
import 'package:hospital_management_system/providers/invoice_provider.dart';
import 'package:hospital_management_system/providers/product_entry_provider.dart';
import 'package:hospital_management_system/providers/product_provider.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';

class CaisseDepenseRightArea extends StatefulWidget {
  const CaisseDepenseRightArea({
    Key? key,
  }) : super(key: key);

  @override
  State<CaisseDepenseRightArea> createState() => _CaisseDepenseRightAreaState();
}

class _CaisseDepenseRightAreaState extends State<CaisseDepenseRightArea> {
  Invoice? selected;
  List<ProductEntry> entries = [];
  List<Product> products = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      entries = Provider.of<ProductEntryProvider>(context, listen: false).state["productEntries"];
      products = Provider.of<ProductProvider>(context, listen: false).state["products"];
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(builder: (_, state, __) {
      selected = state.state["selected"];
      List<ProductEntry> selectedProducts = entries.where((element) => element.facture==selected!.reference).toList();
      return Column(
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical * 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryText(
                  text: selected!.vendeur ?? '',
                  size: 18,
                  fontWeight: FontWeight.w800),
              PrimaryText(
                text: selected!.reference ?? '',
                size: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary,
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Column(
            children: List.generate(
              selectedProducts.length,
                  (index) =>
                  PricedListTile(
                      quantity: selectedProducts[index].quantite ?? '',
                      label: jsonDecode('${selectedProducts[index].produit}')["Nom"] ?? '',
                      spec: jsonDecode('${selectedProducts[index].produit}')["Categorie"] ?? '',
                      amount: selectedProducts[index].buyingPrice ?? ''
                  ),
            ),
          ),
        ],
      );
    });
  }

  String getProductName(String? id){
    List<Product> selectedProduct = products.where((element) => element.fid==id).toList();
    if(selectedProduct.isNotEmpty){
      return '${selectedProduct[0].nom}';
    }
    return "";
  }

}