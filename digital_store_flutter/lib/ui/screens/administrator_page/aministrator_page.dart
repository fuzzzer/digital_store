import 'package:digital_store_flutter/ui/screens/administrator_page/components/category_manager_widget.dart';
import 'package:digital_store_flutter/ui/screens/administrator_page/components/product_manager_widget.dart';
import 'package:flutter/material.dart';

class AdministratorPage extends StatelessWidget {
  const AdministratorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: const [
            SizedBox(
              height: 50,
              child: TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'Product'),
                  Tab(text: 'Category'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView( //Todo: add product, add category panel
                children: [ProductManagerWidget(), CategoryManagerWidget(),],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
