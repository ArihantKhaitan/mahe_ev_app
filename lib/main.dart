import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MaheEVApp());
}

// --- MAIN APP WIDGET ---
class MaheEVApp extends StatelessWidget {
  const MaheEVApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Define the Premium Font Text Theme (Standard Size to prevent crash)
    TextTheme premiumTextTheme(TextTheme base) {
      return GoogleFonts.poppinsTextTheme(base);
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'MAHE EV Charge',
          debugShowCheckedModeBanner: false,
          themeMode: mode,

          // --- LIGHT THEME ---
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00796B),
              surface: const Color(0xFFF8F9FA),
              onSurface: const Color(0xFF1A1C1E),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            textTheme: premiumTextTheme(ThemeData.light().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF1A1C1E),
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              margin: const EdgeInsets.only(bottom: 12),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // --- DARK THEME ---
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00796B),
              brightness: Brightness.dark,
              surface: const Color(0xFF121212),
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFF0A0A0A),
            textTheme: premiumTextTheme(ThemeData.dark().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E1E),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
              margin: const EdgeInsets.only(bottom: 12),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: Colors.grey.shade600),
              contentPadding: const EdgeInsets.all(20),
            ),
            dividerTheme: DividerThemeData(
              color: Colors.white.withValues(alpha: 0.1),
              thickness: 1,
            ),
          ),

          home: const LoginScreen(),
        );
      },
    );
  }
}


// --- DATA MODELS ---

class Station {
  final String id;
  final String name;
  final String location;
  final double distance;
  final bool isFastCharger;
  final int totalPorts;
  int availablePorts;
  final bool isSharedPower;
  final bool isSolarPowered;
  final double mapX;
  final double mapY;
  final int parkingSpaces;
  int availableParking;
  final double pricePerUnit;
  final String connectorType; // <--- NEW FIELD: Type of connector the station provides

  Station({
    required this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.isFastCharger,
    required this.totalPorts,
    required this.availablePorts,
    required this.isSharedPower,
    required this.isSolarPowered,
    required this.mapX,
    required this.mapY,
    required this.parkingSpaces,
    required this.availableParking,
    required this.pricePerUnit,
    required this.connectorType, // <--- NEW REQUIRED PARAMETER
  });
}

class Transaction {
  final String id;
  final String title;
  final DateTime date;
  final double amount;
  final bool isCredit; // true = added money, false = paid for charging

  Transaction({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });
}

class Booking {
  final String id;
  final String stationId;
  final String stationName;
  final DateTime bookingTime;
  final DateTime? startTime;
  final DateTime? endTime;
  final double cost;
  final String status; // 'active', 'completed', 'cancelled'

  Booking({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.bookingTime,
    this.startTime,
    this.endTime,
    required this.cost,
    required this.status,
  });
}

class UserProfile {
  String id;
  String name;
  String email;
  String userType;
  bool isAdmin;
  double walletBalance;
  List<Booking> bookings;
  List<Transaction> transactions;
  List<Vehicle> vehicles; // <--- NEW FIELD

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.isAdmin = false,
    required this.walletBalance,
    required this.bookings,
    required this.transactions,
    this.vehicles = const [], // Default to empty list
  });
}

class AppNotification {
  final String title;
  final String body;
  final DateTime time;
  bool read;

  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    this.read = false,
  });
}

class ReportedIssue {
  final String id;
  final String stationName;
  final String reportedBy;
  final String issueType;
  final DateTime time;
  final String status; // 'Pending', 'Resolved'

  ReportedIssue({
    required this.id,
    required this.stationName,
    required this.reportedBy,
    required this.issueType,
    required this.time,
    this.status = 'Pending',
  });
}

class Vehicle {
  final String id;
  final String make;
  final String model;
  final String licensePlate;
  final String connectorType;
  final bool isPrimary;
  final double batteryCapacityKWh; // <--- NEW FIELD
  final int initialSOCPercent;    // <--- NEW FIELD

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.licensePlate,
    required this.connectorType,
    this.isPrimary = false,
    this.batteryCapacityKWh = 30.0, // Default to a small EV battery size
    this.initialSOCPercent = 20,    // Default starting SOC for session simulation
  });
}

// --- MOCK DATA ---

// --- MOCK DATA FOR VEHICLES ---
List<Vehicle> mockVehicles = [
  Vehicle(
    id: 'V1',
    make: 'TATA',
    model: 'Nexon EV',
    licensePlate: 'KA 01 EV 1234',
    connectorType: 'CCS Type 2',
    isPrimary: true,
    batteryCapacityKWh: 30.2,
    initialSOCPercent: 30,
  ),
  Vehicle(
    id: 'V2',
    make: 'MG',
    model: 'ZS EV',
    licensePlate: 'KA 01 MG 0077',
    connectorType: 'Type 2 AC',
    isPrimary: false,
    batteryCapacityKWh: 44.5,
    initialSOCPercent: 50,
  ),
];

List<ReportedIssue> mockIssues = [
  ReportedIssue(id: 'I1', stationName: 'MIT Quadrangle', reportedBy: 'Rahul S.', issueType: 'Connector Damaged', time: DateTime.now().subtract(const Duration(hours: 2))),
  ReportedIssue(id: 'I2', stationName: 'NLH EV Point', reportedBy: 'Prof. Anjali', issueType: 'Payment Failed', time: DateTime.now().subtract(const Duration(days: 1))),
];

// Initial Notifications
List<AppNotification> mockNotifications = [
  AppNotification(
    title: 'Charging Complete',
    body: 'Your vehicle at MIT Quadrangle has finished charging.',
    time: DateTime.now().subtract(const Duration(minutes: 30)),
    read: false,
  ),
  AppNotification(
    title: 'Low Balance Alert',
    body: 'Your wallet balance is below ₹100. Top up to ensure uninterrupted charging.',
    time: DateTime.now().subtract(const Duration(hours: 5)),
    read: true,
  ),
  AppNotification(
    title: 'New Station Added',
    body: 'A new fast charger is now available at AB-5 Solar Carport.',
    time: DateTime.now().subtract(const Duration(days: 1)),
    read: true,
  ),
  AppNotification(
    title: 'Maintenance Update',
    body: 'KMC Staff Parking station will be down for maintenance tomorrow from 10 AM to 2 PM.',
    time: DateTime.now().subtract(const Duration(days: 2)),
    read: true,
  ),
];

// Initial Stations
// Initial Stations (UPDATED with connectorType)
List<Station> mockStations = [
  Station(id: '1', name: 'MIT Quadrangle', location: 'Block 4', distance: 0.5, isFastCharger: true, totalPorts: 4, availablePorts: 2, isSharedPower: true, isSolarPowered: true, mapX: 0.4, mapY: 0.3, parkingSpaces: 8, availableParking: 3, pricePerUnit: 8.5, connectorType: 'CCS Type 2'),
  Station(id: '2', name: 'KMC Staff Parking', location: 'Tiger Circle', distance: 1.2, isFastCharger: true, totalPorts: 2, availablePorts: 0, isSharedPower: false, isSolarPowered: true, mapX: 0.7, mapY: 0.6, parkingSpaces: 6, availableParking: 0, pricePerUnit: 8.5, connectorType: 'CCS Type 2'),
  Station(id: '3', name: 'AB-5 Solar Carport', location: 'Uni Road', distance: 2.8, isFastCharger: false, totalPorts: 6, availablePorts: 5, isSharedPower: false, isSolarPowered: true, mapX: 0.2, mapY: 0.8, parkingSpaces: 12, availableParking: 8, pricePerUnit: 7.0, connectorType: 'Type 2 AC'),
  Station(id: '4', name: 'NLH EV Point', location: 'NLH Complex', distance: 0.8, isFastCharger: false, totalPorts: 4, availablePorts: 4, isSharedPower: false, isSolarPowered: false, mapX: 0.5, mapY: 0.4, parkingSpaces: 4, availableParking: 2, pricePerUnit: 8.0, connectorType: 'Type 2 AC'),
];

// Global User State (Starts empty, populated on Login)
UserProfile currentUser = UserProfile(
  id: 'U001',
  name: 'Manipal User',
  email: 'user@mahe.ac.in',
  userType: 'student',
  walletBalance: 450.0,
  bookings: [],
  transactions: [
    Transaction(id: 'T1', title: 'Added Money', date: DateTime.now().subtract(const Duration(days: 1)), amount: 500, isCredit: true),
    Transaction(id: 'T2', title: 'Charging - MIT Quad', date: DateTime.now().subtract(const Duration(days: 2)), amount: 50, isCredit: false),
  ],
  vehicles: mockVehicles, // Add the mock list here
);
List<Transaction> allGlobalTransactions = [
  Transaction(id: 'TXN_001', title: 'Payment - User A', date: DateTime.now().subtract(const Duration(minutes: 10)), amount: 120.0, isCredit: false),
  Transaction(id: 'TXN_002', title: 'Wallet Load - User B', date: DateTime.now().subtract(const Duration(minutes: 45)), amount: 500.0, isCredit: true),
  Transaction(id: 'TXN_003', title: 'Payment - User C', date: DateTime.now().subtract(const Duration(hours: 2)), amount: 85.0, isCredit: false),
];

