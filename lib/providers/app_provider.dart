import 'package:flutter/material.dart';
import '../models/models.dart';

class AppProvider extends ChangeNotifier {
  int _currentIndex = 0;
  Appointment? _selectedAppointment;
  
  int get currentIndex => _currentIndex;
  Appointment? get selectedAppointment => _selectedAppointment;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void selectAppointment(Appointment appointment) {
    _selectedAppointment = appointment;
    notifyListeners();
  }

  void clearSelectedAppointment() {
    _selectedAppointment = null;
    notifyListeners();
  }

  // Mock Technician Data
  Technician get currentTechnician => Technician(
    id: 'T001',
    name: 'Carlos Silva',
    avatar: '👨‍🔧',
    points: 2450,
    level: 5,
    completedToday: 3,
    totalAppointments: 5,
    rating: 4.8,
  );

  // Mock Appointments Data
  List<Appointment> get todayAppointments => [
    Appointment(
      id: 'A001',
      customer: Customer(
        id: 'C001',
        name: 'Ana Maria Santos',
        address: 'Rua das Flores, 123 - Jardim Primavera',
        phone: '(11) 98765-4321',
        email: 'ana.santos@email.com',
        products: [
          Product(
            id: 'P001',
            name: 'Fibra 500MB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2023, 3, 15),
          ),
          Product(
            id: 'P002',
            name: 'TV Premium',
            type: 'TV',
            status: 'Ativo',
            installDate: DateTime(2023, 3, 15),
          ),
        ],
        serviceHistory: [
          ServiceHistory(
            id: 'SH001',
            type: 'Instalação',
            description: 'Instalação inicial de Fibra + TV',
            date: DateTime(2023, 3, 15),
            status: 'Concluído',
            technicianName: 'João Pereira',
          ),
          ServiceHistory(
            id: 'SH002',
            type: 'Reparo',
            description: 'Troca de roteador com defeito',
            date: DateTime(2024, 8, 20),
            status: 'Concluído',
            technicianName: 'Maria Costa',
          ),
        ],
        temperature: CustomerTemperature.warm,
        yearsAsCustomer: 2,
      ),
      scheduledTime: DateTime.now().add(const Duration(hours: 1)),
      type: 'Reparo',
      description: 'Cliente relata lentidão na internet durante a noite',
      status: AppointmentStatus.pending,
      latitude: -23.5505,
      longitude: -46.6333,
      checklist: _generateChecklist(),
    ),
    Appointment(
      id: 'A002',
      customer: Customer(
        id: 'C002',
        name: 'João Costa Filho',
        address: 'Av. Paulista, 1000 - Bela Vista',
        phone: '(11) 91234-5678',
        email: 'joao.costa@email.com',
        products: [
          Product(
            id: 'P003',
            name: 'Fibra 1GB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2022, 6, 10),
          ),
        ],
        serviceHistory: [],
        temperature: CustomerTemperature.cool,
        yearsAsCustomer: 3,
      ),
      scheduledTime: DateTime.now().add(const Duration(hours: 3)),
      type: 'Instalação',
      description: 'Instalação de novo ponto de TV',
      status: AppointmentStatus.pending,
      latitude: -23.5629,
      longitude: -46.6544,
      checklist: _generateChecklist(),
    ),
    Appointment(
      id: 'A003',
      customer: Customer(
        id: 'C003',
        name: 'Maria Oliveira',
        address: 'Rua Augusta, 500 - Consolação',
        phone: '(11) 99876-5432',
        email: 'maria.oliveira@email.com',
        products: [
          Product(
            id: 'P004',
            name: 'Fibra 300MB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2024, 1, 5),
          ),
        ],
        serviceHistory: [
          ServiceHistory(
            id: 'SH003',
            type: 'Reclamação',
            description: 'Queda frequente de conexão',
            date: DateTime(2024, 11, 10),
            status: 'Pendente',
            technicianName: 'Carlos Silva',
          ),
        ],
        temperature: CustomerTemperature.hot,
        yearsAsCustomer: 1,
      ),
      scheduledTime: DateTime.now().add(const Duration(hours: 5)),
      type: 'Reparo Urgente',
      description: 'Sem internet há 2 dias - cliente muito insatisfeito',
      status: AppointmentStatus.pending,
      latitude: -23.5558,
      longitude: -46.6622,
      checklist: _generateChecklist(),
    ),
    Appointment(
      id: 'A004',
      customer: Customer(
        id: 'C004',
        name: 'Pedro Henrique Lima',
        address: 'Rua Oscar Freire, 200 - Pinheiros',
        phone: '(11) 98888-7777',
        email: 'pedro.lima@email.com',
        products: [
          Product(
            id: 'P005',
            name: 'Fibra 500MB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2023, 9, 20),
          ),
          Product(
            id: 'P006',
            name: 'Telefone Fixo',
            type: 'Voz',
            status: 'Ativo',
            installDate: DateTime(2023, 9, 20),
          ),
        ],
        serviceHistory: [],
        temperature: CustomerTemperature.cool,
        yearsAsCustomer: 1,
      ),
      scheduledTime: DateTime.now().add(const Duration(hours: 7)),
      type: 'Manutenção',
      description: 'Manutenção preventiva de equipamentos',
      status: AppointmentStatus.pending,
      latitude: -23.5667,
      longitude: -46.6789,
      checklist: _generateChecklist(),
    ),
    Appointment(
      id: 'A005',
      customer: Customer(
        id: 'C005',
        name: 'Fernanda Rodrigues',
        address: 'Alameda Santos, 800 - Cerqueira César',
        phone: '(11) 97777-6666',
        email: 'fernanda.rodrigues@email.com',
        products: [
          Product(
            id: 'P007',
            name: 'Fibra 1GB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2024, 5, 12),
          ),
          Product(
            id: 'P008',
            name: 'TV Premium Plus',
            type: 'TV',
            status: 'Ativo',
            installDate: DateTime(2024, 5, 12),
          ),
        ],
        serviceHistory: [],
        temperature: CustomerTemperature.cool,
        yearsAsCustomer: 1,
      ),
      scheduledTime: DateTime.now().add(const Duration(hours: 9)),
      type: 'Upgrade',
      description: 'Upgrade de plano e troca de equipamentos',
      status: AppointmentStatus.pending,
      latitude: -23.5612,
      longitude: -46.6555,
      checklist: _generateChecklist(),
    ),
  ];

