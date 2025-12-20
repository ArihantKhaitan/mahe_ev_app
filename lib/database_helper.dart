import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mahe_ev_v4.db'); // New version for clean start
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('Database path: $path'); // Debug: shows where DB is stored
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // USERS Table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        userType TEXT NOT NULL,
        isAdmin INTEGER DEFAULT 0,
        walletBalance REAL DEFAULT 0.0,
        createdAt TEXT
      )
    ''');

    // STATIONS Table
    await db.execute('''
      CREATE TABLE stations (
        id TEXT PRIMARY KEY,
        name TEXT,
        location TEXT,
        distance REAL,
        isFastCharger INTEGER,
        totalPorts INTEGER,
        availablePorts INTEGER,
        isSharedPower INTEGER,
        isSolarPowered INTEGER,
        mapX REAL,
        mapY REAL,
        parkingSpaces INTEGER,
        availableParking INTEGER,
        pricePerUnit REAL,
        connectorType TEXT
      )
    ''');

    // VEHICLES Table
    await db.execute('''
      CREATE TABLE vehicles (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        make TEXT,
        model TEXT,
        licensePlate TEXT,
        connectorType TEXT,
        isPrimary INTEGER DEFAULT 0,
        batteryCapacityKWh REAL,
        initialSOCPercent INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // TRANSACTIONS Table
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        title TEXT,
        date TEXT,
        amount REAL,
        isCredit INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // BOOKINGS Table
    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        stationId TEXT,
        stationName TEXT,
        bookingTime TEXT,
        startTime TEXT,
        endTime TEXT,
        cost REAL,
        status TEXT,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Insert default ADMIN account
    await db.insert('users', {
      'id': 'ADMIN_001',
      'name': 'Arihant (Admin)',
      'email': 'arihant@manipal.edu',
      'password': 'admin123',
      'userType': 'admin',
      'isAdmin': 1,
      'walletBalance': 99999.0,
      'createdAt': DateTime.now().toIso8601String(),
    });

    print('Database created with admin user!');
  }

  // ==========================================
  // USER OPERATIONS
  // ==========================================

  // Register new user
  Future<bool> registerUser(UserProfile user) async {
    try {
      final db = await instance.database;

      // Check if email already exists
      final existing = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [user.email.toLowerCase()],
      );

      if (existing.isNotEmpty) {
        print('Email already exists!');
        return false; // Email already registered
      }

      await db.insert('users', {
        'id': user.id,
        'name': user.name,
        'email': user.email.toLowerCase(),
        'password': user.password,
        'userType': user.userType,
        'isAdmin': user.isAdmin ? 1 : 0,
        'walletBalance': user.walletBalance,
        'createdAt': DateTime.now().toIso8601String(),
      });

      print('User registered: ${user.email}');
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Login - check credentials
  Future<UserProfile?> loginUser(String emailOrId, String password) async {
    try {
      final db = await instance.database;

      final maps = await db.query(
        'users',
        where: '(email = ? OR id = ?) AND password = ?',
        whereArgs: [emailOrId.toLowerCase(), emailOrId, password],
      );

      if (maps.isEmpty) {
        print('Login failed: No matching user');
        return null;
      }

      final userData = maps.first;
      final userId = userData['id'] as String;

      // Fetch related data
      final vehicles = await getVehiclesForUser(userId);
      final transactions = await getTransactionsForUser(userId);
      final bookings = await getBookingsForUser(userId);

      print('Login successful: ${userData['email']}');

      return UserProfile(
        id: userId,
        name: userData['name'] as String,
        email: userData['email'] as String,
        password: userData['password'] as String,
        userType: userData['userType'] as String,
        isAdmin: (userData['isAdmin'] as int) == 1,
        walletBalance: (userData['walletBalance'] as num).toDouble(),
        vehicles: vehicles,
        transactions: transactions,
        bookings: bookings,
        notifications: [], // Notifications are in-memory only for now
      );
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Update user's wallet balance
  Future<void> updateWalletBalance(String userId, double newBalance) async {
    final db = await instance.database;
    await db.update(
      'users',
      {'walletBalance': newBalance},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Get all users (for admin)
  Future<List<UserProfile>> getAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users', where: 'isAdmin = ?', whereArgs: [0]);

    List<UserProfile> users = [];
    for (var userData in result) {
      users.add(UserProfile(
        id: userData['id'] as String,
        name: userData['name'] as String,
        email: userData['email'] as String,
        password: '', // Don't expose password
        userType: userData['userType'] as String,
        isAdmin: false,
        walletBalance: (userData['walletBalance'] as num).toDouble(),
      ));
    }
    return users;
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    return result.isNotEmpty;
  }

  // ==========================================
  // STATION OPERATIONS
  // ==========================================

  Future<void> insertStation(Station s) async {
    final db = await instance.database;
    await db.insert('stations', {
      'id': s.id,
      'name': s.name,
      'location': s.location,
      'distance': s.distance,
      'isFastCharger': s.isFastCharger ? 1 : 0,
      'totalPorts': s.totalPorts,
      'availablePorts': s.availablePorts,
      'isSharedPower': s.isSharedPower ? 1 : 0,
      'isSolarPowered': s.isSolarPowered ? 1 : 0,
      'mapX': s.mapX,
      'mapY': s.mapY,
      'parkingSpaces': s.parkingSpaces,
      'availableParking': s.availableParking,
      'pricePerUnit': s.pricePerUnit,
      'connectorType': s.connectorType,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Station>> getAllStations() async {
    final db = await instance.database;
    final result = await db.query('stations');
    return result.map((j) => Station(
      id: j['id'] as String,
      name: j['name'] as String,
      location: j['location'] as String,
      distance: (j['distance'] as num).toDouble(),
      isFastCharger: j['isFastCharger'] == 1,
      totalPorts: j['totalPorts'] as int,
      availablePorts: j['availablePorts'] as int,
      isSharedPower: j['isSharedPower'] == 1,
      isSolarPowered: j['isSolarPowered'] == 1,
      mapX: (j['mapX'] as num).toDouble(),
      mapY: (j['mapY'] as num).toDouble(),
      parkingSpaces: j['parkingSpaces'] as int,
      availableParking: j['availableParking'] as int,
      pricePerUnit: (j['pricePerUnit'] as num).toDouble(),
      connectorType: j['connectorType'] as String,
    )).toList();
  }

  Future<void> updateStation(Station s) async {
    final db = await instance.database;
    await db.update(
      'stations',
      {
        'name': s.name,
        'location': s.location,
        'availablePorts': s.availablePorts,
        'availableParking': s.availableParking,
        'pricePerUnit': s.pricePerUnit,
        'isFastCharger': s.isFastCharger ? 1 : 0,
        'isSolarPowered': s.isSolarPowered ? 1 : 0,
        'connectorType': s.connectorType,
      },
      where: 'id = ?',
      whereArgs: [s.id],
    );
  }

  Future<void> deleteStation(String id) async {
    final db = await instance.database;
    await db.delete('stations', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // VEHICLE OPERATIONS
  // ==========================================

  Future<void> saveVehicle(Vehicle v, String userId) async {
    final db = await instance.database;
    await db.insert('vehicles', {
      'id': v.id,
      'userId': userId,
      'make': v.make,
      'model': v.model,
      'licensePlate': v.licensePlate,
      'connectorType': v.connectorType,
      'isPrimary': v.isPrimary ? 1 : 0,
      'batteryCapacityKWh': v.batteryCapacityKWh,
      'initialSOCPercent': v.initialSOCPercent,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Vehicle>> getVehiclesForUser(String userId) async {
    final db = await instance.database;
    final result = await db.query('vehicles', where: 'userId = ?', whereArgs: [userId]);
    return result.map((j) => Vehicle(
      id: j['id'] as String,
      make: j['make'] as String,
      model: j['model'] as String,
      licensePlate: j['licensePlate'] as String? ?? '',
      connectorType: j['connectorType'] as String,
      isPrimary: j['isPrimary'] == 1,
      batteryCapacityKWh: (j['batteryCapacityKWh'] as num).toDouble(),
      initialSOCPercent: j['initialSOCPercent'] as int,
    )).toList();
  }

  Future<void> deleteVehicle(String id) async {
    final db = await instance.database;
    await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // TRANSACTION OPERATIONS
  // ==========================================

  Future<void> insertTransaction(WalletTransaction t, String userId) async {
    final db = await instance.database;
    await db.insert('transactions', {
      'id': t.id,
      'userId': userId,
      'title': t.title,
      'date': t.date.toIso8601String(),
      'amount': t.amount,
      'isCredit': t.isCredit ? 1 : 0,
    });
  }

  Future<List<WalletTransaction>> getTransactionsForUser(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return result.map((j) => WalletTransaction(
      id: j['id'] as String,
      title: j['title'] as String,
      date: DateTime.parse(j['date'] as String),
      amount: (j['amount'] as num).toDouble(),
      isCredit: j['isCredit'] == 1,
    )).toList();
  }

  // ==========================================
  // BOOKING OPERATIONS
  // ==========================================

  Future<void> saveBooking(Booking b, String userId) async {
    final db = await instance.database;
    await db.insert('bookings', {
      'id': b.id,
      'userId': userId,
      'stationId': b.stationId,
      'stationName': b.stationName,
      'bookingTime': b.bookingTime.toIso8601String(),
      'startTime': b.startTime?.toIso8601String(),
      'endTime': b.endTime?.toIso8601String(),
      'cost': b.cost,
      'status': b.status,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Booking>> getBookingsForUser(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'bookings',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'bookingTime DESC',
    );
    return result.map((j) => Booking(
      id: j['id'] as String,
      stationId: j['stationId'] as String,
      stationName: j['stationName'] as String,
      bookingTime: DateTime.parse(j['bookingTime'] as String),
      startTime: j['startTime'] != null ? DateTime.parse(j['startTime'] as String) : null,
      endTime: j['endTime'] != null ? DateTime.parse(j['endTime'] as String) : null,
      cost: (j['cost'] as num).toDouble(),
      status: j['status'] as String,
    )).toList();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    final db = await instance.database;
    await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  // ==========================================
  // DEBUG HELPERS
  // ==========================================

  // Print all users (for debugging)
  Future<void> printAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    print('=== ALL USERS IN DATABASE ===');
    for (var user in result) {
      print('ID: ${user['id']}, Email: ${user['email']}, Name: ${user['name']}, Type: ${user['userType']}');
    }
    print('=============================');
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    final db = await instance.database;
    await db.delete('bookings');
    await db.delete('transactions');
    await db.delete('vehicles');
    await db.delete('users');
    await db.delete('stations');
    print('All data cleared!');
  }

  // Delete and recreate database (nuclear option)
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mahe_ev_v4.db');
    await deleteDatabase(path);
    _database = null;
    print('Database reset!');
  }
  // ==========================================
// ADMIN USER MANAGEMENT
// ==========================================

// Get all users (full details for admin)
  Future<List<Map<String, dynamic>>> getAllUsersForAdmin() async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      orderBy: 'createdAt DESC',
    );
    print('Fetched ${result.length} users for admin');
    return result;
  }

// Update user details (admin function)
  Future<bool> updateUserByAdmin({
    required String userId,
    String? name,
    String? email,
    String? password,
    String? userType,
    double? walletBalance,
  }) async {
    try {
      final db = await instance.database;

      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email.toLowerCase();
      if (password != null) updates['password'] = password;
      if (userType != null) updates['userType'] = userType;
      if (walletBalance != null) updates['walletBalance'] = walletBalance;

      if (updates.isEmpty) return false;

      await db.update(
        'users',
        updates,
        where: 'id = ?',
        whereArgs: [userId],
      );

      print('Admin updated user: $userId');
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

// Delete user (admin function)
  Future<bool> deleteUserByAdmin(String userId) async {
    try {
      final db = await instance.database;

      // Delete related data first
      await db.delete('vehicles', where: 'userId = ?', whereArgs: [userId]);
      await db.delete('transactions', where: 'userId = ?', whereArgs: [userId]);
      await db.delete('bookings', where: 'userId = ?', whereArgs: [userId]);

      // Delete user
      await db.delete('users', where: 'id = ?', whereArgs: [userId]);

      print('Admin deleted user: $userId');
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

// Get user count
  Future<int> getUserCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM users WHERE isAdmin = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}