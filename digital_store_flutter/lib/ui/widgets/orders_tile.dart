import 'package:flutter/material.dart';

import '../../data/models/product.dart';

class OrdersTile extends StatelessWidget {
  final Product productInfo;
  const OrdersTile({Key? key, required this.productInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: SizedBox(
                height: 80,
                width: 80,
                child: productInfo.image ?? const Placeholder(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        productInfo.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      )),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: 'Total Price: '),
                          TextSpan(
                            text: '${productInfo.price} \$',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Quantity: ${productInfo.quantityInTheCart}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