// --- LOGIN SCREEN ---
// --- LOGIN SCREEN (High Contrast Neon-Grey Text) ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _idController = TextEditingController();
  final _passController = TextEditingController();

  void _login() {
    // 1. Basic validation
    if (_idController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ID/Email and password')),
      );
      return;
    }

    String inputText = _idController.text.trim();
    String password = _passController.text.trim();

    // --- ADMIN CHECK ---
    if (inputText == 'arihant@manipal.edu' && password == '123') {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          // Create ADMIN Profile
          currentUser = UserProfile(
            id: 'ADMIN_001',
            name: 'Arihant (Admin)',
            email: 'arihant@manipal.edu',
            userType: 'admin',
            isAdmin: true,
            walletBalance: 99999.0,
            bookings: [],
            transactions: [],
            vehicles: const [], // Added
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
          );
        }
      });
      return;
    }

    // --- STANDARD USER CHECK ---
    String finalEmail;
    String userType = 'student';

    if (inputText.contains('@')) {
      String lowerInput = inputText.toLowerCase();
      bool isValid = lowerInput.endsWith('@learner.manipal.edu') ||
          lowerInput.endsWith('@manipal.edu');

      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Use a valid Manipal email (@learner.manipal.edu or @manipal.edu)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      finalEmail = inputText;
      if (lowerInput.endsWith('@manipal.edu')) userType = 'staff';
    } else {
      finalEmail = '$inputText@learner.manipal.edu';
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        currentUser = UserProfile(
          id: inputText.contains('@') ? inputText.split('@')[0] : inputText,
          name: userType == 'staff' ? 'Manipal Staff' : 'Manipal Student',
          email: finalEmail,
          userType: userType,
          isAdmin: false,
          walletBalance: 450.0,
          bookings: [
            Booking(
              id: 'B_OLD_1',
              stationId: '1',
              stationName: 'MIT Quadrangle',
              bookingTime: DateTime.now().subtract(const Duration(days: 2)),
              cost: 120.50,
              status: 'completed',
            )
          ],
          transactions: [
            Transaction(id: 'T1', title: 'Wallet Top-up', date: DateTime.now().subtract(const Duration(days: 5)), amount: 500.0, isCredit: true),
            Transaction(id: 'T2', title: 'EV Charge - MIT Quad', date: DateTime.now().subtract(const Duration(days: 2)), amount: 120.50, isCredit: false),
          ],
          vehicles: mockVehicles, // Added
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    });
  }

