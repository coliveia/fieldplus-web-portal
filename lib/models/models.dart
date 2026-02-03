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
  final String? cpf;
  final String? segment; // B2C, B2B Massivo, B2B Avançado

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
    this.cpf,
    this.segment,
  });
}

// Product Model
class Product {
  final String id;
  final String name;
  final String type;
  final String status;
  final DateTime installDate;
  final String? speed;
  final String? technology; // GPON, HFC, ADSL

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.installDate,
    this.speed,
    this.technology,
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

// Visit Step Model - Etapas da Jornada
class VisitStep {
  final String id;
  final String title;
  final String description;
  final int order;
  final VisitStepStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? aiRecommendation;
  final bool requiresAction;
  final String? actionLabel;

  VisitStep({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.aiRecommendation,
    this.requiresAction = false,
    this.actionLabel,
  });

  VisitStep copyWith({
    String? id,
    String? title,
    String? description,
    int? order,
    VisitStepStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    String? aiRecommendation,
    bool? requiresAction,
    String? actionLabel,
  }) {
    return VisitStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      aiRecommendation: aiRecommendation ?? this.aiRecommendation,
      requiresAction: requiresAction ?? this.requiresAction,
      actionLabel: actionLabel ?? this.actionLabel,
    );
  }
}

enum VisitStepStatus { pending, inProgress, completed, error, skipped }

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
  final List<VisitStep> visitSteps;
  final int currentStepIndex;
  final GeoFenceStatus? geoFenceStatus;
  final List<Equipment> equipmentsUsed;
  final RVT? rvt;

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
    this.visitSteps = const [],
    this.currentStepIndex = 0,
    this.geoFenceStatus,
    this.equipmentsUsed = const [],
    this.rvt,
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
  final List<Achievement> achievements;

  Technician({
    required this.id,
    required this.name,
    required this.avatar,
    required this.points,
    required this.level,
    required this.completedToday,
    required this.totalAppointments,
    required this.rating,
    this.achievements = const [],
  });
}

// Achievement Model
class Achievement {
  final String id;
  final String title;
  final String icon;
  final bool unlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.icon,
    required this.unlocked,
    this.unlockedAt,
  });
}

// AI Insight Model - Enhanced for Tooltips
class AIInsight {
  final String id;
  final String title;
  final String description;
  final InsightType type;
  final String? action;
  final String? actionLabel;
  final String? secondaryAction;
  final String? secondaryActionLabel;
  final bool isProactive;
  final String? relatedStepId;
  final int priority; // 1-5, 1 being highest

  AIInsight({
    this.id = '',
    required this.title,
    required this.description,
    required this.type,
    this.action,
    this.actionLabel,
    this.secondaryAction,
    this.secondaryActionLabel,
    this.isProactive = false,
    this.relatedStepId,
    this.priority = 3,
  });
}

enum InsightType { warning, tip, recommendation, alert, success, info }

// GeoFence Status Model
class GeoFenceStatus {
  final bool isInsideArea;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final double distanceFromTarget;
  final String status; // 'checked_in', 'checked_out', 'outside_area'

  GeoFenceStatus({
    required this.isInsideArea,
    this.checkInTime,
    this.checkOutTime,
    required this.distanceFromTarget,
    required this.status,
  });
}

// Equipment Model
class Equipment {
  final String id;
  final String name;
  final String type;
  final String serialNumber;
  final String? model;
  final int quantity;

  Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.serialNumber,
    this.model,
    this.quantity = 1,
  });
}

// RVT - Relatório de Visita Técnica
class RVT {
  final String id;
  final String appointmentId;
  final String serviceDescription;
  final String resolution;
  final List<Equipment> equipmentsUsed;
  final String? customerSignature;
  final DateTime? signedAt;
  final List<String> photos;
  final bool isComplete;
  final String? observations;

  RVT({
    required this.id,
    required this.appointmentId,
    required this.serviceDescription,
    required this.resolution,
    required this.equipmentsUsed,
    this.customerSignature,
    this.signedAt,
    this.photos = const [],
    this.isComplete = false,
    this.observations,
  });
}

// Magic Tools Models
class NetworkDiagnostic {
  final String id;
  final String type; // 'speed', 'latency', 'connectivity', 'signal'
  final String status; // 'running', 'completed', 'failed'
  final double? result;
  final String? unit;
  final String? recommendation;
  final DateTime timestamp;

  NetworkDiagnostic({
    required this.id,
    required this.type,
    required this.status,
    this.result,
    this.unit,
    this.recommendation,
    required this.timestamp,
  });
}

class Maneuver {
  final String id;
  final String type; // 'unique', 'unified', 'gpon'
  final String description;
  final String status; // 'pending', 'executing', 'completed', 'failed'
  final List<ManeuverStep> steps;
  final String? errorMessage;

  Maneuver({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    required this.steps,
    this.errorMessage,
  });
}

class ManeuverStep {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isCurrentStep;

  ManeuverStep({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.isCurrentStep = false,
  });
}

// Certification Model
class Certification {
  final String id;
  final String type; // 'internet', 'voice', 'tv'
  final List<CertificationTest> tests;
  final bool isPassed;
  final DateTime? completedAt;
  final String? aiAnalysis;

  Certification({
    required this.id,
    required this.type,
    required this.tests,
    required this.isPassed,
    this.completedAt,
    this.aiAnalysis,
  });
}

class CertificationTest {
  final String id;
  final String name;
  final String description;
  final String status; // 'pending', 'running', 'passed', 'failed'
  final double? value;
  final double? expectedMin;
  final double? expectedMax;
  final String? unit;

  CertificationTest({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.value,
    this.expectedMin,
    this.expectedMax,
    this.unit,
  });
}

// Exception Flow Model
class ExceptionCase {
  final String id;
  final String type;
  final String title;
  final String description;
  final List<ExceptionAction> availableActions;
  final String? selectedAction;
  final String status; // 'open', 'in_progress', 'resolved', 'escalated'
  final DateTime createdAt;
  final String? resolution;

  ExceptionCase({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.availableActions,
    this.selectedAction,
    required this.status,
    required this.createdAt,
    this.resolution,
  });
}

class ExceptionAction {
  final String id;
  final String label;
  final String description;
  final String icon;
  final String actionType; // 'call_regional', 'magic_tools', 'co_chat', 'manual'

  ExceptionAction({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.actionType,
  });
}

// CO Chat Model
class COMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderType; // 'technician', 'co_operator', 'ai'
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? attachmentUrl;

  COMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.attachmentUrl,
  });
}

class COChat {
  final String id;
  final String appointmentId;
  final String status; // 'active', 'waiting', 'resolved'
  final List<COMessage> messages;
  final String? assignedOperator;
  final DateTime createdAt;
  final String? category; // 'internet', 'voice', 'tv', 'general'

  COChat({
    required this.id,
    required this.appointmentId,
    required this.status,
    required this.messages,
    this.assignedOperator,
    required this.createdAt,
    this.category,
  });
}
