import 'package:flutter/material.dart';

// ============================================================
// HOW TO USE THIS FILE:
// Copy this entire file into your lib/main.dart
// This is a 3-screen app: Home (Grid) → Detail → Cart
// Change food items, names, prices to match your exam question
// ============================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// ================== MODEL ==================
class FoodItem {
  final String name;
  final double price;
  final String description;

  FoodItem({required this.name, required this.price, required this.description});
}

// ================== SAMPLE DATA ==================
List<FoodItem> foodItems = [
  FoodItem(name: 'Rice & Curry', price: 250.0, description: 'Sri Lankan rice and curry with 3 curries'),
  FoodItem(name: 'Kottu', price: 350.0, description: 'Famous Sri Lankan kottu roti'),
  FoodItem(name: 'Fried Rice', price: 300.0, description: 'Egg fried rice with vegetables'),
  FoodItem(name: 'Noodles', price: 280.0, description: 'Stir fried noodles with chicken'),
  FoodItem(name: 'Sandwich', price: 150.0, description: 'Fresh vegetable sandwich'),
  FoodItem(name: 'Burger', price: 400.0, description: 'Crispy chicken burger with fries'),
];

// ================== HOME SCREEN ==================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int cartCount = 0;
  List<FoodItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusEats'),
        backgroundColor: Colors.orange,
        actions: [
          Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text('$cartCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final item = foodItems[index];
          return GestureDetector(
            onTap: () async {
              final added = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(item: item),
                ),
              );
              if (added == true) {
                setState(() {
                  cartCount++;
                  cartItems.add(item);
                });
              }
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.orange[100],
                      width: double.infinity,
                      child: const Icon(Icons.fastfood, size: 60, color: Colors.orange),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('LKR ${item.price}', style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartItems)),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

// ================== DETAIL SCREEN ==================
class DetailScreen extends StatelessWidget {
  final FoodItem item;
  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack to overlay a discount badge on image
          Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.orange[100],
                child: const Icon(Icons.fastfood, size: 100, color: Colors.orange),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('20% OFF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(item.description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 16),
                Text('LKR ${item.price}', style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.name} added to cart!')),
                      );
                      Navigator.pop(context, true); // return true = item was added
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================== CART SCREEN ==================
class CartScreen extends StatefulWidget {
  final List<FoodItem> cartItems;
  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<FoodItem> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.cartItems); // make a copy
  }

  double get total => items.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.orange,
      ),
      body: items.isEmpty
          ? const Center(child: Text('Your cart is empty!'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('LKR ${item.price}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: LKR $total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order placed!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text('Checkout', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