// --- FIX: _continueAsGuest() to include mock vehicles ---
  void _continueAsGuest() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        // Create a mutable copy of mockVehicles list for the guest
        List<Vehicle> guestMockVehicles = List.of(mockVehicles);

        // Ensure the first one in the mock list is set as primary for the guest session
        // Since it's a new list, we can safely overwrite its properties
        if (guestMockVehicles.isNotEmpty) {
          final firstVehicle = guestMockVehicles[0];
          guestMockVehicles[0] = Vehicle(
            id: firstVehicle.id,
            make: firstVehicle.make,
            model: firstVehicle.model,
            licensePlate: firstVehicle.licensePlate,
            connectorType: firstVehicle.connectorType,
            batteryCapacityKWh: firstVehicle.batteryCapacityKWh,
            initialSOCPercent: firstVehicle.initialSOCPercent,
            isPrimary: true, // Set as primary for the session
          );
        }

        currentUser = UserProfile(
          id: 'GUEST',
          name: 'Guest User',
          email: 'guest@temp.mahe.ev',
          userType: 'guest',
          walletBalance: 100.0,
          bookings: [],
          transactions: [],
          // Use the mutable copy of the mock vehicles
          vehicles: guestMockVehicles,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- UPDATED COLORS (SHARPER/HIGH CONTRAST) ---
    final primaryTextColor = isDark ? Colors.cyanAccent : Colors.blueAccent.shade700;

    // Use BlueGrey for that "Metallic/Neon Grey" look.
    // shade200 is very bright against black. shade700 is strong against white.
    final neonGrey = isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade700;

    final buttonColor = const Color(0xFFE65100);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Image.asset(
                'assets/app_icon.png',
                height: 150,
              ),
              const SizedBox(height: 24),
              Text(
                'MAHE EV Charging',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              Text(
                'Campus Charging Solution',
                style: TextStyle(
                  color: neonGrey, // <--- HIGH CONTRAST GREY
                  fontSize: 14,
                  fontWeight: FontWeight.w600, // Thicker font
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.eco, color: Colors.green, size: 14),
                    SizedBox(width: 4),
                    Text('Zero GST on Solar', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              TextField(
                controller: _idController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'MAHE Staff/Student ID',
                  labelStyle: TextStyle(color: neonGrey, fontWeight: FontWeight.w500), // <--- VISIBLE LABEL
                  prefixIcon: Icon(Icons.badge_outlined, color: neonGrey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: neonGrey.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryTextColor),
                      borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passController,
                obscureText: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: neonGrey, fontWeight: FontWeight.w500), // <--- VISIBLE LABEL
                  prefixIcon: Icon(Icons.lock_outline, color: neonGrey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: neonGrey.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryTextColor),
                      borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button (Fixed Height)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: _isLoading ? null : _continueAsGuest,
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(
                    color: neonGrey, // <--- HIGH CONTRAST GREY
                    fontSize: 16,
                    fontWeight: FontWeight.bold, // Bolder
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: isDark ? Colors.grey : Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: primaryTextColor,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SIGN UP SCREEN (Updated Styling) ---
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _handleSignUp() {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    String inputEmail = _emailController.text.trim().toLowerCase();
    bool isValidDomain = inputEmail.endsWith('@learner.manipal.edu') ||
        inputEmail.endsWith('@manipal.edu');

    if (!isValidDomain) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only @learner.manipal.edu or @manipal.edu emails allowed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        String type = inputEmail.endsWith('@manipal.edu') ? 'staff' : 'student';

        currentUser = UserProfile(
          id: _idController.text,
          name: _nameController.text,
          email: _emailController.text,
          userType: type,
          walletBalance: 0.0,
          bookings: [],
          transactions: [],
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
              (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${_nameController.text}! Account created.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- MATCHING LOGIN SCREEN COLORS ---
    final primaryTextColor = isDark ? Colors.cyanAccent : Colors.blueAccent.shade700;
    final neonGrey = isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade700;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Let's get started",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor // <--- NEON BLUE
              ),
            ),
            Text(
              "Create an account to manage charging",
              style: TextStyle(
                  color: neonGrey, // <--- NEON SILVER
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _nameController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(color: neonGrey),
                prefixIcon: Icon(Icons.person_outline, color: neonGrey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: neonGrey.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryTextColor), borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'MAHE Email',
                labelStyle: TextStyle(color: neonGrey),
                prefixIcon: Icon(Icons.email_outlined, color: neonGrey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: neonGrey.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryTextColor), borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Registration/Staff ID',
                labelStyle: TextStyle(color: neonGrey),
                prefixIcon: Icon(Icons.badge_outlined, color: neonGrey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: neonGrey.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryTextColor), borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passController,
              obscureText: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: neonGrey),
                prefixIcon: Icon(Icons.lock_outline, color: neonGrey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: neonGrey.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryTextColor), borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B), // Kept original Teal for Sign Up to distinguish
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MAIN NAVIGATION CONTAINER ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MapViewScreen(),
    const BookingsScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        indicatorColor: const Color(0xFF00796B).withValues(alpha: 0.2),
        elevation: 2,
        backgroundColor: Theme.of(context).cardTheme.color,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF00796B)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: Color(0xFF00796B)),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note, color: Color(0xFF00796B)),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet, color: Color(0xFF00796B)),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFF00796B)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// --- HOME SCREEN ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _filterType = 'all';

  // New helper to get the primary vehicle's connector type
  String? get primaryConnectorType {
    if (currentUser.vehicles.isEmpty) return null;
    return currentUser.vehicles.firstWhere(
          (v) => v.isPrimary,
      orElse: () => currentUser.vehicles.first, // Fallback to first vehicle if no primary is explicitly set
    ).connectorType;
  }

  List<Station> get filteredStations {
    // Start with all stations
    Iterable<Station> stations = mockStations;

    if (_filterType == 'available') {
      stations = stations.where((s) => s.availablePorts > 0);
    } else if (_filterType == 'fast') {
      stations = stations.where((s) => s.isFastCharger);
    } else if (_filterType == 'compatible') {
      final requiredConnector = primaryConnectorType;
      // Only filter if the user has a vehicle with a known connector type
      if (requiredConnector != null) {
        stations = stations.where((s) => s.connectorType == requiredConnector);
      }
    }

    // Return the final list of stations
    return stations.toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = mockNotifications.any((n) => !n.read);

    // Get the name of the primary vehicle for the compatible filter chip label
    final primaryVehicleName = currentUser.vehicles.isEmpty
        ? null
        : (currentUser.vehicles.firstWhere(
          (v) => v.isPrimary,
      orElse: () => currentUser.vehicles.first,
    )).make; // Use make/brand for the display name

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Stations', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                if (hasUnread)
                  Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), constraints: const BoxConstraints(minWidth: 8, minHeight: 8))),
              ],
            ),
          ),
        ],
      ),
      // --- NEW: QR SCANNER BUTTON ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScanScreen())),
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text("Scan QR"),
      ),
      // -----------------------------
      body: Column(
        children: [
          // Quick Stats
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF00796B),
            child: Row(
              children: [
                Expanded(child: _StatCard(icon: Icons.ev_station, value: '${mockStations.fold(0, (sum, s) => sum + s.availablePorts)}', label: 'Available Ports')),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(icon: Icons.local_parking, value: '${mockStations.fold(0, (sum, s) => sum + s.availableParking)}', label: 'Parking Spots')),
              ],
            ),
          ),
          // Filters
          SingleChildScrollView( // Added to prevent overflow if many chips are added later
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(label: 'All', selected: _filterType == 'all', onTap: () => setState(() => _filterType = 'all')),
                const SizedBox(width: 8),
                _FilterChip(label: 'Available', selected: _filterType == 'available', onTap: () => setState(() => _filterType = 'available')),
                const SizedBox(width: 8),
                _FilterChip(label: 'Fast Charging', selected: _filterType == 'fast', onTap: () => setState(() => _filterType = 'fast')),
                const SizedBox(width: 8),
                // --- NEW: COMPATIBLE FILTER CHIP ---
                if (primaryVehicleName != null)
                  _FilterChip(
                      label: '$primaryVehicleName Compatible',
                      selected: _filterType == 'compatible',
                      onTap: () => setState(() => _filterType = 'compatible')
                  ),
                // -----------------------------------
              ],
            ),
          ),
          // List
          Expanded(
            child: filteredStations.isEmpty
                ? Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.charging_station_outlined, size: 72, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                    _filterType == 'compatible' && primaryVehicleName != null
                        ? 'No $primaryVehicleName Compatible stations found.'
                        : 'No stations found.',
                    style: const TextStyle(fontSize: 18, color: Colors.grey)
                ),
                if (_filterType == 'compatible' && primaryVehicleName == null)
                  const Text('Add a vehicle to enable compatible filtering.', style: TextStyle(fontSize: 14, color: Colors.grey))
              ],
            ))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredStations.length,
              itemBuilder: (context, index) => StationCard(station: filteredStations[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00796B) : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: selected ? null : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// --- STATION CARD WIDGET ---
class StationCard extends StatelessWidget {
  final Station station;
  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = station.availablePorts > 0;
    bool hasParking = station.availableParking > 0;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StationDetailScreen(station: station)));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(station.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                            const SizedBox(width: 4),
                            // Use a higher opacity/darker color for better visibility
                            Text(
                                '${station.location} • ${station.distance}km',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8), // Darker/Clearer text
                                    fontSize: 13
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isAvailable ? Colors.green : Colors.red),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Full',
                      style: TextStyle(color: isAvailable ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.ev_station, size: 18, color: station.isFastCharger ? const Color(0xFFE65100) : Colors.grey),
                  const SizedBox(width: 6),
                  Text(station.isFastCharger ? 'Fast Charger (60W)' : 'Standard Charger', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                  const Spacer(),
                  if (station.isSolarPowered)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.wb_sunny, size: 12, color: Colors.green),
                          SizedBox(width: 4),
                          Text('Solar', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.local_parking, size: 18, color: hasParking ? Colors.blue : Colors.grey),
                  const SizedBox(width: 6),
                  Text('Parking: ${station.availableParking}/${station.parkingSpaces}', style: const TextStyle(fontSize: 13)),
                  const Spacer(),
                  Text('₹${station.pricePerUnit}/kWh', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- MAP VIEW SCREEN ---
class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  // State variable to track if location is enabled
  bool _showUserLocation = false;

  // Function to simulate asking for permission
  void _askLocationPermission() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Use Location?"),
        content: const Text("MAHE EV Charging needs access to your location to show nearby stations."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Deny")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _showUserLocation = true); // Turn on the blue dot
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location enabled")));
            },
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Simulated Map Background (YOUR ORIGINAL CODE KEPT INTACT)
          Container(
            color: const Color(0xFFE1E6EA),
            child: Stack(
              children: [
                Positioned(top: 100, left: 0, right: 0, height: 20, child: Container(color: Colors.white)),
                Positioned(top: 0, bottom: 0, left: 150, width: 20, child: Container(color: Colors.white)),
                Positioned(top: 300, left: 0, right: 0, height: 30, child: Container(color: Colors.white)),
                const Positioned(top: 120, left: 20, child: Text("MIT CAMPUS", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                const Positioned(bottom: 100, right: 20, child: Text("KMC AREA", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
              ],
            ),
          ),

          // 2. Stations Markers (YOUR ORIGINAL LOGIC KEPT INTACT)
          ...mockStations.map((station) {
            return Positioned(
              left: MediaQuery.of(context).size.width * station.mapX,
              top: MediaQuery.of(context).size.height * station.mapY,
              child: GestureDetector(
                onTap: () {
                  // KEEPING YOUR DETAILED BOTTOM SHEET
                  showModalBottomSheet(
                    context: context,
                    builder: (c) => Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(station.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: station.availablePorts > 0 ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: station.availablePorts > 0 ? Colors.green : Colors.red),
                                ),
                                child: Text(
                                  station.availablePorts > 0 ? 'Available' : 'Full',
                                  style: TextStyle(color: station.availablePorts > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(station.location, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(width: 16),
                              const Icon(Icons.local_parking, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${station.availableParking} spots', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => StationDetailScreen(station: station)));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
                              child: const Text("View Details & Book"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: station.availablePorts > 0 ? const Color(0xFF00796B) : Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.ev_station, color: Colors.white, size: 20),
                    ),
                    // Added a tiny label below the icon for better visibility
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                      child: Text(station.name.split(' ').first, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            );
          }),

          // 3. (NEW) USER LOCATION DOT - Only shows if permission granted
          if (_showUserLocation)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 5)],
                ),
              ),
            )
          else
          // If location OFF, show the old static center crosshair
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: const Icon(Icons.navigation, color: Colors.blue, size: 12),
              ),
            ),

          // 4. Search Bar (YOUR ORIGINAL CODE)
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text("Search location...", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),

          // 5. (NEW) LOCATE ME BUTTON - Bottom Right Corner
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              heroTag: "btn_locate", // Unique tag to prevent errors
              onPressed: _askLocationPermission,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// --- STATION DETAIL SCREEN ---
class StationDetailScreen extends StatefulWidget {
  final Station station;
  const StationDetailScreen({super.key, required this.station});

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  String _selectedSlot = 'now';

  // --- REPORT ISSUE LOGIC ---
  void _showReportDialog() {
    final noteController = TextEditingController();
    String selectedIssue = "Charger not working";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Report Issue"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("What seems to be the problem?", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: selectedIssue,
                    isExpanded: true,
                    items: ["Charger not working", "Payment Issue", "Parking Blocked", "Screen Broken", "Other"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setDialogState(() => selectedIssue = v!),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: "Details (Optional)", border: OutlineInputBorder()),
                    maxLines: 2,
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                    onPressed: () {
                      setState(() {
                        mockIssues.add(ReportedIssue(
                            id: "REP_${DateTime.now().millisecondsSinceEpoch}",
                            stationName: widget.station.name,
                            reportedBy: currentUser.name,
                            issueType: selectedIssue,
                            time: DateTime.now()
                        ));
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Issue Reported. Admin notified.")));
                    },
                    child: const Text("Report")
                ),
              ],
            );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
        // Removed actions[] block here to remove top-right button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.station.isSolarPowered)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF00796B)),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.solar_power, size: 40, color: Color(0xFF00796B)),
                    SizedBox(height: 8),
                    Text('Solar Powered Station', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
                    Text('Zero GST • Clean Energy', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _InfoBox(title: 'Output', value: widget.station.isSharedPower ? '30 kW' : '60 kW', color: Colors.orange, icon: Icons.bolt)),
                const SizedBox(width: 12),
                Expanded(child: _InfoBox(title: 'Ports', value: '${widget.station.availablePorts}/${widget.station.totalPorts}', color: Colors.blue, icon: Icons.ev_station)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _InfoBox(title: 'Parking', value: '${widget.station.availableParking}/${widget.station.parkingSpaces}', color: Colors.green, icon: Icons.local_parking)),
                const SizedBox(width: 12),
                Expanded(child: _InfoBox(title: 'Price', value: '₹${widget.station.pricePerUnit}/kWh', color: const Color(0xFF00796B), icon: Icons.currency_rupee)),
              ],
            ),
            if (widget.station.isSharedPower)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('* Power split when multiple vehicles charging', style: TextStyle(color: Colors.orange, fontSize: 12)),
              ),
            const SizedBox(height: 24),
            const Text('Select Time Slot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TimeSlotChip(label: "Now", value: "now", selected: _selectedSlot == "now", onTap: () => setState(() => _selectedSlot = "now")),
                _TimeSlotChip(label: "10:30 AM", value: "10:30", selected: _selectedSlot == "10:30", onTap: () => setState(() => _selectedSlot = "10:30")),
                _TimeSlotChip(label: "11:00 AM", value: "11:00", selected: _selectedSlot == "11:00", onTap: () => setState(() => _selectedSlot = "11:00")),
                _TimeSlotChip(label: "12:00 PM", value: "12:00", selected: _selectedSlot == "12:00", onTap: () => setState(() => _selectedSlot = "12:00")),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Booking Fee (Refundable)', style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('₹50', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // FIX: Use highly visible color based on theme for Estimated Cost Label
                      Text(
                          'Estimated Cost',
                          style: TextStyle(
                            fontSize: 14,
                            // Use high contrast color (black87 for light, white70 for dark)
                            color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70,
                            fontWeight: FontWeight.w500,
                          )
                      ),
                      // FIX: Use highly visible color based on theme for Estimated Cost Value
                      Text(
                          '₹${widget.station.pricePerUnit * 10}/hr',
                          style: TextStyle(
                            fontSize: 14,
                            // Use high contrast color
                            color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white70,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56, // <--- INCREASED HEIGHT TO PREVENT CUTOFF (50 -> 56)
              child: ElevatedButton(
                onPressed: widget.station.availablePorts > 0
                    ? () {
                  if (currentUser.walletBalance < 50) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Insufficient balance. Please add money to wallet.')),
                    );
                    return;
                  }
                  _showBookingConfirmation(context);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16), // Ensure vertical padding is consistent
                ),
                child: const Text('Book Slot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            // --- CLEAN REPORT BUTTON AT BOTTOM ---
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: _showReportDialog,
                icon: const Icon(Icons.flag_outlined, size: 18, color: Colors.grey),
                label: const Text("Report an Issue with this Station", style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Station: ${widget.station.name}'),
            Text('Time: ${_selectedSlot == "now" ? "Start Now" : _selectedSlot}'),
            const SizedBox(height: 8),
            const Text('Booking fee of ₹50 will be deducted.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const Text('Refundable if cancelled within 10 mins.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                currentUser.walletBalance -= 50;
                widget.station.availablePorts -= 1;
                currentUser.bookings.add(Booking(
                  id: 'B${DateTime.now().millisecondsSinceEpoch}',
                  stationId: widget.station.id,
                  stationName: widget.station.name,
                  bookingTime: DateTime.now(),
                  cost: 50,
                  status: 'active',
                ));
              });
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChargingScreen(station: widget.station)),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _InfoBox({required this.title, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _TimeSlotChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00796B) : (isDark ? Colors.grey.withValues(alpha: 0.1) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? const Color(0xFF00796B) : Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Text(label, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal, color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface)),
      ),
    );
  }
}

// --- CHARGING SCREEN ---
class ChargingScreen extends StatefulWidget {
  final Station station;
  const ChargingScreen({super.key, required this.station});

  @override
  State<ChargingScreen> createState() => _ChargingScreenState();
}

// --- CHARGING SCREEN (UPDATED with Pause/Resume and Charge Limit) ---
// --- CHARGING SCREEN (FIXED: Safe Exit if No Vehicle) ---
class _ChargingScreenState extends State<ChargingScreen> {
  Timer? _timer;
  double _cost = 0.0;
  double _unitsConsumed = 0.0;
  bool _active = true;
  DateTime? _startTime;

  // State for control and visualization
  bool _isPaused = false;
  double _chargeLimit = 0.0;

  // Safely find the primary vehicle once
  final Vehicle? _chargingVehicle = currentUser.vehicles.where((v) => v.isPrimary).isNotEmpty
      ? currentUser.vehicles.firstWhere((v) => v.isPrimary)
      : (currentUser.vehicles.isNotEmpty ? currentUser.vehicles.first : null);

  double _startKWh = 0.0;
  double _maxKWh = 0.0;
  int _currentSOC = 0;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // --- SAFE EXIT LOGIC (NEW) ---
    if (_chargingVehicle == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Show a helpful message and pop the screen safely
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot start charging. Please add a primary EV in Profile > Vehicles.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      });
      return; // Stop initialization if no vehicle is present
    }
    // ----------------------------

    // Initialize charging parameters only if vehicle is present
    _maxKWh = _chargingVehicle.batteryCapacityKWh;
    _startKWh = _maxKWh * (_chargingVehicle.initialSOCPercent / 100);
    _unitsConsumed = 0.0;
    _currentSOC = _chargingVehicle.initialSOCPercent;
    _chargeLimit = _maxKWh; // Default limit is 100% (full battery)

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted && _active && !_isPaused) {
        setState(() {
          double newUnitsConsumed = _unitsConsumed + 0.1; // 0.1 kWh/sec

          double totalKWh = _startKWh + newUnitsConsumed;

          if (totalKWh >= _chargeLimit) {
            _unitsConsumed = _chargeLimit - _startKWh;
            _currentSOC = 100;
            _cost = _unitsConsumed * widget.station.pricePerUnit;
            _stopCharging(limitReached: true);
            return;
          }

          _unitsConsumed = newUnitsConsumed;
          _cost = _unitsConsumed * widget.station.pricePerUnit;
          _currentSOC = ((totalKWh / _maxKWh) * 100).round();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- CONTROL LOGIC METHODS (Unchanged from previous turn) ---

  void _togglePause() {
    if (!_active) return;
    setState(() {
      _isPaused = !_isPaused;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isPaused ? 'Charging Paused.' : 'Charging Resumed.')),
      );
    });
  }

  void _showChargeLimitDialog() {
    final controller = TextEditingController(text: _chargeLimit < _maxKWh ? _chargeLimit.toStringAsFixed(1) : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Charge Limit (kWh)'),
        content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Energy Limit (kWh) [Max: ${_maxKWh.toStringAsFixed(1)} kWh]',
                hintText: 'e.g., 20.0',
                border: const OutlineInputBorder()
            )
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text) ?? 0;
                if (val > 0.0 && val <= _maxKWh) {
                  setState(() => _chargeLimit = val);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Charge limit set to ${val.toStringAsFixed(1)} kWh')),
                  );
                } else if (val > _maxKWh) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Limit cannot exceed max capacity (${_maxKWh.toStringAsFixed(1)} kWh)')),
                  );
                } else {
                  setState(() => _chargeLimit = _maxKWh);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Charge limit removed (Charging to 100%).')),
                  );
                }
              },
              child: const Text('Set Limit')
          ),
        ],
      ),
    );
  }

  void _stopCharging({bool limitReached = false}) {
    if (!_active) return;

    _timer?.cancel();
    setState(() => _active = false);

    if (limitReached) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Charge limit of ${_chargeLimit.toStringAsFixed(1)} kWh reached! Processing payment...')),
      );
    }
    _showPaymentDialog();
  }

  // --- BUILD METHOD (Updated for Safe Exit) ---

  @override
  Widget build(BuildContext context) {
    // Check if we exited early in initState (Vehicle == null).
    // If _chargingVehicle is null, this widget tree will not be built and
    // the app will have navigated back. But we still need a safe fallback.
    if (_chargingVehicle == null) {
      // This case should be rare, as initState should handle navigation, but it prevents crashes.
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("Initializing...", style: TextStyle(color: Colors.white))),
      );
    }

    // Normal build logic continues if vehicle is found
    final duration = _startTime != null ? DateTime.now().difference(_startTime!) : Duration.zero;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF001F1A) : const Color(0xFF00796B),
      appBar: AppBar(
        title: Text("Charging ${_chargingVehicle.make}"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          // Charge Limit Button
          IconButton(
            icon: Icon(Icons.speed, color: _chargeLimit < _maxKWh ? Colors.amberAccent : Colors.white),
            tooltip: _chargeLimit < _maxKWh ? 'Limit: ${_chargeLimit.toStringAsFixed(1)} kWh' : 'Charging to 100%',
            onPressed: _active ? _showChargeLimitDialog : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // --- CHARGING PROGRESS VISUALIZATION ---
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 1. Neon Circular Progress Indicator
                          SizedBox(
                            width: 180,
                            height: 180,
                            child: CircularProgressIndicator(
                              value: _currentSOC / 100, // 0.0 to 1.0
                              strokeWidth: 10,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              color: _isPaused ? Colors.grey : Colors.cyanAccent, // Neon Color
                            ),
                          ),
                          // 2. Inner Content
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_currentSOC%',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyanAccent, // Neon Text
                                  shadows: [
                                    Shadow(color: Colors.cyan, blurRadius: 10.0), // Neon Glow
                                  ],
                                ),
                              ),
                              Text(
                                _isPaused ? 'PAUSED' : 'CHARGING',
                                style: TextStyle(
                                  color: _isPaused ? Colors.grey : Colors.lightGreenAccent,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          // 3. Charging Bolt Indicator
                          if (!_isPaused)
                            const Positioned(
                              top: 20,
                              right: 20,
                              child: Icon(Icons.flash_on, color: Colors.amber, size: 30),
                            ),
                        ],
                      ),
                    ),
                    // ----------------------------------------
                    const SizedBox(height: 30),
                    const Text('LIVE COST', style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2)),
                    const SizedBox(height: 10),
                    Text(
                      '₹ ${_cost.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 30),

                    // Stats Box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Units Consumed', style: TextStyle(color: Colors.white70)),
                              Text('${_unitsConsumed.toStringAsFixed(2)} kWh', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Duration', style: TextStyle(color: Colors.white70)),
                              Text('${duration.inMinutes}m ${duration.inSeconds % 60}s', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Rate', style: TextStyle(color: Colors.white70)),
                              Text('₹${widget.station.pricePerUnit}/kWh', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Control Buttons
              if (_active)
                Row(
                  children: [
                    // Pause/Resume Button
                    SizedBox(
                      width: 150,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: _togglePause,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                        label: Text(_isPaused ? "Resume" : "Pause", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Stop & Pay Button
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _stopCharging(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.stop_circle_outlined),
                          label: const Text("Stop & Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              else
                const Text('Processing payment...', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  // --- FIX: _showPaymentDialog to allow dismissal/return ---
  void _showPaymentDialog() {
    double gst = _cost * 0.05; // 5% GST
    double totalPayable = (_cost + gst) - 50; // Cost + GST - Booking Refund
    if (totalPayable < 0) totalPayable = 0;

    showDialog(
      context: context,
      barrierDismissible: true, // <--- ALLOW TAPPING OUT TO DISMISS (FIX 1)
      builder: (context) => AlertDialog(
        title: const Text('Payment Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ... (Existing content remains the same)
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Energy Charges:'),
              Text('₹${_cost.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('GST (5%):'),
              Text('₹${gst.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ]),
            const Divider(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Booking Refund:'),
              const Text('- ₹50.00', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ]),
            const Divider(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Total Payable:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('₹${totalPayable.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
            ]),
          ],
        ),
        actions: [
          // RETURN/CANCEL BUTTON (FIX 2)
          TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Resume the charging session
                _timer = Timer.periodic(const Duration(seconds: 1), (t) {
                  if (mounted && _active && !_isPaused) {
                    // Re-apply the original timer logic inside the controller's scope
                    setState(() {
                      double newUnitsConsumed = _unitsConsumed + 0.1;

                      double totalKWh = _startKWh + newUnitsConsumed;

                      if (totalKWh >= _chargeLimit) {
                        _unitsConsumed = _chargeLimit - _startKWh;
                        _currentSOC = 100;
                        _cost = _unitsConsumed * widget.station.pricePerUnit;
                        _stopCharging(limitReached: true);
                        return;
                      }

                      _unitsConsumed = newUnitsConsumed;
                      _cost = _unitsConsumed * widget.station.pricePerUnit;
                      _currentSOC = ((totalKWh / _maxKWh) * 100).round();
                    });
                  }
                });
                setState(() => _active = true); // Set charging back to active
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Charging resumed!'), duration: Duration(seconds: 1)));
              },
              child: const Text('Return to Charging')
          ),

          // PAY SECURELY BUTTON
          ElevatedButton(
            onPressed: () {
              // ... (Existing payment logic remains the same)
              setState(() {
                currentUser.walletBalance -= totalPayable;
                widget.station.availablePorts += 1;
                // Add to booking history as completed (simplified logic)
              });
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigation()),
                    (route) => false,
              );
            },
            child: const Text('Pay Securely'),
          ),
        ],
      ),
    );
  }
}
// --- BOOKINGS SCREEN ---
class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeBookings = currentUser.bookings.where((b) => b.status == 'active').toList();
    final completedBookings = currentUser.bookings.where((b) => b.status == 'completed').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeBookings.isNotEmpty) ...[
            const Text('Active Bookings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...activeBookings.map((booking) => _BookingCard(booking: booking, isActive: true)),
          ],
          if (completedBookings.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text('Completed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...completedBookings.map((booking) => _BookingCard(booking: booking, isActive: false)),
          ],
          if (currentUser.bookings.isEmpty)
            Center(
              child: Column(
                children: const [
                  SizedBox(height: 100),
                  Icon(Icons.event_note_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No bookings yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isActive;

  const _BookingCard({required this.booking, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(booking.stationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isActive ? Colors.green : Colors.grey),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Completed',
                    style: TextStyle(color: isActive ? Colors.green : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Booked: ${_formatDateTime(booking.bookingTime)}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 12),
            if (isActive)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showCancellationDialog(context, booking);
                  },
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Cancel Booking'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCancellationDialog(BuildContext context, Booking booking) {
    final timeDiff = DateTime.now().difference(booking.bookingTime);
    final canRefund = timeDiff.inMinutes <= 10;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: Text(
          canRefund
              ? 'You will get full refund of ₹50 as you are cancelling within 10 minutes.'
              : 'Cancellation charges of ₹20 will be applied. You will get ₹30 refund.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          ElevatedButton(
            onPressed: () {
              currentUser.bookings.removeWhere((b) => b.id == booking.id);
              currentUser.walletBalance += canRefund ? 50 : 30;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Booking cancelled. ₹${canRefund ? 50 : 30} refunded.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// --- WALLET SCREEN ---
// --- WALLET SCREEN (FIXED SPACING) ---
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We use StatefulBuilder so the Balance updates on the screen immediately
    return StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            appBar: AppBar(title: const Text('Campus Wallet', style: TextStyle(fontWeight: FontWeight.bold))),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // 1. Balance Card (KEPT ORIGINAL UI)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00796B), Color(0xFF004D40)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.account_balance_wallet, size: 60, color: Colors.white),
                        const SizedBox(height: 16),
                        const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                            '₹ ${currentUser.walletBalance.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          // Pass 'setState' so the dialog can update the screen
                          onPressed: () => _showAddMoneyDialog(context, setState),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Money"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF00796B)
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Info Cards (KEPT ORIGINAL UI)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _QuickInfoCard(icon: Icons.savings_outlined, title: 'Total Saved', value: '₹120', subtitle: 'vs Third-party apps')),
                        const SizedBox(width: 12),
                        Expanded(child: _QuickInfoCard(icon: Icons.eco_outlined, title: 'CO₂ Saved', value: '45 kg', subtitle: 'Using solar power')),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Quick Add Section (FIXED SPACING)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Quick Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      // INCREASED SPACING HERE
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.start, // Aligns them nicely to the left
                      children: [
                        _QuickAddChip(amount: 100, onTap: () => _processAddMoney(context, setState, 100)),
                        _QuickAddChip(amount: 200, onTap: () => _processAddMoney(context, setState, 200)),
                        _QuickAddChip(amount: 500, onTap: () => _processAddMoney(context, setState, 500)),
                        _QuickAddChip(amount: 1000, onTap: () => _processAddMoney(context, setState, 1000)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. FUNCTIONAL LINKS (KEPT ORIGINAL UI)
                  ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: const Text('Transaction History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: const Text('Linked ICICI Bank Account'),
                    subtitle: const Text('••••1234'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BankDetailsScreen()));
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _showAddMoneyDialog(BuildContext context, StateSetter setState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Money'),
        content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹ ', border: OutlineInputBorder())
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text) ?? 0;
                if (val > 0) {
                  // FIXED: Close dialog FIRST, then add money
                  Navigator.pop(context);
                  _processAddMoney(context, setState, val);
                }
              },
              child: const Text('Add')
          ),
        ],
      ),
    );
  }

  // FIXED LOGIC: Does not contain Navigator.pop(), so it's safe for Quick Add chips
  void _processAddMoney(BuildContext context, StateSetter setState, double amount) {
    // 1. Update Global State
    currentUser.walletBalance += amount;

    // 2. Add Fake Transaction
    currentUser.transactions.insert(0, Transaction(
        id: "ADD${DateTime.now().millisecondsSinceEpoch}",
        title: "Wallet Top-up",
        date: DateTime.now(),
        amount: amount,
        isCredit: true
    ));

    // 3. Update Local UI State
    setState(() {});

    // 4. Show Feedback
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('₹${amount.toStringAsFixed(0)} added successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        )
    );
  }
}

class _QuickInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _QuickInfoCard({required this.icon, required this.title, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00796B)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  final double amount;
  final VoidCallback onTap;

  const _QuickAddChip({required this.amount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF00796B).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00796B)),
        ),
        child: Text('₹$amount', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B))),
      ),
    );
  }
}

// --- PROFILE SCREEN (UPDATED) ---
// --- PROFILE SCREEN (UPDATED with Vehicle Management) ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: isDark ? Border.all(color: Colors.white10) : null,
              boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00796B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentUser.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          currentUser.email,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7) // Use a clearer, darker shade of the primary text color
                          )
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          currentUser.userType.toUpperCase(),
                          style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // VEHICLES SECTION (NEW)
          const Text('Vehicle & Charging', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _SettingsTile(
              icon: Icons.directions_car_outlined,
              title: 'Vehicle Management',
              // Use a noticeable color for the count text
              trailing: Text(
                  '${currentUser.vehicles.length} vehicles',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary // Use the MAHE Teal color
                  )
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleScreen()));
              }
          ),

          const SizedBox(height: 24),

          // APPEARANCE SECTION
          const Text('Appearance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.orange),
              title: const Text('Dark Mode'),
              trailing: Switch.adaptive(
                value: isDark,
                activeColor: const Color(0xFF00796B),
                onChanged: (value) {
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text('Statistics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatBox(icon: Icons.bolt, value: '24', label: 'Sessions')),
              const SizedBox(width: 12),
              Expanded(child: _StatBox(icon: Icons.eco, value: '120 kWh', label: 'Clean Energy')),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // --- EXISTING SETTINGS ---
          _SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
              }
          ),
          _SettingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
              }
          ),
          _SettingsTile(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
              }
          ),
          _SettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              },
              isDestructive: true
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatBox({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF00796B), size: 32),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

