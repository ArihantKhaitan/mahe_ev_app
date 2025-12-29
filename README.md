# MAHE EV Charging ⚡

A comprehensive smart campus mobility solution designed for **Manipal Academy of Higher Education (MAHE)**. This full-featured application streamlines the experience of finding, booking, and paying for electric vehicle charging stations across the campus while providing administrators with powerful management tools.

<p align="center">
  <img src="assets/app_icon.png" width="150" height="150" alt="MAHE EV Logo">
</p>

---

## 📱 About The Project

**MAHE EV Charging** is a cross-platform mobile application built with **Flutter** and backed by **SQLite** for persistent data storage. It addresses the growing need for EV infrastructure management on campus by providing a seamless experience for students, staff, and administrators.

### Dual-Interface System:
1. **User App:** For drivers to find, book, and charge vehicles with wallet management
2. **Admin Dashboard:** For campus staff to manage chargers, users, finances, and analytics

---

## ✨ User Features

### 🔐 Secure Authentication
- Email validation restricted to **`@learner.manipal.edu`** (Students) and **`@manipal.edu`** (Staff)
- Secure password-based login with SQL-backed user management
- Profile management with user type badges (Student/Staff)

### 🚗 Vehicle Management
- Add multiple EVs with detailed specifications (Make, Model, License Plate, Connector Type, Battery Capacity)
- Set primary vehicle for quick booking
- **Smart Compatibility Filtering:** Automatically filters stations based on vehicle's connector type

### 📍 Station Discovery
- **Home Screen:** List view of all nearby stations with real-time availability
- **Interactive Map:** Visual station locations with marker clusters
- **Smart Filters:** Filter by All, Available, Fast Charging, or Vehicle Compatible
- **Search:** Quick search by station name or location
- **Real-time Stats:** Available ports and parking spots at a glance

### 📅 Advanced Booking System
- **Immediate Booking:** "Start Now" for instant charging sessions
- **Future Reservations:** "Book Later" with time slot selection (Now, 10:30 AM, 11:00 AM, 12:00 PM)
- **Booking Management:** View Active, Reserved, and Completed bookings
- **Cancellation:** Cancel reservations with automatic refund processing
- **Booking Fee:** ₹50 refundable booking fee system

### ⚡ Charging Experience
- **Circular Neon SOC Indicator:** Real-time State of Charge visualization
- **Live Controls:** Pause/Resume charging, Set energy limit (kWh)
- **Dynamic Pricing:** Peak hours (+20%) and off-peak discounts (-20%)
- **Solar Station Indicators:** Special pricing for solar-powered stations
- **Safe Exit:** "Return to Charging" option prevents accidental session termination

### 💳 Campus Wallet System
- **Quick Add:** Preset amounts (₹100, ₹200, ₹500, ₹1000)
- **Payment Methods:**
    - **UPI Integration:** Enter UPI ID for payments
    - **Card Payments:** Credit/Debit card support with masked display
- **Multi-Bank Support:** Link multiple bank accounts
- **Transaction History:** Detailed logs with payment method tracking
- **Auto-deduction:** Seamless payment during charging

### 💰 Smart Billing
- Energy charges calculated per kWh
- 5% GST automatically applied
- Automatic refunds for cancellations
- Payment method recorded (UPI/Card/Wallet)

### 🔔 Notifications
- Real-time alerts for charging status
- Low balance warnings
- New station announcements
- Maintenance updates
- Mark as read/unread functionality

### 📊 User Statistics
- Total charging sessions count
- Clean energy consumed (kWh)
- CO₂ saved calculations
- Money saved vs third-party apps

### 🗺️ Navigation Integration
- "Navigate Here" button on station details
- Opens Google Maps with driving directions
- Supports both coordinates and location name

### 📸 QR Code Scanner
- Scan station QR codes to instantly identify chargers
- Quick start charging sessions

---

## 🛠️ Admin Features

### 🖥️ Admin Dashboard (5-Tab Structure)

#### Tab 1: Dashboard
- **Live Statistics:**
    - Total Users count
    - Active Sessions
    - Today's Bookings
    - Today's Revenue
    - Pending Issues count
    - Total Stations
- **Quick Actions:** Add Station, Send Alert (navigate to respective tabs)
- **Recent Bookings:** Latest booking activity with status
- **Recent Transactions:** Latest financial activity

