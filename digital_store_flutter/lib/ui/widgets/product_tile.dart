import 'package:flutter/material.dart';

import '../../data/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product productInfo;
  final double height;
  final Function onTapFunction;

  const   ProductTile({
    Key? key,
    required final this.productInfo,
    final this.height = 150,
    required final this.onTapFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => onTapFunction(),
        splashFactory: InkSplash.splashFactory,
        radius: 10,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.black, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    height: height / 4 * 3,
                    width: height / 4 * 3,
                    child: productInfo.image ?? const Placeholder(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            productInfo.title,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: height / 10),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(productInfo.description),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '\$ ${productInfo.price.toString()}',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: height / 9,
                                color: const Color.fromARGB(223, 18, 74, 164)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