// --- FIXED _SettingsTile WIDGET ---
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing; // <--- ADDED TRAILING FIELD

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.trailing, // <--- ADDED TRAILING PARAMETER
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : null),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
      // If trailing is null, use the default chevron; otherwise, use the provided widget
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// --- NOTIFICATIONS SCREEN (Updated with Cards to fix overflow) ---
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // We use the global mockNotifications so read state persists
  List<AppNotification> get notifications => mockNotifications;

  void _markAllRead() {
    setState(() {
      for (var n in notifications) {
        n.read = true;
      }
    });
  }

  void _clearAll() {
    setState(() {
      notifications.clear();
    });
  }

  void _toggleRead(AppNotification n) {
    setState(() {
      n.read = !n.read;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(onPressed: _markAllRead, icon: const Icon(Icons.mark_email_read)),
          if (notifications.isNotEmpty)
            IconButton(onPressed: _clearAll, icon: const Icon(Icons.delete_forever)),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.notifications_off_outlined, size: 72, color: Colors.grey),
            SizedBox(height: 12),
            Text('No notifications', style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = notifications[index];

          return Card(
            elevation: 0,
            color: n.read
                ? Theme.of(context).cardTheme.color
                : const Color(0xFF00796B).withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color: n.read ? Colors.transparent : const Color(0xFF00796B), width: 1),
            ),
            child: InkWell(
              onTap: () => _toggleRead(n),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            n.title,
                            style: TextStyle(
                              fontWeight: n.read ? FontWeight.normal : FontWeight.bold,
                              fontSize: 16,
                              color: n.read
                                  ? Theme.of(context).colorScheme.onSurface
                                  : const Color(0xFF00796B),
                            ),
                          ),
                        ),
                        Text(
                          _formatDateTime(n.time),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      n.body,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
// --- NEW SETTINGS SCREENS ---

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _promoEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Preferences')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSwitchTile('Push Notifications', 'Receive real-time updates about charging status', _pushEnabled, (v) => setState(() => _pushEnabled = v)),
          const Divider(),
          _buildSwitchTile('Email Alerts', 'Get receipts and low balance warnings via email', _emailEnabled, (v) => setState(() => _emailEnabled = v)),
          const Divider(),
          _buildSwitchTile('Promotional Offers', 'Deals on charging rates and events', _promoEnabled, (v) => setState(() => _promoEnabled = v)),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      value: value,
      activeColor: const Color(0xFF00796B),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      onChanged: onChanged,
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildFaqTile('How do I start charging?', 'Scan the QR code at the station or select the station from the map and click "Book Slot".'),
          _buildFaqTile('How is the cost calculated?', 'Cost is calculated based on the energy consumed (kWh) multiplied by the station\'s rate per unit.'),
          _buildFaqTile('Can I cancel a booking?', 'Yes, you can cancel within 10 minutes for a full refund. After that, a cancellation fee applies.'),
          _buildFaqTile('What payment methods are accepted?', 'We currently support campus wallet, which can be topped up via UPI or Net Banking.'),
          const SizedBox(height: 24),
          const Text('Contact Us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined, color: Color(0xFF00796B)),
              title: const Text('Email Support'),
              subtitle: const Text('support@mahe.ev.edu'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone_outlined, color: Color(0xFF00796B)),
              title: const Text('Helpline'),
              subtitle: const Text('+91 98765 43210'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00796B).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bolt_rounded, size: 60, color: Color(0xFF00796B)),
            ),
            const SizedBox(height: 24),
            const Text('MAHE EV Charging', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'A sustainable campus initiative to promote electric vehicle usage and green energy at Manipal Academy of Higher Education.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.5),
              ),
            ),
            const Spacer(),
            const Text('© 2025 MAHE Manipal', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// 1. QR SCANNER SCREEN (Simulated Camera - FIXED)
class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});
  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool _scanning = true;

  @override
  void initState() {
    super.initState();
    _startScanSimulation();
  }

  void _startScanSimulation() async {
    // Simulate finding a code after 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _scanning = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("QR Code Detected"),
        content: const Text("Station: MIT Quadrangle\nID: #001"),
        actions: [
          // FIXED: Now properly closes scanner and goes back
          TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close scanner screen
              },
              child: const Text("Cancel")
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Go to charging screen (using first mock station)
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChargingScreen(station: mockStations[0]))
              );
            },
            child: const Text("Start Charging"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // FIXED: Added SafeArea to prevent notch overlap (This fixes the frozen button)
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity, height: double.infinity,
                color: Colors.grey.shade900,
                child: const Center(child: Text("Camera View", style: TextStyle(color: Colors.white54))),
              ),
            ),
            Center(
              child: Container(
                width: 250, height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: _scanning ? Colors.green : Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _scanning
                    ? const Center(child: CircularProgressIndicator(color: Colors.green))
                    : const Icon(Icons.check_circle, color: Colors.green, size: 60),
              ),
            ),
            // FIXED: 'X' Button is now visible, has a background, and is tappable
            Positioned(
                top: 20,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 20,
                  child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context)
                  ),
                )
            ),
            const Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Text(
                    "Align QR code within frame",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16)
                )
            ),
          ],
        ),
      ),
    );
  }
}