#### Tab 2: Stations Management
- **Dual View:** Toggle between List and Map views
- **Search:** Find stations by name or location
- **Port Management:** Quick +/- controls for available ports per station
- **Add New Station:**
    - Tap on map to add at specific coordinates
    - Set name, location, price, parking spots
    - Configure connector type (CCS Type 2, Type 2 AC, CHAdeMO)
    - Toggle Fast Charger and Solar Powered options
- **Edit Station:** Modify all station properties
- **Delete Station:** Remove decommissioned chargers
- **Station Analytics:** View detailed usage statistics
- **Issue Tracking:** View and resolve reported problems

#### Tab 3: Alerts & Bookings
- **Send Notifications:**
    - Global alerts to all users
    - Targeted alerts to specific users
- **All Bookings View:**
    - Filter by status (All, Active, Completed, Cancelled)
    - Search by user or station
    - View booking details
- **Notification History:** Log of all sent alerts

#### Tab 4: Users Management
- **User List:** Search and browse all registered users
- **User Statistics:** Total users, students, staff counts
- **User Details Panel:**
    - View profile information
    - Booking history
    - Transaction history
    - Registered vehicles
    - User notifications
- **User Actions:**
    - Edit user details (name, email, user type)
    - Issue refunds directly to wallet
    - Delete user accounts

#### Tab 5: Settings & Finance
- **Financial Overview:**
    - Total Balance across all transactions
    - Revenue breakdown
- **Recent Transactions:** Admin view of all financial activity
- **Export Data (CSV):**
    - Export Bookings
    - Export Transactions
    - Export Users
    - Export Stations
- **Institution Bank Details:** Manage MAHE main account
- **Admin Profile:** View admin information
- **Logout:** Secure session termination

### 📈 Additional Admin Capabilities
- **Station Inspector:** Detailed station view with edit/delete/issue tracking
- **Real-time Updates:** All changes reflect immediately in SQL database
- **Issue Resolution:** Mark issues as Pending → In Progress → Resolved

---

## 🗄️ Database Schema (SQLite)

| Table | Description |
|-------|-------------|
| `users` | User profiles with authentication |
| `vehicles` | User vehicle information |
| `bookings` | All booking records |
| `transactions` | Wallet transactions with payment methods |
| `notifications` | User notifications |
| `stations` | Charging station data |
| `reported_issues` | Issue tracking |
| `sent_notifications` | Admin notification history |

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.x (Dart) |
| **UI Design** | Material Design 3 |
| **Database** | SQLite (sqflite package) |
| **Maps** | flutter_map + OpenStreetMap |
| **Location** | Geolocator |
| **Fonts** | Google Fonts (Poppins) |
| **File Export** | path_provider + share_plus |
| **Navigation** | url_launcher |
| **State** | StatefulWidget + ValueNotifier |

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
  geolocator: ^10.1.0
  url_launcher: ^6.2.1
  sqflite: ^2.3.0
  path: ^1.8.3
  path_provider: ^2.1.1
  share_plus: ^7.2.1
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- Android Studio or VS Code with Flutter extensions
- Android Emulator or Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ArihantKhaitan/mahe_ev_app.git
   ```

2. **Navigate to the project directory**
   ```bash
   cd mahe_ev_app
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Default Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | `admin@manipal.edu` | `admin123` |
| User | Sign up with `@learner.manipal.edu` or `@manipal.edu` email |

---

## 📱 Screenshots

| Home Screen | Map View | Station Details |
|-------------|----------|-----------------|
| Station list with filters | Interactive map with markers | Booking & pricing info |

| Charging Screen | Wallet | Admin Dashboard |
|-----------------|--------|-----------------|
| SOC indicator & controls | UPI/Card payments | Statistics & quick actions |

---

## 🏗️ Project Structure

```
lib/
├── main.dart              # Main application (all screens & widgets)
├── database_helper.dart   # SQLite database operations
assets/
├── app_icon.png          # Application icon
├── splash_logo.png       # Splash screen logo
```

---

## 🔮 Future Scope

- **🔥 Firebase Integration:** Cloud-based real-time database
- **🔌 IoT Integration:** MQTT connection to physical charging hardware
- **💳 Payment Gateway:** Razorpay/Stripe for real transactions
- **📱 Push Notifications:** Firebase Cloud Messaging
- **⏰ Waitlist System:** Queue management for busy stations
- **📊 Advanced Analytics:** Usage trends and predictive maintenance
- **🌐 Multi-language Support:** Localization for different regions

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is developed for academic purposes at Manipal Academy of Higher Education.

---

## 👨‍💻 Developer

**Arihant Khaitan**