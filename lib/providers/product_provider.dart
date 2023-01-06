import 'package:flutter/cupertino.dart';

import '../database/local_data.dart';
import '../database/product_api.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  ProductProvider() {
    load();
  }
  List<Product> _product = <Product>[];
  final List<String> _favorites = <String>[];
  final List<String> _verified = <String>[];
  List<String> get favorites => _favorites;
  List<String> get verified => _verified;
  List<Product> get products => _product;

  Future<void> load() async {
    _product = await ProductApi().getdata();
    _favorites.addAll(LocalData.getFavroites);
    _verified.addAll(LocalData.getVerified);
    notifyListeners();
  }

  Product product(String value) {
    final int index =
        _product.indexWhere((Product element) => element.pid == value);
    return index < 0 ? _null : _product[index];
  }

  List<String> categories = [];

  List<Product> findByCategory(String categoryname) {
    List<Product> _categoryList = _product
        .where((Product element) =>
            element.category.toLowerCase().contains(categoryname.toLowerCase()))
        .toList();
    return _categoryList;
  }

  updateFavorite(String value) {
    if (_favorites.contains(value)) {
      _favorites.remove(value);
    } else {
      _favorites.add(value);
    }
    LocalData.setFavroites(_favorites);
    notifyListeners();
  }

  setVerify(String value) {
    if (_verified.contains(value)) {
      _verified.remove(value);
    } else {
      _verified.add(value);
    }
    LocalData.setVerified(_verified);
    notifyListeners();
  }

  Product get _null => Product(
        pid: 'null',
        amount: 0,
        colors: 'null',
        quantity: '0',
        productname: 'null',
        description: 'null',
        timestamp: 0,
        category: 'null',
        subCategory: 'null',
        createdByUID: 'null',
        imageurl: '',
      );
}
