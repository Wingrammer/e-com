import 'package:flutter/material.dart';
import 'package:hospital_management_system/models/product.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';

class ProductForm extends StatefulWidget {
  final Product initialProduct;
  const ProductForm({Key? key, required this.initialProduct}) : super(key: key);

  @override
  State<ProductForm> createState() => ProductFormState();
}

class ProductFormState extends State<ProductForm> {

  final formKey = GlobalKey<FormState>();
  bool _dateValid = false;
  bool _referenceValid = false;
  bool _vendeurValid = false;
  bool _totalValid = false;

  final dateController = TextEditingController();
  final referenceController = TextEditingController();
  final vendeurController = TextEditingController();
  final totalController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalController.value = TextEditingValue(
      text: widget.initialProduct.total,
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.initialProduct.total.length),
      ),
    );
    dateController.value = TextEditingValue(
      text: widget.initialProduct.date,
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.initialProduct.date.length),
      ),
    );
    referenceController.value = TextEditingValue(
      text: widget.initialProduct.reference,
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.initialProduct.reference.length),
      ),
    );
    vendeurController.value = TextEditingValue(
      text: widget.initialProduct.vendeur,
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.initialProduct.vendeur.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Date',
                  style: ralewayStyle.copyWith(
                    fontSize: 12.0,
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                height: 50.0,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.whiteColor,
                ),
                child: TextFormField(
                  controller: dateController,
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                    fontSize: 15.0,
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      _dateValid = false;
                      return 'Ce champ est obligatoire';
                    }
                    try{
                      DateTime.parse(value.split('/').reversed.join('-'));
                      _dateValid = true;
                    } catch(e){
                      _dateValid = false;
                      return 'Format invalide (jj/mm/yyyy)';
                    }
                    _dateValid = true;
                    return null;
                  },
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.date_range),
                    contentPadding: const EdgeInsets.only(top: 16.0),
                    hintText: 'Entrer la date (jj/mm/yyyy)',
                    hintStyle: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.green.withOpacity(0.7),
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.014),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Référence',
                  style: ralewayStyle.copyWith(
                    fontSize: 12.0,
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                height: 50.0,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.whiteColor,
                ),
                child: TextFormField(
                  controller: referenceController,
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                    fontSize: 15.0,
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      _referenceValid = false;
                      return 'Ce champ est obligatoire';
                    }
                    if (!value.startsWith('FM')){
                      _referenceValid = false;
                      return 'Doit commence par FM';
                    }
                    if (value.length != 10){
                      _referenceValid = false;
                      return 'Doit etre long de 8 caractères';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value.substring(2, 10))){
                      _referenceValid = false;
                      return 'Les huit derniers caractères doivent etre numérique';
                    }
                    if (value.endsWith(dateController.text.substring(8, 10))){
                      _referenceValid = true;
                    }
                    _referenceValid = true;
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  enabled: widget.initialProduct.reference.isNotEmpty ? false : true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.receipt),
                    focusColor: Colors.green,
                    contentPadding: const EdgeInsets.only(top: 16.0),
                    hintText: 'Entrer la référence',
                    hintStyle: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.green.withOpacity(0.7),
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.014),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Vendeur',
                  style: ralewayStyle.copyWith(
                    fontSize: 12.0,
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                height: 50.0,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.whiteColor,
                ),
                child: TextFormField(
                  controller: vendeurController,
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                    fontSize: 15.0,
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      _vendeurValid = false;
                      return 'Ce champ est obligatoire';
                    }
                    _vendeurValid = true;
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.shop),
                    contentPadding: const EdgeInsets.only(top: 16.0),
                    hintText: 'Renseigner le vendeur',
                    hintStyle: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.green.withOpacity(0.7),
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.014),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Total',
                  style: ralewayStyle.copyWith(
                    fontSize: 12.0,
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                height: 50.0,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.whiteColor,
                ),
                child: TextFormField(
                  controller: totalController,
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                    fontSize: 15.0,
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      _totalValid = false;
                      return 'Ce champ est obligatoire';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)){
                      _totalValid = false;
                      return 'Ce champ est uniquement numerique';
                    }
                    _totalValid = true;
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.money),
                    contentPadding: const EdgeInsets.only(top: 16.0),
                    hintText: 'Entrer le Total',
                    hintStyle: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.green.withOpacity(0.7),
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.05),
            ]);
  }
}