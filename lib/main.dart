import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const ZeroQApp());
}

// ─────────────────────────────────────────────
// MAIN APP
// ─────────────────────────────────────────────
class ZeroQApp extends StatelessWidget {
  const ZeroQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZEROQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCT MODEL
// ─────────────────────────────────────────────
class Product {
  final String id;
  final String name;
  final String brand;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
  });
}

// ─────────────────────────────────────────────
// MOCK PRODUCT DATABASE
// ─────────────────────────────────────────────
final Map<String, Product> mockDatabase = {
  '8901234567890': Product(id: '8901234567890', name: 'Amul Full Cream Milk',   brand: 'Amul',    price: 68.0),
  '8901030839791': Product(id: '8901030839791', name: "Lay's Classic Salted",   brand: "Lay's",   price: 20.0),
  '4902430144339': Product(id: '4902430144339', name: 'Colgate Strong Teeth',   brand: 'Colgate', price: 95.0),
  '8901063133647': Product(id: '8901063133647', name: 'Surf Excel Quick Wash',  brand: 'HUL',     price: 115.0),
  '8901058851228': Product(id: '8901058851228', name: 'Maggi Noodles',          brand: 'Nestle',  price: 14.0),
  '8901491500015': Product(id: '8901491500015', name: 'Parle-G Biscuits',       brand: 'Parle',   price: 10.0),
  '8906002480357': Product(id: '8906002480357', name: 'Too Yumm! Chips',        brand: 'Too Yumm',price: 20.0),
  '8901519101222': Product(id: '8901519101222', name: 'Lifebuoy Soap',          brand: 'HUL',     price: 45.0),
};

// ─────────────────────────────────────────────
// GET PRODUCT — works with ANY barcode
// If not in database → creates a generic product
// ─────────────────────────────────────────────
Product getProduct(String barcode) {
  // Try as-is first
  if (mockDatabase.containsKey(barcode)) return mockDatabase[barcode]!;

  // Try stripping a leading zero (UPC-A → EAN-13 mismatch)
  final stripped = barcode.startsWith('0') ? barcode.substring(1) : barcode;
  if (mockDatabase.containsKey(stripped)) return mockDatabase[stripped]!;

  // Any unknown barcode → generic product so app never fails
  return Product(
    id: barcode,
    name: 'Product (${barcode.length > 8 ? barcode.substring(0, 8) : barcode}...)',
    brand: 'Unknown Brand',
    price: 50.0,
  );
}

