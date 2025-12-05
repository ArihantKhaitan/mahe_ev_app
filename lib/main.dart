import 'package:flutter/material.dart';
import 'dart:async';

// --- GLOBAL THEME CONTROLLER ---
// This allows us to toggle Dark Mode from anywhere in the app
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MaheEVApp());
}

// --- MAIN APP WIDGET ---
class MaheEVApp extends StatelessWidget {
  const MaheEVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'MAHE EV Charge',
          debugShowCheckedModeBanner: false,
          themeMode: mode,

          // --- LIGHT THEME DEFINITION ---
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00796B),
              surface: const Color(0xFFF5F7FA),
              onSurface: Colors.black87,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F7FA),
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black87),
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 12),
            ),
            dividerTheme: DividerThemeData(
              color: Colors.grey.withValues(alpha: 0.2),
              thickness: 1,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // --- DARK THEME DEFINITION ---
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00796B),
              brightness: Brightness.dark,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E1E),
              surfaceTintColor: const Color(0xFF1E1E1E),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              margin: const EdgeInsets.only(bottom: 12),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: Colors.grey.shade500),
              labelStyle: TextStyle(color: Colors.grey.shade400),
              prefixIconColor: Colors.grey.shade400,
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
  String userType; // 'staff', 'student', 'guest'
  double walletBalance;
  List<Booking> bookings;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.walletBalance,
    required this.bookings,
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

// --- MOCK DATA ---

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
List<Station> mockStations = [
  Station(
    id: '1',
    name: 'MIT Quadrangle',
    location: 'Block 4',
    distance: 0.5,
    isFastCharger: true,
    totalPorts: 4,
    availablePorts: 2,
    isSharedPower: true,
    isSolarPowered: true,
    mapX: 0.4,
    mapY: 0.3,
    parkingSpaces: 8,
    availableParking: 3,
    pricePerUnit: 8.5,
  ),
  Station(
    id: '2',
    name: 'KMC Staff Parking',
    location: 'Tiger Circle',
    distance: 1.2,
    isFastCharger: true,
    totalPorts: 2,
    availablePorts: 0,
    isSharedPower: false,
    isSolarPowered: true,
    mapX: 0.7,
    mapY: 0.6,
    parkingSpaces: 6,
    availableParking: 0,
    pricePerUnit: 8.5,
  ),
  Station(
    id: '3',
    name: 'AB-5 Solar Carport',
    location: 'Uni Road',
    distance: 2.8,
    isFastCharger: false,
    totalPorts: 6,
    availablePorts: 5,
    isSharedPower: false,
    isSolarPowered: true,
    mapX: 0.2,
    mapY: 0.8,
    parkingSpaces: 12,
    availableParking: 8,
    pricePerUnit: 7.0,
  ),
  Station(
    id: '4',
    name: 'NLH EV Point',
    location: 'NLH Complex',
    distance: 0.8,
    isFastCharger: false,
    totalPorts: 4,
    availablePorts: 4,
    isSharedPower: false,
    isSolarPowered: false,
    mapX: 0.5,
    mapY: 0.4,
    parkingSpaces: 4,
    availableParking: 2,
    pricePerUnit: 8.0,
  ),
];

// Global User State (Starts empty, populated on Login)
UserProfile currentUser = UserProfile(
  id: '',
  name: '',
  email: '',
  userType: '',
  walletBalance: 0.0,
  bookings: [],
);

