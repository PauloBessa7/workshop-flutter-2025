import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductListScreen(),
    );
  }
}

class Product {
  String name;
  bool purchased;

  Product({required this.name, required this.purchased});
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController addProductController = TextEditingController();
  bool showPurchasedFirst = false;

  @override
  void initState() {
    super.initState();
    // Adicionando alguns produtos de exemplo
    products.addAll([
      Product(name: 'Maçã', purchased: false),
      Product(name: 'Leite', purchased: true),
      Product(name: 'Pão', purchased: false),
      Product(name: 'Ovos', purchased: true),
    ]);
    filteredProducts = List.from(products);
    searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    searchController.dispose();
    addProductController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();

      _sortProducts();
    });
  }

  void _sortProducts() {
    filteredProducts.sort((a, b) {
      if (showPurchasedFirst) {
        // Coloca os comprados primeiro (true vem antes de false quando invertemos)
        if (a.purchased && !b.purchased) return -1;
        if (!a.purchased && b.purchased) return 1;
      }
      // Ordena alfabeticamente
      return a.name.compareTo(b.name);
    });
  }

  void _toggleSort() {
    setState(() {
      showPurchasedFirst = !showPurchasedFirst;
      _sortProducts();
    });
  }

  void _addProduct() {
    addProductController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Produto'),
          content: TextField(
            controller: addProductController,
            decoration: InputDecoration(hintText: 'Nome do produto'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (addProductController.text.isNotEmpty) {
                  setState(() {
                    products.add(Product(
                      name: addProductController.text,
                      purchased: false,
                    ));
                    _filterProducts();
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _togglePurchased(int index) {
    setState(() {
      // Encontrar o produto na lista original
      final productName = filteredProducts[index].name;
      final productIndex = products.indexWhere((p) => p.name == productName);
      if (productIndex != -1) {
        products[productIndex].purchased = !products[productIndex].purchased;
      }
      _filterProducts();
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      final productName = filteredProducts[index].name;
      products.removeWhere((p) => p.name == productName);
      _filterProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar produtos...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add, size: 30),
                  onPressed: _addProduct,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Dismissible(
                  key: Key(product.name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => _deleteProduct(index),
                  child: ListTile(
                    title: Text(
                      product.name,
                      style: TextStyle(
                        decoration: product.purchased
                            ? TextDecoration.lineThrough
                            : null,
                        color: product.purchased ? Colors.grey : null,
                      ),
                    ),
                    trailing: Checkbox(
                      value: product.purchased,
                      onChanged: (value) => _togglePurchased(index),
                    ),
                    onTap: () => _togglePurchased(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSort,
        tooltip: 'Ordenar',
        child:
            Icon(showPurchasedFirst ? Icons.sort_by_alpha : Icons.check_circle),
      ),
    );
  }
}