// ─────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Cart — list of maps
  final List<Map<String, dynamic>> cart = [];

  // ── Calculated totals ──
  double get totalPrice {
    double total = 0;
    for (var item in cart) {
      total += (item['price'] as double) * (item['qty'] as int);
    }
    return total;
  }

  int get totalItems {
    int count = 0;
    for (var item in cart) {
      count += item['qty'] as int;
    }
    return count;
  }

  // ── Add product to cart ──
  void addToCart(Product product) {
    setState(() {
      int index = cart.indexWhere((item) => item['id'] == product.id);
      if (index >= 0) {
        // Already exists → increase quantity
        cart[index]['qty'] = cart[index]['qty'] + 1;
      } else {
        // New item → add
        cart.add({
          'id':    product.id,
          'name':  product.name,
          'brand': product.brand,
          'price': product.price,
          'qty':   1,
        });
      }
    });
  }

  // ── Remove item from cart ──
  void removeFromCart(String id) {
    setState(() {
      cart.removeWhere((item) => item['id'] == id);
    });
  }

  // ── Increase qty ──
  void increaseQty(String id) {
    setState(() {
      int index = cart.indexWhere((item) => item['id'] == id);
      if (index >= 0) cart[index]['qty'] = cart[index]['qty'] + 1;
    });
  }

  // ── Decrease qty ──
  void decreaseQty(String id) {
    setState(() {
      int index = cart.indexWhere((item) => item['id'] == id);
      if (index >= 0) {
        if (cart[index]['qty'] > 1) {
          cart[index]['qty'] = cart[index]['qty'] - 1;
        } else {
          cart.removeAt(index);
        }
      }
    });
  }

  // ── Clear entire cart ──
  void clearCart() {
    setState(() => cart.clear());
  }

  // ── Open scanner and handle result ──
  Future<void> openScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );

    // result is the barcode string returned from ScannerScreen
    if (result != null && result is String && result.isNotEmpty) {
      final product = getProduct(result); // works with ANY barcode now
      addToCart(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '✅ ${product.name} added! ₹${product.price}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF4),
      appBar: AppBar(
        title: const Text(
          'ZEROQ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          // Cart item count badge on top right
          if (totalItems > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$totalItems items',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [

          // ── Green Header Banner ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smart Self-Checkout 🛒',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Scan any product barcode to add it to cart',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),

                // ── Scan Button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: openScanner,
                    icon: const Icon(Icons.qr_code_scanner, size: 24),
                    label: const Text(
                      'Scan a Product',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Cart Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Cart ($totalItems items)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (cart.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Clear Cart?'),
                        content: const Text(
                            'This will remove all items.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              clearCart();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text('Clear',
                                style:
                                TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 18),
                    label: const Text('Clear All',
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),

          // ── Cart Items List ──
          Expanded(
            child: cart.isEmpty

            // Empty cart message
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 90,
                      color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'Cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Scan a product to add it here',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: openScanner,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Start Scanning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            )

            // Cart items
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                final itemTotal = (item['price'] as double) *
                    (item['qty'] as int);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [

                        // Product icon
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.green.shade700,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Product name & brand
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item['brand'],
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '₹${item['price']} each',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Qty controls + price + delete
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.end,
                          children: [

                            // Total price for this item
                            Text(
                              '₹${itemTotal.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // +  qty  - buttons
                            Row(
                              children: [
                                _QtyButton(
                                  icon: Icons.remove,
                                  onTap: () =>
                                      decreaseQty(item['id']),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    '${item['qty']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _QtyButton(
                                  icon: Icons.add,
                                  onTap: () =>
                                      increaseQty(item['id']),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // Remove button
                            GestureDetector(
                              onTap: () =>
                                  removeFromCart(item['id']),
                              child: const Text(
                                'Remove',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Bill Summary + Pay Button ──
          if (cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Total items row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$totalItems item${totalItems > 1 ? 's' : ''}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '₹${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const Divider(height: 16),

                  // Total amount row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Pay button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(
                              cart: List.from(cart),
                              total: totalPrice,
                              onPaymentDone: clearCart,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: Text(
                        'Pay ₹${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
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

// ─────────────────────────────────────────────
// SMALL QUANTITY BUTTON WIDGET
// ─────────────────────────────────────────────
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: Icon(icon, size: 16, color: Colors.green.shade700),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCANNER SCREEN
// ─────────────────────────────────────────────
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool scanned = false;
  bool torchOn = false;
  String? detectedBarcode; // shows what was detected on screen

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onDetect(BarcodeCapture capture) {
    if (scanned) return;
    final barcode = capture.barcodes.first.rawValue;
    if (barcode == null || barcode.isEmpty) return;

    debugPrint('Scanned barcode: "$barcode"');
    debugPrint('In database: ${mockDatabase.containsKey(barcode)}');

    scanned = true;
    setState(() => detectedBarcode = barcode);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.pop(context, barcode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Scan Barcode',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Torch toggle
          IconButton(
            icon: Icon(
              torchOn ? Icons.flash_on : Icons.flash_off,
              color: torchOn ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              controller.toggleTorch();
              setState(() => torchOn = !torchOn);
            },
          ),
        ],
      ),
      body: Stack(
        children: [

          // ── Camera View ──
          MobileScanner(
            controller: controller,
            onDetect: onDetect,
          ),

          // ── Scan Frame in center ──
          Center(
            child: Container(
              width: 260,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(
                  color: scanned ? Colors.green : Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              // Corner highlights
              child: Stack(
                children: [
                  // Top-left corner
                  Positioned(
                    top: 0, left: 0,
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.green.shade400, width: 4),
                          left: BorderSide(color: Colors.green.shade400, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Top-right corner
                  Positioned(
                    top: 0, right: 0,
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.green.shade400, width: 4),
                          right: BorderSide(color: Colors.green.shade400, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-left corner
                  Positioned(
                    bottom: 0, left: 0,
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.green.shade400, width: 4),
                          left: BorderSide(color: Colors.green.shade400, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Bottom-right corner
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.green.shade400, width: 4),
                          right: BorderSide(color: Colors.green.shade400, width: 4),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Detected barcode shown on screen ──
          if (detectedBarcode != null)
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '✅ Detected: $detectedBarcode',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          // ── Bottom hint ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '📷 Point camera at the product barcode',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hold steady • Make sure barcode is inside the frame',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Manual cancel
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAYMENT SCREEN
// ─────────────────────────────────────────────
class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double total;
  final VoidCallback onPaymentDone;

  const PaymentScreen({
    super.key,
    required this.cart,
    required this.total,
    required this.onPaymentDone,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'UPI';
  bool paid = false;

  void processPayment() {
    setState(() => paid = true);
    widget.onPaymentDone(); // Clear the cart

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ReceiptScreen(
              cart: widget.cart,
              total: widget.total,
              method: selectedMethod,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF4),
      appBar: AppBar(
        title: const Text('Payment',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── Amount Card ──
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.shade600,
                      Colors.green.shade400
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('Amount to Pay',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(
                      '₹${widget.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${widget.cart.length} item(s)',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Payment Method ──
            const Text('Choose Payment Method',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: RadioGroup<String>(
                groupValue: selectedMethod,
                onChanged: (v) {
                  if (v != null) setState(() => selectedMethod = v);
                },
                child: Column(
                  children: [
                    for (final method in [
                      ('UPI', Icons.currency_rupee),
                      ('Credit / Debit Card', Icons.credit_card),
                      ('Digital Wallet', Icons.account_balance_wallet),
                    ])
                      RadioListTile<String>(
                        title: Row(
                          children: [
                            Icon(method.$2,
                                size: 20, color: Colors.grey.shade600),
                            const SizedBox(width: 10),
                            Text(method.$1),
                          ],
                        ),
                        value: method.$1,
                        activeColor: Colors.green.shade700,
                      ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // ── Pay Button ──
            ElevatedButton.icon(
              onPressed: paid ? null : processPayment,
              icon: paid
                  ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.lock_outline),
              label: Text(
                paid
                    ? 'Processing...'
                    : 'Pay ₹${widget.total.toStringAsFixed(2)} via $selectedMethod',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 13, color: Colors.grey),
                SizedBox(width: 4),
                Text('100% Secure Payment',
                    style:
                    TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RECEIPT SCREEN
// ─────────────────────────────────────────────
class ReceiptScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final double total;
  final String method;

  const ReceiptScreen({
    super.key,
    required this.cart,
    required this.total,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF4),
      appBar: AppBar(
        title: const Text('Receipt',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ── Success Icon ──
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle,
                  color: Colors.green.shade600, size: 72),
            ),
            const SizedBox(height: 12),
            const Text(
              'Payment Successful! 🎉',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Thank you for shopping with ZEROQ',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ── Receipt Card ──
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ZEROQ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green.shade700,
                              )),
                          Text(
                            'Paid via $method',
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12),
                          ),
                        ],
                      ),

                      const Divider(height: 20),

                      // Items
                      Expanded(
                        child: ListView.builder(
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            final item = cart[index];
                            final itemTotal =
                                (item['price'] as double) *
                                    (item['qty'] as int);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize: 13),
                                        ),
                                        Text(
                                          '${item['brand']} × ${item['qty']}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${itemTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const Divider(),

                      // Total
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Paid',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(
                            '₹${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Back to Home ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}