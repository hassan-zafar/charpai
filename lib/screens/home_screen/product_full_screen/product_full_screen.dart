import 'package:charpi/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/product_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/custom_widgets/custom_widget.dart';

class ProductFullScreen extends StatefulWidget {
  final Product product;
  const ProductFullScreen({super.key, required this.product});

  @override
  State<ProductFullScreen> createState() => _ProductFullScreenState();
}

class _ProductFullScreenState extends State<ProductFullScreen> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    CartProvider cartPro = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 30,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  )),
            ),
          ),
        ],
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image(
                    image: NetworkImage(widget.product.imageurl),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.product.productname.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w900,
                      fontSize: 22),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      'Review ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$ ${widget.product.amount}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const ForText(
                  name: 'About',
                  bold: true,
                  size: 22,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.product.description.toString(),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                          title: 'Add to Cart',
                          onTap: () {
                            bottomSheet(context, cartPro);
                          }),
                    ),
                    Consumer<ProductProvider>(builder:
                        (BuildContext context, ProductProvider productPro, _) {
                      return IconButton(
                        onPressed: () {
                          productPro.setVerify(widget.product.pid);
                        },
                        tooltip: 'Verify',
                        icon: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: (productPro.verified
                                      .contains(widget.product.pid))
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.done)),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }

  Future<dynamic> bottomSheet(BuildContext context, CartProvider cartPro) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StatefulBuilder(builder: (BuildContext context, setState) {
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image(
                          image: NetworkImage(widget.product.imageurl),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 250,
                            child: Text(
                              widget.product.productname.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$${widget.product.amount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      ForText(
                        name: 'Quantity',
                        bold: true,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: quantity < 2
                            ? null
                            : () {
                                setState(() {
                                  quantity--;
                                });
                              },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          size: 15,
                        ),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          print('add press');
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 15),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  (cartPro.checkExit(widget.product))
                      ? const Icon(
                          Icons.done,
                          color: Colors.green,
                          size: 29,
                        )
                      : CustomElevatedButton(
                          title: 'Add to cart',
                          onTap: () {
                            cartPro.addtocart(widget.product, quantity);
                            Navigator.of(context).pop();
                          }),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
