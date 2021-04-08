import 'dart:async';
import 'package:onlinemart/Controller/Product.dart';
import 'package:onlinemart/Screen/Loding.dart';
import 'package:onlinemart/Screen/homepage/Details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool load = true;

class GridViewWidge extends StatefulWidget {
  @override
  _GridViewWidgeState createState() => _GridViewWidgeState();
}

class _GridViewWidgeState extends State<GridViewWidge> {
  bool noMoreProducts = false;
  var products;
  ScrollController _scrollController = ScrollController();
  DocumentSnapshot _lastdoc;
  bool _loadingIndicator = false;
  bool _isBottom = false;

  void getProduct() async {
    Query productData =
        Firestore.instance.collection('Product').orderBy('pName').limit(6);
    QuerySnapshot snap = await productData.getDocuments();
    setState(() {
      products = snap.documents;
      _lastdoc = snap.documents[snap.documents.length - 1];
      load = false;
    });

    print(_lastdoc);
  }

  void getMoreProduct() async {
    setState(() {
      _loadingIndicator = true;
    });
    Query productData = Firestore.instance
        .collection('Product')
        .orderBy('pName')
        .startAfter([_lastdoc.data['pName']]).limit(6);
    QuerySnapshot snap = await productData.getDocuments();
    setState(() {
      print(snap.documents.length);
      if (snap.documents.length < 6) {
        noMoreProducts = true;
        print('working this');
      } else {
        noMoreProducts = false;
      }
      products.addAll(snap.documents);
      _lastdoc = snap.documents[snap.documents.length - 1];
      load = false;
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _loadingIndicator = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getProduct();
    print('working init');
    scrollControl();
    _scrollController.addListener(() {
      if (noMoreProducts == true) {
        if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _isBottom = true;
          });
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              _isBottom = false;
            });
          });
        }
      }
    });
  }

  void scrollControl() {
    _scrollController.addListener(() async {
      if (noMoreProducts == false) {
        print('working loading more');
        double max = _scrollController.position.maxScrollExtent;
        double current = _scrollController.position.pixels;
        double delta = MediaQuery.of(context).size.height * 0.25;

        if (max - current >= delta) {
          getMoreProduct();
          print('loading more');
        }
      }
      noMoreProducts = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List productId = [];
    var productmodel = Provider.of<Product>(context);

    if (productmodel.categories != null) {
      var productsData = Provider.of<QuerySnapshot>(context) ?? null;
      if (productsData == null) return LoadingWidget();
      products = productsData.documents.where((element) {
        return productmodel.categories == null
            ? load = true
            : element.data['categoryId'].contains(productmodel.categories);
      });
    }
    if (load == true) {
      getProduct();
      scrollControl();
    }

    return products == null
        ? LoadingWidget()
        : Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GridView.count(
                  controller: _scrollController,
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 1,
                  childAspectRatio: 0.9,
                  children: [
                    for (var product in products)
                      InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0.0, 5.0, 0.0, 10.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Image.network(
                                                product.data['imageUrl'],
                                                fit: BoxFit.fitHeight,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: 300,
                                              height: 50,
                                              child: Text(
                                                '${product.data['pName']}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              )),
                                          product.data['stock'] > 0
                                              ? SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                    'In Stock',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.green),
                                                  ),
                                                )
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Text(
                                                    'Out of Stock',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                          SizedBox(
                                            width: 90,
                                            child: Text(
                                              '\u{20B9} ${product.data['price']}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ]),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (product.data['stock'] > 0) {
                                        var user = Provider.of<Product>(context,
                                            listen: false);
                                        productId.add(product.documentID);
                                        user.updateUserCart(productId);
                                        productId = [];
                                      } else {}
                                    },
                                    child: product.data['stock'] > 0
                                        ? Container(
                                            alignment: Alignment(0, 0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                border: Border(
                                                    top: BorderSide(
                                                        width: 0.5,
                                                        color: Colors.black))),
                                            child: Text(
                                              'Add to cart',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            ))
                                        : Container(
                                            alignment: Alignment(0, 0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                border: Border(
                                                    top: BorderSide(
                                                        width: 0.5,
                                                        color: Colors.black))),
                                            child: Text(
                                              'Out of Stock',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            )),
                                  )
                                ]),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(product)));
                          })
                  ]),
              _loadingIndicator ? CupertinoActivityIndicator() : Text(''),
              _isBottom && !_loadingIndicator
                  ? Text(
                      "-End-",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )
                  : Text('')
            ],
          );
  }
}