// 2. TRANSACTION HISTORY SCREEN (Corrected)
class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: ListView.separated(
        itemCount: currentUser.transactions.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final t = currentUser.transactions[index];
          return ListTile(
            leading: CircleAvatar(
              // USE .withValues(alpha: 0.2)
              backgroundColor: t.isCredit
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              child: Icon(
                  t.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: t.isCredit ? Colors.green : Colors.red
              ),
            ),
            title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${t.date.day}/${t.date.month}/${t.date.year}"),
            trailing: Text(
              "${t.isCredit ? '+' : '-'} ₹${t.amount.toStringAsFixed(0)}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: t.isCredit ? Colors.green : Colors.red,
                  fontSize: 16
              ),
            ),
          );
        },
      ),
    );
  }
}
// 3. BANK DETAILS SCREEN (Adaptive: Dark for Admin, Light for User)
class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

// Simple model for a bank account
class BankAccount {
  String id;
  String bankName;
  String accountNumber;
  String holderName;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.holderName
  });
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  // Initial Mock Data
  List<BankAccount> accounts = [
    BankAccount(id: '1', bankName: 'ICICI BANK', accountNumber: '**** **** **** 1234', holderName: 'ARIHANT K'),
  ];

  // Track which account is what
  String? _primaryAccountId = '1';
  String? _secondaryAccountId;

  // Controllers
  final _bankController = TextEditingController();
  final _accController = TextEditingController();
  final _holderController = TextEditingController();

  void _addAccount() {
    _bankController.clear();
    _accController.clear();
    _holderController.clear();

    // Check theme for Dialog
    final isDark = currentUser.isAdmin || Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final inputStyle = TextStyle(color: textColor);
    final hintStyle = TextStyle(color: isDark ? Colors.grey : Colors.black54);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBg,
        title: Text("Add Bank Account", style: TextStyle(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _bankController,
                style: inputStyle,
                decoration: InputDecoration(labelText: "Bank Name", labelStyle: hintStyle, enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.grey : Colors.black45)), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00796B))))
            ),
            const SizedBox(height: 12),
            TextField(
                controller: _accController,
                style: inputStyle,
                decoration: InputDecoration(labelText: "Account Number", labelStyle: hintStyle, enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.grey : Colors.black45)), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00796B))))
            ),
            const SizedBox(height: 12),
            TextField(
                controller: _holderController,
                style: inputStyle,
                decoration: InputDecoration(labelText: "Holder Name", labelStyle: hintStyle, enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.grey : Colors.black45)), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF00796B))))
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
            onPressed: () {
              if (_bankController.text.isNotEmpty) {
                setState(() {
                  accounts.add(BankAccount(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    bankName: _bankController.text.toUpperCase(),
                    accountNumber: _accController.text,
                    holderName: _holderController.text.toUpperCase(),
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  void _deleteAccount(String id) {
    setState(() {
      accounts.removeWhere((a) => a.id == id);
      if (_primaryAccountId == id) _primaryAccountId = null;
      if (_secondaryAccountId == id) _secondaryAccountId = null;
    });
  }

  void _setPrimary(String id) {
    setState(() {
      _primaryAccountId = id;
      if (_secondaryAccountId == id) _secondaryAccountId = null;
    });
  }

  void _setSecondary(String id) {
    setState(() {
      _secondaryAccountId = id;
      if (_primaryAccountId == id) _primaryAccountId = null;
    });
  }

  // View Details Dialog
  void _viewAccountDetails(BankAccount acc) {
    final isDark = currentUser.isAdmin || Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBg,
        title: Text(acc.bankName, style: TextStyle(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Account Number:", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text(acc.accountNumber, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            const Text("Account Holder:", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text(acc.holderName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            const Text("Status:", style: TextStyle(color: Colors.grey, fontSize: 12)),
            if (_primaryAccountId == acc.id)
              const Text("Primary Account (Active)", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
            else if (_secondaryAccountId == acc.id)
              const Text("Secondary Account (Backup)", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))
            else
              Text("Linked", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- SMART THEME DETECTION (FIX) ---
    // If user is Admin, FORCE Dark Mode. Otherwise use System Mode.
    final isDark = currentUser.isAdmin || Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final appBarColor = isDark ? Colors.red.shade900 : Colors.white; // Red for Admin, White for User
    final iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Manage Bank Accounts"),
        backgroundColor: appBarColor,
        foregroundColor: iconColor,
        actions: [
          IconButton(onPressed: _addAccount, icon: const Icon(Icons.add))
        ],
      ),
      body: accounts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text("No accounts linked", style: TextStyle(color: Colors.grey)),
            TextButton(onPressed: _addAccount, child: const Text("Add Account"))
          ],
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: accounts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final acc = accounts[index];
          final isPrimary = _primaryAccountId == acc.id;
          final isSecondary = _secondaryAccountId == acc.id;

          return InkWell(
            onTap: () => _viewAccountDetails(acc),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                border: isPrimary ? Border.all(color: Colors.green, width: 2) :
                isSecondary ? Border.all(color: Colors.orange, width: 2) : null,
              ),
              child: Column(
                children: [
                  // Bank Card Visual
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: isPrimary
                              ? [const Color(0xFF00796B), const Color(0xFF004D40)]
                              : (isDark ? [Colors.grey.shade800, Colors.black] : [Colors.blueGrey, Colors.grey]),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(acc.bankName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const Icon(Icons.contactless, color: Colors.white70),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(acc.accountNumber, style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2)),
                        const SizedBox(height: 10),
                        Text(acc.holderName, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),

                  // Controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text("Primary (Receive)", style: TextStyle(fontSize: 12, color: textColor)),
                                value: acc.id,
                                groupValue: _primaryAccountId,
                                activeColor: Colors.green,
                                onChanged: (val) => _setPrimary(val!),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text("Secondary (Backup)", style: TextStyle(fontSize: 12, color: textColor)),
                                value: acc.id,
                                groupValue: _secondaryAccountId,
                                activeColor: Colors.orange,
                                onChanged: (val) => _setSecondary(val!),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        TextButton.icon(
                          onPressed: () => _deleteAccount(acc.id),
                          icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                          label: const Text("Unlink Account", style: TextStyle(color: Colors.red)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
//              ADMIN ZONE 🛠️
// ==========================================

// --- 1. ADMIN NAVIGATION CONTAINER ---
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _adminScreens = [
    const AdminHomeScreen(),
    const AdminMapScreen(),
    const AdminUsersScreen(),
    const AdminTransactionMonitor(),
    const AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _adminScreens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        indicatorColor: Colors.redAccent.withValues(alpha: 0.2),
        backgroundColor: Colors.black,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined, color: Colors.grey), selectedIcon: Icon(Icons.dashboard, color: Colors.redAccent), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.add_location_alt_outlined, color: Colors.grey), selectedIcon: Icon(Icons.add_location_alt, color: Colors.redAccent), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.group_outlined, color: Colors.grey), selectedIcon: Icon(Icons.group, color: Colors.redAccent), label: 'Users'),
          NavigationDestination(icon: Icon(Icons.monetization_on_outlined, color: Colors.grey), selectedIcon: Icon(Icons.monetization_on, color: Colors.redAccent), label: 'Finance'),
          NavigationDestination(icon: Icon(Icons.person_outline, color: Colors.grey), selectedIcon: Icon(Icons.person, color: Colors.redAccent), label: 'Admin'),
        ],
      ),
    );
  }
}

// --- 2. ADMIN HOME (List View + Detailed Add Button) ---
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  void _openStationInspector(Station s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StationInspectorSheet(station: s, onUpdate: () => setState(() {})),
    );
  }

  // --- DETAILED ADD DIALOG FOR HOME ---
  // --- DETAILED ADD DIALOG FOR HOME (FIXED for connectorType) ---
  void _addNewStation() {
    final nameController = TextEditingController();
    final locController = TextEditingController();
    final priceController = TextEditingController();
    final spotsController = TextEditingController();
    String selectedConnector = 'CCS Type 2'; // Default connector
    bool isFast = false;
    bool isSolar = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              title: const Text("Add New Charger", style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Station Name", labelStyle: TextStyle(color: Colors.grey))),
                    const SizedBox(height: 10),
                    TextField(controller: locController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Location Name", labelStyle: TextStyle(color: Colors.grey))),
                    const SizedBox(height: 10),
                    // Connector Type Dropdown (NEW)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Connector Type', labelStyle: TextStyle(color: Colors.grey)),
                      value: selectedConnector,
                      dropdownColor: const Color(0xFF2C2C2C),
                      style: const TextStyle(color: Colors.white),
                      items: const ['CCS Type 2', 'Type 2 AC', 'CHAdeMO', 'GB/T']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setDialogState(() => selectedConnector = val!),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: priceController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Price (₹)", labelStyle: TextStyle(color: Colors.grey)))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: spotsController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Parking Spots", labelStyle: TextStyle(color: Colors.grey)))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(title: const Text("Fast Charging", style: TextStyle(color: Colors.white)), value: isFast, onChanged: (val) => setDialogState(() => isFast = val), activeColor: Colors.redAccent),
                    SwitchListTile(title: const Text("Solar Powered", style: TextStyle(color: Colors.white)), value: isSolar, onChanged: (val) => setDialogState(() => isSolar = val), activeColor: Colors.greenAccent),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        setState(() {
                          mockStations.add(Station(
                            id: 'NEW_${DateTime.now().millisecondsSinceEpoch}',
                            name: nameController.text,
                            location: locController.text.isEmpty ? "Campus Area" : locController.text,
                            distance: 0.5,
                            isFastCharger: isFast,
                            totalPorts: 4, availablePorts: 4, isSharedPower: false,
                            isSolarPowered: isSolar,
                            mapX: 0.5, mapY: 0.5, // Default center
                            parkingSpaces: int.tryParse(spotsController.text) ?? 5,
                            availableParking: int.tryParse(spotsController.text) ?? 5,
                            pricePerUnit: double.tryParse(priceController.text) ?? 8.0,
                            connectorType: selectedConnector, // <--- FIXED: Passed connectorType
                          ));
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Station Added!")));
                      }
                    },
                    child: const Text("Add")
                ),
              ],
            );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalIssues = mockIssues.length;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewStation,
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.add),
        label: const Text("Add Charger"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats
          Row(
            children: [
              Expanded(child: _AdminStatCard(icon: Icons.ev_station, value: '${mockStations.length}', label: 'Active Chargers', color: Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _AdminStatCard(icon: Icons.warning_amber_rounded, value: '$totalIssues', label: 'Issues Reported', color: totalIssues > 0 ? Colors.red : Colors.orange)),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Live Station List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          // List
          ...mockStations.map((s) {
            List<ReportedIssue> stationIssues = mockIssues.where((i) => i.stationName == s.name).toList();
            bool hasIssues = stationIssues.isNotEmpty;
            return Card(
              color: const Color(0xFF2C2C2C),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(Icons.ev_station, color: s.availablePorts > 0 ? Colors.greenAccent : Colors.redAccent),
                title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Row(
                  children: [
                    Text("${s.location} • ", style: const TextStyle(color: Colors.white70)),
                    Text(hasIssues ? "${stationIssues.length} Issues" : "0 Issues", style: TextStyle(color: hasIssues ? Colors.redAccent : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () => _openStationInspector(s),
              ),
            );
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final IconData icon; final String value; final String label; final Color color;
  const _AdminStatCard({required this.icon, required this.value, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Column(children: [Icon(icon, color: color, size: 30), const SizedBox(height: 8), Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)), Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12))]),
    );
  }
}

// --- 3. ADMIN MAP (Click to Add + Inspector + Fixed Label Visibility) ---
class AdminMapScreen extends StatefulWidget {
  const AdminMapScreen({super.key});
  @override
  State<AdminMapScreen> createState() => _AdminMapScreenState();
}

class _AdminMapScreenState extends State<AdminMapScreen> {

  // --- DETAILED ADD DIALOG FOR MAP ---
  // --- DETAILED ADD DIALOG FOR MAP (FIXED for connectorType) ---
  void _showAddDialogAtLocation(double x, double y) {
    final nameController = TextEditingController();
    final locController = TextEditingController(text: "Pinned Location");
    final priceController = TextEditingController();
    final spotsController = TextEditingController();
    String selectedConnector = 'CCS Type 2'; // Default connector
    bool isFast = false;
    bool isSolar = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              title: const Text("Deploy New Charger", style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Coordinates: ${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white54, fontSize: 10)),
                    const SizedBox(height: 10),
                    TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Station Name", labelStyle: TextStyle(color: Colors.grey))),
                    const SizedBox(height: 10),
                    TextField(controller: locController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Location Name", labelStyle: TextStyle(color: Colors.grey))),
                    const SizedBox(height: 10),
                    // Connector Type Dropdown (NEW)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Connector Type', labelStyle: TextStyle(color: Colors.grey)),
                      value: selectedConnector,
                      dropdownColor: const Color(0xFF2C2C2C),
                      style: const TextStyle(color: Colors.white),
                      items: const ['CCS Type 2', 'Type 2 AC', 'CHAdeMO', 'GB/T']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (val) => setDialogState(() => selectedConnector = val!),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: priceController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Price (₹)", labelStyle: TextStyle(color: Colors.grey)))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(controller: spotsController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Spots", labelStyle: TextStyle(color: Colors.grey)))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(title: const Text("Fast Charging", style: TextStyle(color: Colors.white)), value: isFast, onChanged: (val) => setDialogState(() => isFast = val), activeColor: Colors.redAccent),
                    SwitchListTile(title: const Text("Solar Powered", style: TextStyle(color: Colors.white)), value: isSolar, onChanged: (val) => setDialogState(() => isSolar = val), activeColor: Colors.greenAccent),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        mockStations.add(Station(
                          id: 'NEW_${DateTime.now().millisecondsSinceEpoch}',
                          name: nameController.text,
                          location: locController.text,
                          distance: 0.0,
                          isFastCharger: isFast,
                          totalPorts: 4, availablePorts: 4, isSharedPower: false,
                          isSolarPowered: isSolar,
                          mapX: x, mapY: y, // <--- SAVES CLICK LOCATION
                          parkingSpaces: int.tryParse(spotsController.text) ?? 5,
                          availableParking: int.tryParse(spotsController.text) ?? 5,
                          pricePerUnit: double.tryParse(priceController.text) ?? 9.0,
                          connectorType: selectedConnector, // <--- FIXED: Passed connectorType
                        ));
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Station Deployed!")));
                    }
                  },
                  child: const Text("Deploy"),
                )
              ],
            );
          }
      ),
    );
  }

  void _openStationInspector(Station s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StationInspectorSheet(station: s, onUpdate: () => setState(() {})),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // ADD BUTTON FOR MAP SCREEN
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialogAtLocation(0.5, 0.5), // Center add
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.add_location),
        label: const Text("Add Charger"),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTapUp: (details) {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset localOffset = box.globalToLocal(details.globalPosition);
              _showAddDialogAtLocation(localOffset.dx / box.size.width, localOffset.dy / box.size.height);
            },
            child: Container(
              color: const Color(0xFF2C2C2C),
              width: double.infinity, height: double.infinity,
              child: const Center(child: Text("Tap anywhere to deploy a charger", style: TextStyle(color: Colors.white24))),
            ),
          ),
          ...mockStations.map((station) {
            return Positioned(
              left: MediaQuery.of(context).size.width * station.mapX,
              top: MediaQuery.of(context).size.height * station.mapY,
              child: GestureDetector(
                onTap: () => _openStationInspector(station),
                child: Column(
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent, size: 40),
                    // --- FIX: FORCE WHITE BACKGROUND LABEL FOR VISIBILITY ---
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white, // Always White Box
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 4)]
                      ),
                      child: Text(
                          station.name,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black // Always Black Text
                          )
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Positioned(top: 50, left: 16, right: 16, child: Card(color: const Color(0xFF1E1E1E), child: Padding(padding: const EdgeInsets.all(12), child: Row(children: const [Icon(Icons.search, color: Colors.grey), SizedBox(width: 8), Text("Search map...", style: TextStyle(color: Colors.grey))])))),
        ],
      ),
    );
  }
}