// --- LOGIN SCREEN ---
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
    // Basic validation
    if (_idController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ID and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        // Set Mock Data for Login
        currentUser = UserProfile(
          id: _idController.text,
          name: 'Manipal User',
          email: '${_idController.text}@learner.manipal.edu',
          userType: 'student',
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
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    });
  }

  void _continueAsGuest() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        // Create Guest Profile
        currentUser = UserProfile(
          id: 'GUEST',
          name: 'Guest User',
          email: 'guest@temp.mahe.ev',
          userType: 'guest',
          walletBalance: 100.0, // Free credits for testing
          bookings: [],
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in as Guest. Some features may be limited.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF00796B);

    return Scaffold(
      // We rely on the global Theme ScaffoldBackgroundColor
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Logo Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bolt_rounded, size: 64, color: primaryColor),
              ),
              const SizedBox(height: 24),
              Text(
                'MAHE EV Charging',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Text(
                'Campus Charging Solution',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              // Eco Badge
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

              // Inputs
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'MAHE Staff/Student ID',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 16),

              // Guest Button
              TextButton(
                onPressed: _isLoading ? null : _continueAsGuest,
                child: Text(
                  'Continue as Guest',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    fontSize: 16,
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
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
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

// --- SIGN UP SCREEN ---
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

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        // Create new user
        currentUser = UserProfile(
          id: _idController.text,
          name: _nameController.text,
          email: _emailController.text,
          userType: 'student',
          walletBalance: 0.0, // New users start empty
          bookings: [],
        );

        // Clear stack and go to main
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
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let's get started",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
            ),
            Text(
              "Create an account to manage charging",
              style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey : Colors.grey.shade600),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'MAHE Email', prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'Registration/Staff ID', prefixIcon: Icon(Icons.badge_outlined)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
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
  String _filterType = 'all'; // 'all', 'available', 'fast'

  List<Station> get filteredStations {
    if (_filterType == 'all') return mockStations;
    if (_filterType == 'available') return mockStations.where((s) => s.availablePorts > 0).toList();
    if (_filterType == 'fast') return mockStations.where((s) => s.isFastCharger).toList();
    return mockStations;
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = mockNotifications.any((n) => !n.read);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Stations', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                if (hasUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Stats Header
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF00796B),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.ev_station,
                    value: '${mockStations.fold(0, (sum, s) => sum + s.availablePorts)}',
                    label: 'Available Ports',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_parking,
                    value: '${mockStations.fold(0, (sum, s) => sum + s.availableParking)}',
                    label: 'Parking Spots',
                  ),
                ),
              ],
            ),
          ),
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filterType == 'all',
                  onTap: () => setState(() => _filterType = 'all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Available',
                  selected: _filterType == 'available',
                  onTap: () => setState(() => _filterType = 'available'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Fast Charging',
                  selected: _filterType == 'fast',
                  onTap: () => setState(() => _filterType = 'fast'),
                ),
              ],
            ),
          ),
          // Station List
          Expanded(
            child: filteredStations.isEmpty
                ? const Center(child: Text("No stations found for this filter."))
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
                            const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${station.location} • ${station.distance}km', style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Simulated Map Background
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
          // Stations Markers
          ...mockStations.map((station) {
            return Positioned(
              left: MediaQuery.of(context).size.width * station.mapX,
              top: MediaQuery.of(context).size.height * station.mapY,
              child: GestureDetector(
                onTap: () {
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                      child: Text(station.name.split(' ').first, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Center Indicator
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
          // Search Bar
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.station.name)),
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
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
                      const Text('Estimated Cost', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      Text('₹${widget.station.pricePerUnit * 10}/hr', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
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
                ),
                child: const Text('Book Slot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
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

class _ChargingScreenState extends State<ChargingScreen> {
  Timer? _timer;
  double _cost = 0.0;
  double _unitsConsumed = 0.0;
  bool _active = true;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted && _active) {
        setState(() {
          _unitsConsumed += 0.01; // 0.01 kWh per second
          _cost = _unitsConsumed * widget.station.pricePerUnit;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duration = _startTime != null ? DateTime.now().difference(_startTime!) : Duration.zero;

    return Scaffold(
      backgroundColor: const Color(0xFF001F1A), // Dark mode friendly charging bg
      appBar: AppBar(
        title: const Text("Active Charging"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on, size: 80, color: Colors.amber),
                    ),
                    const SizedBox(height: 30),
                    const Text('LIVE METER', style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2)),
                    const SizedBox(height: 10),
                    Text(
                      '₹ ${_cost.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 30),
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
              if (_active)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _timer?.cancel();
                      setState(() => _active = false);
                      _showPaymentDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text("Stop & Pay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                )
              else
                const Text('Processing payment...', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog() {
    double gst = _cost * 0.05; // 5% GST
    double totalPayable = (_cost + gst) - 50; // Cost + GST - Booking Refund
    if (totalPayable < 0) totalPayable = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
          ElevatedButton(
            onPressed: () {
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
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Wallet', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  Text('₹ ${currentUser.walletBalance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _showAddMoneyDialog(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Money"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF00796B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickInfoCard(
                      icon: Icons.savings_outlined,
                      title: 'Total Saved',
                      value: '₹120',
                      subtitle: 'vs Third-party apps',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickInfoCard(
                      icon: Icons.eco_outlined,
                      title: 'CO₂ Saved',
                      value: '45 kg',
                      subtitle: 'Using solar power',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Quick Add', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 12,
                children: [
                  _QuickAddChip(amount: 100, onTap: () => _addMoney(context, 100)),
                  _QuickAddChip(amount: 200, onTap: () => _addMoney(context, 200)),
                  _QuickAddChip(amount: 500, onTap: () => _addMoney(context, 500)),
                  _QuickAddChip(amount: 1000, onTap: () => _addMoney(context, 1000)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Transaction History'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Linked ICICI Bank Account'),
              subtitle: const Text('••••1234'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Money'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount > 0) {
                _addMoney(context, amount);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addMoney(BuildContext context, double amount) {
    currentUser.walletBalance += amount;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('₹$amount added successfully via ICICI Bank')),
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
                      Text(currentUser.email, style: TextStyle(color: Colors.grey.shade600)),
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

          // --- UPDATED NAVIGATION HERE ---
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({required this.icon, required this.title, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : null),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
      trailing: const Icon(Icons.chevron_right),
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
          final isDark = Theme.of(context).brightness == Brightness.dark;

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