<div align="center">

# 🛒 ZERO-Q

**Smart Self-Checkout & Instant Scan Application**

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/Material_3-757575?style=for-the-badge&logo=materialdesign&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android_%7C_iOS_%7C_Web_%7C_Desktop-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

</div>

---

## 🎯 Problem & Solution

Traditional retail shopping suffers from long checkout queues during peak hours, causing customer frustration and store congestion. 

**ZERO-Q** solves this by putting self-checkout directly into the shopper's hands. Customers scan product barcodes using their smartphone camera as they shop, maintain a real-time digital cart, make instant digital payments, and generate digital receipts—skipping billing queues entirely.

---

## ℹ️ About

ZERO-Q is a cross-platform Flutter application designed to eliminate long checkout queues in retail stores. Powered by real-time camera barcode scanning, ZERO-Q lets shoppers scan items directly off store shelves, track their total spending in real-time, apply promo codes, choose preferred payment methods, and receive digital receipts instantly.

---

## ✨ Features

- **Real-Time Barcode Scanner**: High-speed camera barcode recognition using `mobile_scanner`.
- **Interactive Shopping Cart**: Dynamic quantity adjustment, item removal, and live price calculations.
- **Flexible Payment Options**: Multi-payment gateway simulation supporting **UPI**, **Credit/Debit Cards**, and **Digital Wallets**.
- **Digital Itemized Receipts**: Generates instant digital receipts complete with timestamp, transaction IDs, and savings summaries.
- **Cross-Platform**: Single codebase running seamlessly on Android, iOS, Web, and Desktop.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `>=3.0.0 <4.0.0`)
- **State Management**: Reactive `StatefulWidget` design
- **Barcode Scanning**: [`mobile_scanner`](https://pub.dev/packages/mobile_scanner)
- **UI Components**: Material 3 Design System with custom dark/light theme accents and [`cupertino_icons`](https://pub.dev/packages/cupertino_icons)

---

## 📂 Project Structure

```
lib/
└── main.dart              # Core application entry point containing:
    ├── ZeroQApp           # Root MaterialApp configuration
    ├── Product            # Product data model
    ├── HomeScreen         # Cart view, item quantity controls & total breakdown
    ├── ScannerScreen      # Camera barcode scanner using mobile_scanner
    ├── PaymentScreen      # Payment method selection (UPI, Card, Wallet)
    └── ReceiptScreen      # Digital receipt generation & order summary
```

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

## 🗺️ Roadmap

- [x] Barcode scanning with live camera stream (`mobile_scanner`)
- [x] Dynamic cart management & real-time total calculation
- [x] Multi-option payment UI (UPI, Credit/Debit Card, Digital Wallet)
- [x] Digital receipt generation with transaction details
- [ ] Real payment gateway API integration
- [ ] User authentication & profile management
- [ ] Order history & saved receipts
- [ ] Backend inventory & price sync API

---

## 👤 Author

Kothapalli Gowri Shankar - https://github.com/k-shankar0905

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).
