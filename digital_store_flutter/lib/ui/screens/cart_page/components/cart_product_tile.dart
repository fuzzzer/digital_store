import 'package:digital_store_flutter/data/models/product.dart';
import 'package:flutter/material.dart';

class CartProductTile extends StatelessWidget {
  final Product productInfo;
  final double height;
  final Function onPlusTapFunction;
  final Function onMinusTapFunction;
  final Function onRemoveTapFunction;
  final Function? onLongPressFunction;

  const CartProductTile({
    Key? key,
    required final this.productInfo,
    final this.height = 150,
    required final this.onPlusTapFunction,
    required final this.onMinusTapFunction,
    required final this.onRemoveTapFunction,
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
        splashFactory: InkSplash.splashFactory,
        radius: 10,
        highlightColor: const Color.fromARGB(142, 33, 29, 62),
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
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  productInfo.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                onRemoveTapFunction();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Total Price:  ${(productInfo.price * productInfo.quantityInTheCart!).toString()} \$',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Color.fromARGB(223, 18, 74, 164)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () => onMinusTapFunction(),
                                  icon: const Icon(Icons.remove,
                                      color:
                                          Color.fromARGB(255, 217, 113, 106))),
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  productInfo.quantityInTheCart.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 30,
                                      color: Color.fromARGB(223, 0, 0, 0)),
                                ),
                              ),
                              IconButton(
                                  onPressed: () => onPlusTapFunction(),
                                  icon: const Icon(Icons.add,
                                      color: Color.fromARGB(255, 96, 216, 83))),
                            ],
                          ),
                        ),
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
