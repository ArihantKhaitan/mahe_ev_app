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
    return await openDatabase(path, version: 3, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        title TEXT,
        body TEXT,
        time TEXT,
        isRead INTEGER DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

      await db.execute('''
      CREATE TABLE IF NOT EXISTS reported_issues (
        id TEXT PRIMARY KEY,
        stationId TEXT,
        stationName TEXT,
        reportedBy TEXT,
        reportedByUserId TEXT,
        issueType TEXT,
        time TEXT,
        status TEXT DEFAULT 'Pending',
        FOREIGN KEY (reportedByUserId) REFERENCES users(id)
      )
    ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS sent_notifications (
        id TEXT PRIMARY KEY,
        title TEXT,
        body TEXT,
        targetType TEXT,
        targetUserId TEXT,
        targetUserName TEXT,
        sentAt TEXT
      )
    ''');
    }
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
        oderId TEXT NOT NULL,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        amount REAL NOT NULL,
        isCredit INTEGER NOT NULL,
        paymentMethod TEXT DEFAULT 'Wallet',
        upiId TEXT,
        FOREIGN KEY (oderId) REFERENCES users(id)
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

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        title TEXT,
        body TEXT,
        time TEXT,
        isRead INTEGER DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // REPORTED ISSUES Table
    await db.execute('''
      CREATE TABLE reported_issues (
        id TEXT PRIMARY KEY,
        stationId TEXT,
        stationName TEXT,
        reportedBy TEXT,
        reportedByUserId TEXT,
        issueType TEXT,
        time TEXT,
        status TEXT DEFAULT 'Pending',
        FOREIGN KEY (reportedByUserId) REFERENCES users(id)
      )
    ''');

    // SENT NOTIFICATIONS (Admin History)
    await db.execute('''
      CREATE TABLE sent_notifications (
        id TEXT PRIMARY KEY,
        title TEXT,
        body TEXT,
        targetType TEXT,
        targetUserId TEXT,
        targetUserName TEXT,
        sentAt TEXT
      )
    ''');

    // Insert default ADMIN account
    await db.insert('users', {
      'id': 'ADMIN_001',
      'name': 'Administrator',
      'email': 'admin@manipal.edu',
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
        notifications: await getNotificationsForUser(userId),
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

  // ==========================================
  // NOTIFICATION OPERATIONS
  // ==========================================

  Future<void> insertNotification(AppNotification n, String userId) async {
    final db = await instance.database;
    await db.insert('notifications', {
      'id': 'N${DateTime.now().millisecondsSinceEpoch}',
      'userId': userId,
      'title': n.title,
      'body': n.body,
      'time': n.time.toIso8601String(),
      'isRead': n.read ? 1 : 0,
    });
  }

  Future<List<AppNotification>> getNotificationsForUser(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'notifications',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'time DESC',
    );
    return result.map((j) => AppNotification(
      title: j['title'] as String,
      body: j['body'] as String,
      time: DateTime.parse(j['time'] as String),
      read: j['isRead'] == 1,
    )).toList();
  }

  Future<void> markNotificationRead(String notificationId) async {
    final db = await instance.database;
    await db.update(
      'notifications',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  Future<void> markAllNotificationsRead(String userId) async {
    final db = await instance.database;
    await db.update(
      'notifications',
      {'isRead': 1},
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // ==========================================
  // REPORTED ISSUE OPERATIONS
  // ==========================================

  Future<void> insertIssue(ReportedIssue issue, String userId) async {
    final db = await instance.database;
    await db.insert('reported_issues', {
      'id': issue.id,
      'stationId': '', // Add if you have it
      'stationName': issue.stationName,
      'reportedBy': issue.reportedBy,
      'reportedByUserId': userId,
      'issueType': issue.issueType,
      'time': issue.time.toIso8601String(),
      'status': issue.status,
    });
  }

  Future<List<ReportedIssue>> getAllIssues() async {
    final db = await instance.database;
    final result = await db.query('reported_issues', orderBy: 'time DESC');
    return result.map((j) => ReportedIssue(
      id: j['id'] as String,
      stationName: j['stationName'] as String,
      reportedBy: j['reportedBy'] as String,
      issueType: j['issueType'] as String,
      time: DateTime.parse(j['time'] as String),
      status: j['status'] as String,
    )).toList();
  }

  Future<List<ReportedIssue>> getIssuesForStation(String stationName) async {
    final db = await instance.database;
    final result = await db.query(
      'reported_issues',
      where: 'stationName = ?',
      whereArgs: [stationName],
      orderBy: 'time DESC',
    );
    return result.map((j) => ReportedIssue(
      id: j['id'] as String,
      stationName: j['stationName'] as String,
      reportedBy: j['reportedBy'] as String,
      issueType: j['issueType'] as String,
      time: DateTime.parse(j['time'] as String),
      status: j['status'] as String,
    )).toList();
  }

  Future<void> updateIssueStatus(String issueId, String status) async {
    final db = await instance.database;
    await db.update(
      'reported_issues',
      {'status': status},
      where: 'id = ?',
      whereArgs: [issueId],
    );
  }

  Future<void> deleteIssue(String issueId) async {
    final db = await instance.database;
    await db.delete('reported_issues', where: 'id = ?', whereArgs: [issueId]);
  }

  // Get all transactions (for admin)
  Future<List<WalletTransaction>> getAllTransactions() async {
    final db = await instance.database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((j) => WalletTransaction(
      id: j['id'] as String,
      title: j['title'] as String,
      date: DateTime.parse(j['date'] as String),
      amount: (j['amount'] as num).toDouble(),
      isCredit: j['isCredit'] == 1,
    )).toList();
  }

  // Get bookings for any user (admin function)
  Future<List<Booking>> getBookingsForUserAdmin(String userId) async {
    return await getBookingsForUser(userId);
  }

  // Get transactions for any user (admin function)
  Future<List<WalletTransaction>> getTransactionsForUserAdmin(String userId) async {
    return await getTransactionsForUser(userId);
  }

  // Get vehicles for any user (admin function)
  Future<List<Vehicle>> getVehiclesForUserAdmin(String userId) async {
    return await getVehiclesForUser(userId);
  }

  // Get notifications for any user (admin function)
  Future<List<AppNotification>> getNotificationsForUserAdmin(String userId) async {
    return await getNotificationsForUser(userId);
  }

  // Get all bookings (for admin)
  Future<List<Map<String, dynamic>>> getAllBookingsWithUserInfo() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT bookings.*, users.name as userName, users.email as userEmail
      FROM bookings
      LEFT JOIN users ON bookings.userId = users.id
      ORDER BY bookings.bookingTime DESC
    ''');
    return result;
  }
  // Get dashboard statistics (for admin)
  Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await instance.database;

    // Total users (non-admin)
    final userCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM users WHERE isAdmin = 0');
    final totalUsers = Sqflite.firstIntValue(userCountResult) ?? 0;

    // Total bookings
    final bookingCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM bookings');
    final totalBookings = Sqflite.firstIntValue(bookingCountResult) ?? 0;

    // Active bookings
    final activeBookingsResult = await db.rawQuery("SELECT COUNT(*) as count FROM bookings WHERE status = 'active'");
    final activeBookings = Sqflite.firstIntValue(activeBookingsResult) ?? 0;

    // Completed bookings
    final completedBookingsResult = await db.rawQuery("SELECT COUNT(*) as count FROM bookings WHERE status = 'completed'");
    final completedBookings = Sqflite.firstIntValue(completedBookingsResult) ?? 0;

    // Total revenue (sum of all non-credit transactions)
    final revenueResult = await db.rawQuery('SELECT SUM(amount) as total FROM transactions WHERE isCredit = 0');
    final totalRevenue = (revenueResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // Total wallet loads (sum of all credit transactions)
    final loadsResult = await db.rawQuery('SELECT SUM(amount) as total FROM transactions WHERE isCredit = 1');
    final totalLoads = (loadsResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // Total vehicles registered
    final vehicleCountResult = await db.rawQuery('SELECT COUNT(*) as count FROM vehicles');
    final totalVehicles = Sqflite.firstIntValue(vehicleCountResult) ?? 0;

    // Pending issues
    final issuesResult = await db.rawQuery("SELECT COUNT(*) as count FROM reported_issues WHERE status = 'Pending'");
    final pendingIssues = Sqflite.firstIntValue(issuesResult) ?? 0;

    // Today's bookings
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day).toIso8601String();
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();
    final todayBookingsResult = await db.rawQuery(
        "SELECT COUNT(*) as count FROM bookings WHERE bookingTime BETWEEN ? AND ?",
        [todayStart, todayEnd]
    );
    final todayBookings = Sqflite.firstIntValue(todayBookingsResult) ?? 0;

    // Today's revenue
    final todayRevenueResult = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE isCredit = 0 AND date BETWEEN ? AND ?",
        [todayStart, todayEnd]
    );
    final todayRevenue = (todayRevenueResult.first['total'] as num?)?.toDouble() ?? 0.0;

    return {
      'totalUsers': totalUsers,
      'totalBookings': totalBookings,
      'activeBookings': activeBookings,
      'completedBookings': completedBookings,
      'totalRevenue': totalRevenue,
      'totalLoads': totalLoads,
      'totalVehicles': totalVehicles,
      'pendingIssues': pendingIssues,
      'todayBookings': todayBookings,
      'todayRevenue': todayRevenue,
    };
  }
  // Get analytics for a specific station
  Future<Map<String, dynamic>> getStationAnalytics(String stationId, String stationName) async {
    final db = await instance.database;

    // Total bookings for this station
    final totalBookingsResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM bookings WHERE stationId = ?',
        [stationId]
    );
    final totalBookings = Sqflite.firstIntValue(totalBookingsResult) ?? 0;

    // Completed bookings
    final completedResult = await db.rawQuery(
        "SELECT COUNT(*) as count FROM bookings WHERE stationId = ? AND status = 'completed'",
        [stationId]
    );
    final completedBookings = Sqflite.firstIntValue(completedResult) ?? 0;

    // Total revenue from this station (from transactions with station name in title)
    final revenueResult = await db.rawQuery(
        "SELECT SUM(amount) as total FROM transactions WHERE title LIKE ? AND isCredit = 0",
        ['%$stationName%']
    );
    final totalRevenue = (revenueResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // Total issues reported for this station
    final issuesResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM reported_issues WHERE stationName = ?',
        [stationName]
    );
    final totalIssues = Sqflite.firstIntValue(issuesResult) ?? 0;

    // Pending issues
    final pendingIssuesResult = await db.rawQuery(
        "SELECT COUNT(*) as count FROM reported_issues WHERE stationName = ? AND status = 'Pending'",
        [stationName]
    );
    final pendingIssues = Sqflite.firstIntValue(pendingIssuesResult) ?? 0;

    // Average booking cost
    final avgCostResult = await db.rawQuery(
        "SELECT AVG(cost) as avg FROM bookings WHERE stationId = ? AND status = 'completed'",
        [stationId]
    );
    final avgCost = (avgCostResult.first['avg'] as num?)?.toDouble() ?? 0.0;

    // Recent bookings (last 5)
    final recentBookings = await db.rawQuery(
        '''SELECT bookings.*, users.name as userName 
         FROM bookings 
         LEFT JOIN users ON bookings.userId = users.id 
         WHERE bookings.stationId = ? 
         ORDER BY bookings.bookingTime DESC 
         LIMIT 5''',
        [stationId]
    );

    return {
      'totalBookings': totalBookings,
      'completedBookings': completedBookings,
      'totalRevenue': totalRevenue,
      'totalIssues': totalIssues,
      'pendingIssues': pendingIssues,
      'avgCost': avgCost,
      'recentBookings': recentBookings,
    };
  }

  // Get all stations with their analytics summary
  Future<List<Map<String, dynamic>>> getAllStationsWithAnalytics() async {
    final db = await instance.database;
    final stations = await db.query('stations');

    List<Map<String, dynamic>> result = [];
    for (var station in stations) {
      final stationId = station['id'] as String;
      final stationName = station['name'] as String;

      // Get booking count
      final bookingResult = await db.rawQuery(
          'SELECT COUNT(*) as count FROM bookings WHERE stationId = ?',
          [stationId]
      );
      final bookingCount = Sqflite.firstIntValue(bookingResult) ?? 0;

      // Get revenue
      final revenueResult = await db.rawQuery(
          "SELECT SUM(amount) as total FROM transactions WHERE title LIKE ? AND isCredit = 0",
          ['%$stationName%']
      );
      final revenue = (revenueResult.first['total'] as num?)?.toDouble() ?? 0.0;

      result.add({
        ...station,
        'bookingCount': bookingCount,
        'revenue': revenue,
      });
    }

    return result;
  }

  // ==========================================
  // SENT NOTIFICATIONS (Admin History)
  // ==========================================

  Future<void> insertSentNotification({
    required String title,
    required String body,
    required String targetType,
    String? targetUserId,
    String? targetUserName,
  }) async {
    final db = await instance.database;
    await db.insert('sent_notifications', {
      'id': 'SN_${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'body': body,
      'targetType': targetType,
      'targetUserId': targetUserId,
      'targetUserName': targetUserName,
      'sentAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getSentNotifications() async {
    final db = await instance.database;
    return await db.query('sent_notifications', orderBy: 'sentAt DESC');
  }
}