// --- SHARED: STATION INSPECTOR SHEET (The "Details" View + EDIT Logic) ---
class _StationInspectorSheet extends StatefulWidget {
  final Station station;
  final VoidCallback onUpdate;
  const _StationInspectorSheet({required this.station, required this.onUpdate});

  @override
  State<_StationInspectorSheet> createState() => _StationInspectorSheetState();
}

class _StationInspectorSheetState extends State<_StationInspectorSheet> {

  // Show Edit Dialog
  // Show Edit Dialog (FIXED for connectorType)
  void _showEditDialog() {
    final nameController = TextEditingController(text: widget.station.name);
    final priceController = TextEditingController(text: widget.station.pricePerUnit.toString());
    final spotsController = TextEditingController(text: widget.station.parkingSpaces.toString());
    String selectedConnector = widget.station.connectorType; // Get existing type

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              title: const Text("Edit Details", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Name", labelStyle: TextStyle(color: Colors.grey))),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Connector Type', labelStyle: TextStyle(color: Colors.grey)),
                    value: selectedConnector,
                    dropdownColor: const Color(0xFF2C2C2C),
                    style: const TextStyle(color: Colors.white),
                    items: const ['CCS Type 2', 'Type 2 AC', 'CHAdeMO', 'GB/T']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setDialogState(() => selectedConnector = val!),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: priceController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Price", labelStyle: TextStyle(color: Colors.grey))),
                  const SizedBox(height: 10),
                  TextField(controller: spotsController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Spots", labelStyle: TextStyle(color: Colors.grey))),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      int idx = mockStations.indexOf(widget.station);
                      if (idx != -1) {
                        mockStations[idx] = Station(
                          id: widget.station.id,
                          name: nameController.text,
                          location: widget.station.location,
                          distance: widget.station.distance,
                          isFastCharger: widget.station.isFastCharger,
                          totalPorts: widget.station.totalPorts,
                          availablePorts: widget.station.availablePorts,
                          isSharedPower: widget.station.isSharedPower,
                          isSolarPowered: widget.station.isSolarPowered,
                          mapX: widget.station.mapX,
                          mapY: widget.station.mapY,
                          parkingSpaces: int.tryParse(spotsController.text) ?? 5,
                          availableParking: widget.station.availableParking,
                          pricePerUnit: double.tryParse(priceController.text) ?? 9.0,
                          connectorType: selectedConnector, // <--- FIXED: Passed connectorType
                        );
                      }
                    });
                    widget.onUpdate(); // Refresh parent
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                )
              ],
            );
          }
      ),
    );
  }

  void _deleteStation() {
    mockStations.removeWhere((s) => s.id == widget.station.id);
    widget.onUpdate();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Station Deleted")));
  }

  @override
  Widget build(BuildContext context) {
    Station currentStation = mockStations.firstWhere((s) => s.id == widget.station.id, orElse: () => widget.station);
    List<ReportedIssue> stationIssues = mockIssues.where((i) => i.stationName == currentStation.name).toList();
    bool hasIssues = stationIssues.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.65, // Taller for more info
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(currentStation.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: hasIssues ? Colors.redAccent : Colors.green, borderRadius: BorderRadius.circular(12)),
                child: Text(hasIssues ? "${stationIssues.length} ISSUES" : "ACTIVE", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Text(currentStation.location, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStat("Price", "₹${currentStation.pricePerUnit}", Icons.currency_rupee, Colors.blue)),
              const SizedBox(width: 8),
              Expanded(child: _buildStat("Spots", "${currentStation.parkingSpaces}", Icons.local_parking, Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _buildStat("Type", currentStation.isFastCharger ? "Fast" : "Slow", Icons.ev_station, Colors.purple)),
            ],
          ),
          const SizedBox(height: 12),
          // New row for Solar
          Row(
            children: [
              Expanded(child: _buildStat("Power", currentStation.isSolarPowered ? "Solar" : "Grid", Icons.wb_sunny, currentStation.isSolarPowered ? Colors.greenAccent : Colors.grey)),
            ],
          ),

          const SizedBox(height: 24),
          const Text("Reported Issues", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // --- ISSUES LIST INSIDE INSPECTOR ---
          Expanded(
            child: hasIssues
                ? ListView.builder(
              itemCount: stationIssues.length,
              itemBuilder: (context, index) {
                final issue = stationIssues[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.warning_amber, color: Colors.redAccent),
                  title: Text(issue.issueType, style: const TextStyle(color: Colors.white)),
                  subtitle: Text("${issue.reportedBy} • 2h ago", style: const TextStyle(color: Colors.grey)),
                );
              },
            )
                : const Center(child: Text("No issues reported.", style: TextStyle(color: Colors.grey))),
          ),

          const SizedBox(height: 12),
          const Text("Actions", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showEditDialog,
                  icon: const Icon(Icons.edit), label: const Text("Edit Details"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _deleteStation,
                  icon: const Icon(Icons.delete, color: Colors.red), label: const Text("Delete"),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), foregroundColor: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [Icon(icon, color: color, size: 20), Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold)), Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10))]),
    );
  }
}