  List<ChecklistItem> _generateChecklist() => [
    // Pré-Visita
    ChecklistItem(
      id: 'CL001',
      title: 'Validar disponibilidade de rede',
      description: 'Verificar se há sinal disponível na região',
      phase: ChecklistPhase.preVisit,
    ),
    ChecklistItem(
      id: 'CL002',
      title: 'Conferir materiais necessários',
      description: 'Verificar se todos os materiais estão no veículo',
      phase: ChecklistPhase.preVisit,
    ),
    ChecklistItem(
      id: 'CL003',
      title: 'Revisar contexto do cliente',
      description: 'Ler histórico e observações anteriores',
      phase: ChecklistPhase.preVisit,
    ),
    // Durante
    ChecklistItem(
      id: 'CL004',
      title: 'Confirmar presença do cliente',
      description: 'Validar que o cliente está no local',
      phase: ChecklistPhase.during,
    ),
    ChecklistItem(
      id: 'CL005',
      title: 'Fotografar CTO',
      description: 'Capturar imagem da caixa de terminação óptica',
      phase: ChecklistPhase.during,
    ),
    ChecklistItem(
      id: 'CL006',
      title: 'Realizar testes de conexão',
      description: 'Executar teste de velocidade e latência',
      phase: ChecklistPhase.during,
    ),
    ChecklistItem(
      id: 'CL007',
      title: 'Verificar configuração do roteador',
      description: 'Validar configurações de Wi-Fi e segurança',
      phase: ChecklistPhase.during,
    ),
    // Pós-Visita
    ChecklistItem(
      id: 'CL008',
      title: 'Registrar ações realizadas',
      description: 'Documentar todas as intervenções feitas',
      phase: ChecklistPhase.postVisit,
    ),
    ChecklistItem(
      id: 'CL009',
      title: 'Coletar assinatura do cliente',
      description: 'Obter confirmação digital do cliente',
      phase: ChecklistPhase.postVisit,
    ),
    ChecklistItem(
      id: 'CL010',
      title: 'Avaliar satisfação',
      description: 'Solicitar avaliação do atendimento',
      phase: ChecklistPhase.postVisit,
    ),
  ];

  // AI Insights
  List<AIInsight> getInsightsForCustomer(Customer customer) {
    List<AIInsight> insights = [];
    
    if (customer.temperature == CustomerTemperature.hot) {
      insights.add(AIInsight(
        title: 'Cliente Insatisfeito',
        description: 'Este cliente teve problemas recentes. Seja especialmente atencioso e ofereça soluções proativas.',
        type: InsightType.alert,
      ));
    }
    
    if (customer.serviceHistory.length > 2) {
      insights.add(AIInsight(
        title: 'Histórico de Chamados',
        description: 'Cliente com múltiplos chamados. Verifique se há um problema recorrente na infraestrutura.',
        type: InsightType.warning,
      ));
    }
    
    insights.add(AIInsight(
      title: 'Dica de Posicionamento',
      description: 'Baseado em visitas anteriores, o melhor local para o roteador é próximo à janela da sala.',
      type: InsightType.tip,
    ));
    
    if (customer.yearsAsCustomer >= 2) {
      insights.add(AIInsight(
        title: 'Oportunidade de Upgrade',
        description: 'Cliente fiel há ${customer.yearsAsCustomer} anos. Considere oferecer upgrade com desconto especial.',
        type: InsightType.recommendation,
        action: 'Ver Ofertas',
      ));
    }
    
    return insights;
  }

  // Update checklist item
  void updateChecklistItem(String appointmentId, String itemId, bool completed, {String? evidence}) {
    final appointment = todayAppointments.firstWhere((a) => a.id == appointmentId);
    final item = appointment.checklist.firstWhere((c) => c.id == itemId);
    item.isCompleted = completed;
    item.evidence = evidence;
    item.completedAt = completed ? DateTime.now() : null;
    notifyListeners();
  }
}
