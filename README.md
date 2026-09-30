# 🛒 ZERO-Q — Smart Self-Checkout App

**ZERO-Q** is a cross-platform Flutter application designed to eliminate long checkout queues in retail stores. Powered by real-time camera barcode scanning, ZERO-Q lets shoppers scan items directly off store shelves, track their total spending in real-time, apply promo codes, choose preferred payment methods, and receive digital receipts instantly.

---

## ✨ Features

- 📷 **Real-Time Barcode Scanner**: High-speed camera barcode recognition using `mobile_scanner`.
- 🛍️ **Interactive Shopping Cart**: Dynamic quantity adjustment, item removal, and live price calculations.
- 💳 **Flexible Payment Options**: Multi-payment gateway simulation supporting **UPI**, **Credit/Debit Cards**, and **Digital Wallets**.
- 🧾 **Digital Itemized Receipts**: Generates instant digital receipts complete with timestamp, transaction IDs, and savings summaries.
- 📱 **Cross-Platform**: Single codebase running seamlessly on Android, iOS, Web, and Desktop.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `>=3.0.0 <4.0.0`)
- **State Management**: Reactive `StatefulWidget` design
- **Barcode Scanning**: [`mobile_scanner`](https://pub.dev/packages/mobile_scanner)
- **UI Components**: Material 3 Design System with custom dark/light theme accents and [`cupertino_icons`](https://pub.dev/packages/cupertino_icons)

---

## 🚀 Getting Started

### Prerequisites

Ensure you have installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
- [Dart SDK](https://dart.dev/get-started)
- Chrome / Android Emulator / iOS Simulator / Desktop Build Tools

### Installation & Run

1. **Clone the Repository**
   ```bash
   git clone https://github.com/k-shankar0905/ZERO-Q.git
   cd ZERO-Q
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   # Run on Chrome Web
   flutter run -d chrome

   # Run on connected mobile device or emulator
   flutter run
   ```

4. **Run Unit & Widget Tests**
   ```bash
   flutter test
   ```

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).

