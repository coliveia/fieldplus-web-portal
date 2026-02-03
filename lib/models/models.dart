// Customer Model
class Customer {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final List<Product> products;
  final List<ServiceHistory> serviceHistory;
  final CustomerTemperature temperature;
  final int yearsAsCustomer;

  Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.products,
    required this.serviceHistory,
    required this.temperature,
    required this.yearsAsCustomer,
  });
}

// Product Model
class Product {
  final String id;
  final String name;
  final String type;
  final String status;
  final DateTime installDate;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.installDate,
  });
}

// Service History Model
class ServiceHistory {
  final String id;
  final String type;
  final String description;
  final DateTime date;
  final String status;
  final String technicianName;

  ServiceHistory({
    required this.id,
    required this.type,
    required this.description,
    required this.date,
    required this.status,
    required this.technicianName,
  });
}

// Customer Temperature Enum
enum CustomerTemperature { hot, warm, cool }

// Appointment Model
class Appointment {
  final String id;
  final Customer customer;
  final DateTime scheduledTime;
  final String type;
  final String description;
  final AppointmentStatus status;
  final double latitude;
  final double longitude;
  final String? notes;
  final List<ChecklistItem> checklist;

  Appointment({
    required this.id,
    required this.customer,
    required this.scheduledTime,
    required this.type,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.notes,
    required this.checklist,
  });
}

// Appointment Status Enum
enum AppointmentStatus { pending, inProgress, completed, cancelled }

// Checklist Item Model
class ChecklistItem {
  final String id;
  final String title;
  final String description;
  final ChecklistPhase phase;
  bool isCompleted;
  String? evidence;
  DateTime? completedAt;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.phase,
    this.isCompleted = false,
    this.evidence,
    this.completedAt,
  });
}

// Checklist Phase Enum
enum ChecklistPhase { preVisit, during, postVisit }

// Technician Model
class Technician {
  final String id;
  final String name;
  final String avatar;
  final int points;
  final int level;
  final int completedToday;
  final int totalAppointments;
  final double rating;

  Technician({
    required this.id,
    required this.name,
    required this.avatar,
    required this.points,
    required this.level,
    required this.completedToday,
    required this.totalAppointments,
    required this.rating,
  });
}

// AI Insight Model
class AIInsight {
  final String title;
  final String description;
  final InsightType type;
  final String? action;

  AIInsight({
    required this.title,
    required this.description,
    required this.type,
    this.action,
  });
}

enum InsightType { warning, tip, recommendation, alert }
