# MAHE EV Charging ⚡

A smart campus mobility solution designed for the **Manipal Academy of Higher Education (MAHE)**. This application streamlines the experience of finding, booking, and paying for electric vehicle charging stations across the campus while providing administrators with powerful tools to manage the infrastructure.

<p align="center">
  <img src="assets/app_icon.png" width="150" height="150" alt="MAHE EV Logo">
</p>

## 📱 About The Project

**MAHE EV Charging** is a cross-platform mobile application built with **Flutter**. It addresses the growing need for EV infrastructure management on campus by allowing students, staff, and visitors to seamlessly manage their EV charging needs.

The app features a **dual-interface system**:
1.  **User App:** For drivers to find, book, and charge vehicles.
2.  **Admin Dashboard:** For campus staff to manage chargers, track revenue, and handle maintenance.

## ✨ User Features

* **🔐 Secure Access:** Strict signup validation restricted to **`@learner.manipal.edu`** (Students) and **`@manipal.edu`** (Staff) emails, plus a "Guest Mode" for visitors.
* **📸 Smart QR Scanning:** Integrated QR code scanner simulation to instantly identify charging stations and start sessions.
* **💳 Advanced Campus Wallet:**
    * **Quick Add:** Load money instantly using preset chips.
    * **Multi-Bank Integration:** Link multiple bank accounts (e.g., ICICI) and toggle Primary/Secondary payment methods.
    * **History:** Detailed transaction logs for all credits and debits.
* **🗺️ Real-Time Navigation:** Interactive map with "Locate Me" functionality to visualize user position relative to charging hubs (MIT Quadrangle, KMC, etc.).
* **⚡ Charging Simulation:** A real-time charging monitor that tracks units consumed (kWh), duration, and dynamic cost calculation.
* **💰 Smart Billing:** Auto-calculates Energy Charges + 5% GST and handles automatic refunds for booking cancellations.
* **🌱 Sustainability Stats:** Tracks CO₂ saved and money saved compared to fuel.

## 🛠️ Admin & Operator Features

* **🖥️ Dedicated Admin Zone:** Secure login for administrators (Route: `arihant@manipal.edu`).
* **🔌 Station Management:**
    * **Deploy:** Tap anywhere on the map to deploy a new charger with custom details (Name, Price, Spots, Fast/Solar).
    * **Edit:** Modify pricing and parking capacity on the fly.
    * **Delete:** Remove decommissioned chargers instantly.
* **⚠️ Maintenance System:** Toggle "Maintenance Mode" for specific chargers to notify users and disable bookings.
* **📊 Financial Overview:** Track total revenue generated across all stations in real-time.
* **👥 User Management:** Monitor user activity and view charging history for individual students or staff.
* **🔍 Issue Tracking:** View and resolve reported issues (e.g., "Connector Damaged") directly from the dashboard.

## 🛠️ Tech Stack

* **Framework:** Flutter (Dart)
* **UI Design:** Material Design 3
* **State Management:** ValueNotifier & SetState (Simulated Local State)
* **Navigation:** Flutter Material Navigation
* **IDE:** Android Studio

## 🚀 Getting Started

Follow these steps to get a local copy up and running.

### Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* Android Studio or VS Code
* An Android Emulator or Physical Device

### Installation

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/ArihantKhaitan/mahe_ev_app.git](https://github.com/ArihantKhaitan/mahe_ev_app.git)
    ```

2.  **Navigate to the project directory**
    ```bash
    cd mahe_ev_app
    ```

3.  **Install dependencies**
    ```bash
    flutter pub get
    ```

4.  **Run the app**
    ```bash
    flutter run
    ```

## 🔮 Future Scope

* **Backend Integration:** Connect to Firebase or Node.js for persistent user data and station status.
* **IoT Integration:** Connect with physical charging stations via MQTT for actual hardware control (Start/Stop).
* **Live Payment Gateway:** Integrate Razorpay or Stripe for real money transactions replacing the simulation.
* **Waitlist System:** Notify users when a specific busy station becomes available.

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request