// --- 4. ADMIN USERS SCREEN ---
class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text("User Management"), backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUserTile("Rahul Sharma", "Student", "Active"),
          _buildUserTile("Prof. Anjali", "Staff", "Active"),
          _buildUserTile("Guest_992", "Guest", "Inactive"),
          _buildUserTile("Vikram Singh", "Student", "Suspended", isRed: true),
        ],
      ),
    );
  }
  Widget _buildUserTile(String name, String type, String status, {bool isRed = false}) {
    return Card(color: const Color(0xFF2C2C2C), child: ListTile(leading: CircleAvatar(child: Text(name[0])), title: Text(name, style: const TextStyle(color: Colors.white)), subtitle: Text("$type • $status", style: const TextStyle(color: Colors.grey)), trailing: const Icon(Icons.chevron_right, color: Colors.grey)));
  }
}

// --- 5. ADMIN FINANCE (Total Stats + Transaction Log) ---
class AdminTransactionMonitor extends StatelessWidget {
  const AdminTransactionMonitor({super.key});
  @override
  Widget build(BuildContext context) {
    double totalRevenue = allGlobalTransactions.where((t) => !t.isCredit).fold(0, (sum, t) => sum + t.amount);
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text('Financial Overview'), backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
      body: Column(
        children: [
          Container(
            width: double.infinity, margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.red.shade900, Colors.black]), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3))),
            child: Column(children: [
              const Text("Total Revenue Generated", style: TextStyle(color: Colors.white70)),
              Text("₹${totalRevenue.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("From all charging sessions", style: TextStyle(color: Colors.white24, fontSize: 10)),
            ]),
          ),
          Expanded(child: ListView.separated(itemCount: allGlobalTransactions.length, separatorBuilder: (_, __) => const Divider(color: Colors.white10), itemBuilder: (context, index) {
            final t = allGlobalTransactions[index];
            return ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFF2C2C2C), child: Icon(t.isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: t.isCredit ? Colors.green : Colors.redAccent)), title: Text(t.title, style: const TextStyle(color: Colors.white)), subtitle: Text(t.id, style: const TextStyle(color: Colors.grey)), trailing: Text('₹${t.amount}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)));
          })),
        ],
      ),
    );
  }
}

