import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/product.dart';

class ProductTile extends StatelessWidget {
  final Product productInfo;
  final double height;
  final Function onTapFunction;
  final Function? onLongPressFunction;

  const ProductTile({
    Key? key,
    required final this.productInfo,
    final this.height = 150,
    required final this.onTapFunction,
    final this.onLongPressFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onLongPress: () =>
            onLongPressFunction != null ? onLongPressFunction!() : null,
        onTap: () => onTapFunction(),
        splashFactory: InkSplash.splashFactory,
        radius: 10,
        highlightColor: const Color.fromARGB(142, 33, 29, 62),
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
                  child: Image.file(
                    File(productInfo.imageLocation),
                    errorBuilder: (context, error, stackTrace) =>
                        const Placeholder(),
                  ),
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
    );
  }
}
