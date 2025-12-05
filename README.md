# MAHE EV Charging ⚡

A smart campus mobility solution designed for the **Manipal Academy of Higher Education (MAHE)**. This application streamlines the experience of finding, booking, and paying for electric vehicle charging stations across the campus.

![App Banner](assets/banner.png)
## 📱 About The Project

**MAHE EV Charging** is a cross-platform mobile application built with **Flutter**. It addresses the growing need for EV infrastructure management on campus by allowing students, staff, and visitors to seamlessly manage their EV charging needs.

The app features a simulation mode that demonstrates the entire user journey—from locating a station to live charging and payment—without requiring a physical backend connection for demonstration purposes.

## ✨ Key Features

* **🔐 User Roles:** Secure login for Staff/Students and a "Continue as Guest" mode for visitors.
* **🗺️ Station Locator:** Interactive map and list views to find charging stations (e.g., MIT Quadrangle, KMC Staff Parking).
* **🔋 Real-Time Availability:** Check available ports, parking spots, and charger types (Fast/Standard) instantly.
* **📅 Slot Booking:** Reserve charging slots in advance with automatic cancellation refunds.
* **⚡ Live Charging Simulation:** A real-time charging monitor that tracks units consumed (kWh), duration, and cost.
* **💳 Campus Wallet:** Integrated wallet system to add money and handle payments with detailed bill breakdowns (Energy Charges + GST).
* **🌙 Dark Mode:** Fully supported dark theme for better visibility at night.
* **🌱 Sustainability Stats:** Tracks CO₂ saved and money saved compared to fuel.

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
    git clone [https://github.com/your-username/mahe_ev_project.git](https://github.com/your-username/mahe_ev_project.git)
    ```

2.  **Navigate to the project directory**
    ```bash
    cd mahe_ev_project
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

* **Backend Integration:** Connect to Firebase or Node.js for real-time database management.
* **IoT Integration:** Connect with physical charging stations via MQTT for actual hardware control.
* **UPI Payment Gateway:** Integrate Razorpay or Stripe for real money transactions.
* **Waitlist System:** Notify users when a specific station becomes available.

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request