// --- 6. ADMIN PROFILE (Bank Settings Only) ---
class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text('Admin Profile'), backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 50, backgroundColor: Colors.redAccent, child: Icon(Icons.admin_panel_settings, size: 50, color: Colors.white)),
          const SizedBox(height: 16),
          const Center(child: Text("Administrator", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
          const Center(child: Text("arihant@manipal.edu", style: TextStyle(color: Colors.grey))),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.white),
              title: const Text('Institution Bank Details', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Manage MAHE Main Account', style: TextStyle(color: Colors.grey)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BankDetailsScreen())),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)), child: const Text("Logout")),
        ],
      ),
    );
  }
}
// --- NEW: VEHICLE MANAGEMENT SCREEN ---
class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

// --- NEW: VEHICLE MANAGEMENT SCREEN (CONFIRMED Delete Logic) ---
class _VehicleScreenState extends State<VehicleScreen> {
  // Common connector types used in India (simplified list)
  final List<String> commonConnectors = const ['CCS Type 2', 'Type 2 AC', 'CHAdeMO', 'GB/T'];

  void _addVehicle() {
    showDialog(
      context: context,
      builder: (context) => _AddVehicleDialog(
        onAdd: (newVehicle) {
          setState(() {
            // Logic to manage primary status on add
            if (newVehicle.isPrimary) {
              for (var v in currentUser.vehicles) {
                if (v.isPrimary) {
                  // Must re-create list with updated item since Vehicle is immutable
                  int index = currentUser.vehicles.indexOf(v);
                  currentUser.vehicles[index] = Vehicle(
                    id: v.id,
                    make: v.make,
                    model: v.model,
                    licensePlate: v.licensePlate,
                    connectorType: v.connectorType,
                    batteryCapacityKWh: v.batteryCapacityKWh,
                    initialSOCPercent: v.initialSOCPercent,
                    isPrimary: false,
                  );
                }
              }
            }
            currentUser.vehicles.add(newVehicle);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newVehicle.make} ${newVehicle.model} added!')),
          );
        },
      ),
    );
  }

  void _togglePrimary(Vehicle vehicle) {
    setState(() {
      if (!vehicle.isPrimary) {
        // 1. Set all other vehicles to non-primary
        for (int i = 0; i < currentUser.vehicles.length; i++) {
          final v = currentUser.vehicles[i];
          if (v.isPrimary) {
            currentUser.vehicles[i] = Vehicle(
              id: v.id,
              make: v.make,
              model: v.model,
              licensePlate: v.licensePlate,
              connectorType: v.connectorType,
              batteryCapacityKWh: v.batteryCapacityKWh,
              initialSOCPercent: v.initialSOCPercent,
              isPrimary: false,
            );
          }
        }
        // 2. Set the selected vehicle to primary
        int index = currentUser.vehicles.indexOf(vehicle);
        currentUser.vehicles[index] = Vehicle(
          id: vehicle.id,
          make: vehicle.make,
          model: vehicle.model,
          licensePlate: vehicle.licensePlate,
          connectorType: vehicle.connectorType,
          batteryCapacityKWh: vehicle.batteryCapacityKWh,
          initialSOCPercent: vehicle.initialSOCPercent,
          isPrimary: true,
        );
      }
    });
  }

  // --- DELETE LOGIC CONFIRMED ---
  void _deleteVehicle(String id) {
    setState(() {
      currentUser.vehicles.removeWhere((v) => v.id == id);
      // Ensure there is always a primary if list is not empty
      if (currentUser.vehicles.isNotEmpty && currentUser.vehicles.where((v) => v.isPrimary).isEmpty) {
        // Set the first remaining vehicle as primary
        final v = currentUser.vehicles.first;
        currentUser.vehicles[0] = Vehicle(
          id: v.id, make: v.make, model: v.model, licensePlate: v.licensePlate,
          connectorType: v.connectorType, batteryCapacityKWh: v.batteryCapacityKWh,
          initialSOCPercent: v.initialSOCPercent, isPrimary: true,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle removed.')),
      );
    });
  }
  // ------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _addVehicle,
          ),
        ],
      ),
      body: currentUser.vehicles.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_car_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No vehicles added yet.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _addVehicle,
              icon: const Icon(Icons.add),
              label: const Text('Add My First EV'),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currentUser.vehicles.length,
        itemBuilder: (context, index) {
          final v = currentUser.vehicles[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: v.isPrimary ? const Color(0xFF00796B).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                child: Icon(Icons.electric_car, color: v.isPrimary ? const Color(0xFF00796B) : Colors.grey),
              ),
              title: Text('${v.make} ${v.model}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v.licensePlate.isEmpty ? 'No Plate' : v.licensePlate, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.bolt, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(v.connectorType, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      // Display Battery Capacity in subtitle
                      Text('${v.batteryCapacityKWh.toStringAsFixed(1)} kWh', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (v.isPrimary)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('PRIMARY', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.star_outline, color: Colors.orange),
                      onPressed: () => _togglePrimary(v),
                    ),
                  // DELETE BUTTON CONFIRMED
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteVehicle(v.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- NEW: ADD VEHICLE DIALOG (UPDATED for Battery Capacity) ---
class _AddVehicleDialog extends StatefulWidget {
  final Function(Vehicle) onAdd;
  const _AddVehicleDialog({required this.onAdd});

  @override
  State<_AddVehicleDialog> createState() => __AddVehicleDialogState();
}

class __AddVehicleDialogState extends State<_AddVehicleDialog> {
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _capacityController = TextEditingController(text: '30.0'); // Default capacity
  String? _selectedConnector;
  bool _isPrimary = false;

  final List<String> commonConnectors = const ['CCS Type 2', 'Type 2 AC', 'CHAdeMO', 'GB/T', 'Other'];

  // --- FIXED _handleSubmit for _AddVehicleDialog (Robust Validation) ---
  void _handleSubmit() {
    final capacityText = _capacityController.text.trim();
    final capacity = double.tryParse(capacityText);

    // 1. Check for required fields (Make, Model, Connector, and a valid Capacity > 0)
    if (_makeController.text.trim().isEmpty ||
        _modelController.text.trim().isEmpty ||
        _selectedConnector == null ||
        capacity == null || capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields (Make, Model, Connector) and ensure Capacity is a valid number > 0.')));
      return;
    }

    final newVehicle = Vehicle(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      licensePlate: _plateController.text.trim(),
      connectorType: _selectedConnector!,
      batteryCapacityKWh: capacity,
      initialSOCPercent: 20, // Default start
      // If it's the first vehicle, it must be primary
      isPrimary: _isPrimary || currentUser.vehicles.isEmpty,
    );

    widget.onAdd(newVehicle);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New EV'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _makeController, decoration: const InputDecoration(labelText: 'Make (e.g. TATA)')),
            const SizedBox(height: 12),
            TextField(controller: _modelController, decoration: const InputDecoration(labelText: 'Model (e.g. Nexon EV)')),
            const SizedBox(height: 12),
            TextField(controller: _plateController, decoration: const InputDecoration(labelText: 'License Plate (Optional)')),
            const SizedBox(height: 12),
            TextField(controller: _capacityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Battery Capacity (kWh)', hintText: 'e.g., 30.2')), // <--- NEW INPUT FIELD
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Connector Type', border: OutlineInputBorder()),
              value: _selectedConnector,
              hint: const Text('Select your car\'s plug type'),
              items: commonConnectors.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => _selectedConnector = value),
            ),
            if (currentUser.vehicles.isNotEmpty)
              SwitchListTile(
                title: const Text('Set as Primary Vehicle'),
                value: _isPrimary,
                onChanged: (val) => setState(() => _isPrimary = val),
                activeColor: const Color(0xFF00796B),
                contentPadding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B), foregroundColor: Colors.white),
          child: const Text('Add Vehicle'),
        ),
      ],
    );
  }
}