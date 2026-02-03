import 'package:flutter/material.dart';
import '../models/models.dart';

class AppProvider extends ChangeNotifier {
  int _currentIndex = 0;
  Appointment? _selectedAppointment;
  int _currentVisitStepIndex = 0;
  bool _showAITooltip = true;
  AIInsight? _currentAITooltip;
  List<COMessage> _coMessages = [];
  bool _isInGeoFence = false;
  DateTime? _checkInTime;
  
  int get currentIndex => _currentIndex;
  Appointment? get selectedAppointment => _selectedAppointment;
  int get currentVisitStepIndex => _currentVisitStepIndex;
  bool get showAITooltip => _showAITooltip;
  AIInsight? get currentAITooltip => _currentAITooltip;
  List<COMessage> get coMessages => _coMessages;
  bool get isInGeoFence => _isInGeoFence;
  DateTime? get checkInTime => _checkInTime;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void selectAppointment(Appointment appointment) {
    _selectedAppointment = appointment;
    _currentVisitStepIndex = 0;
    _generateAITooltipForStep(0);
    notifyListeners();
  }

  void clearSelectedAppointment() {
    _selectedAppointment = null;
    _currentVisitStepIndex = 0;
    notifyListeners();
  }

  void advanceVisitStep() {
    if (_currentVisitStepIndex < visitSteps.length - 1) {
      _currentVisitStepIndex++;
      _generateAITooltipForStep(_currentVisitStepIndex);
      notifyListeners();
    }
  }

  void goToVisitStep(int index) {
    if (index >= 0 && index < visitSteps.length) {
      _currentVisitStepIndex = index;
      _generateAITooltipForStep(index);
      notifyListeners();
    }
  }

  void dismissAITooltip() {
    _showAITooltip = false;
    _currentAITooltip = null;
    notifyListeners();
  }

  void showAITooltipAgain() {
    _showAITooltip = true;
    _generateAITooltipForStep(_currentVisitStepIndex);
    notifyListeners();
  }

  void _generateAITooltipForStep(int stepIndex) {
    final tooltips = _getAITooltipsForSteps();
    if (stepIndex < tooltips.length) {
      _currentAITooltip = tooltips[stepIndex];
      _showAITooltip = true;
    }
  }

  // GeoFence Methods
  void checkIn() {
    _isInGeoFence = true;
    _checkInTime = DateTime.now();
    notifyListeners();
  }

  void checkOut() {
    _isInGeoFence = false;
    notifyListeners();
  }

  // CO Chat Methods
  void sendCOMessage(String content) {
    final message = COMessage(
      id: 'MSG${_coMessages.length + 1}',
      senderId: currentTechnician.id,
      senderName: currentTechnician.name,
      senderType: 'technician',
      content: content,
      timestamp: DateTime.now(),
    );
    _coMessages.add(message);
    notifyListeners();
    
    // Simulate CO response after delay
    Future.delayed(const Duration(seconds: 2), () {
      _simulateCOResponse(content);
    });
  }

  void _simulateCOResponse(String userMessage) {
    String response;
    if (userMessage.toLowerCase().contains('manobra')) {
      response = 'Entendido. Vou verificar a disponibilidade de porta na OLT mais próxima. Aguarde um momento...';
    } else if (userMessage.toLowerCase().contains('sinal') || userMessage.toLowerCase().contains('velocidade')) {
      response = 'Estou analisando os parâmetros de rede do cliente. Os níveis de sinal estão dentro do esperado. Recomendo verificar o splitter interno.';
    } else {
      response = 'Recebido! Estou analisando a situação. Posso ajudar com diagnóstico de rede, manobras ou escalonamento. O que precisa?';
    }
    
    final coResponse = COMessage(
      id: 'MSG${_coMessages.length + 1}',
      senderId: 'CO001',
      senderName: 'Central de Operações',
      senderType: 'co_operator',
      content: response,
      timestamp: DateTime.now(),
    );
    _coMessages.add(coResponse);
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
    achievements: [
      Achievement(id: 'ACH001', title: 'Primeira Instalação', icon: '🎯', unlocked: true, unlockedAt: DateTime(2024, 1, 15)),
      Achievement(id: 'ACH002', title: 'Velocista', icon: '⚡', unlocked: true, unlockedAt: DateTime(2024, 3, 20)),
      Achievement(id: 'ACH003', title: 'Cliente Feliz', icon: '😊', unlocked: true, unlockedAt: DateTime(2024, 5, 10)),
      Achievement(id: 'ACH004', title: 'Mestre das Manobras', icon: '🔧', unlocked: false),
      Achievement(id: 'ACH005', title: 'Zero Retrabalho', icon: '✨', unlocked: false),
    ],
  );

  // Visit Steps - Etapas da Jornada
  List<VisitStep> get visitSteps => [
    VisitStep(
      id: 'VS01',
      title: 'Iniciar Rota',
      description: 'Confirmar início do deslocamento',
      order: 1,
      status: _currentVisitStepIndex > 0 ? VisitStepStatus.completed : (_currentVisitStepIndex == 0 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
      aiRecommendation: 'Rota otimizada calculada. Tempo estimado: 15 min.',
    ),
    VisitStep(
      id: 'VS02',
      title: 'Cerca Eletrônica',
      description: 'Check-in na localização do cliente',
      order: 2,
      status: _currentVisitStepIndex > 1 ? VisitStepStatus.completed : (_currentVisitStepIndex == 1 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
      requiresAction: true,
      actionLabel: 'Fazer Check-in',
    ),
    VisitStep(
      id: 'VS03',
      title: 'Início da Atividade',
      description: 'Registrar início do atendimento',
      order: 3,
      status: _currentVisitStepIndex > 2 ? VisitStepStatus.completed : (_currentVisitStepIndex == 2 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
    ),
    VisitStep(
      id: 'VS04',
      title: 'Autorização de Serviço',
      description: 'Receber autorização do cliente',
      order: 4,
      status: _currentVisitStepIndex > 3 ? VisitStepStatus.completed : (_currentVisitStepIndex == 3 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
      requiresAction: true,
      actionLabel: 'Coletar Assinatura',
    ),
    VisitStep(
      id: 'VS05',
      title: 'Instalação Física',
      description: 'Cabo + HGU / Equipamentos',
      order: 5,
      status: _currentVisitStepIndex > 4 ? VisitStepStatus.completed : (_currentVisitStepIndex == 4 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
    ),
    VisitStep(
      id: 'VS06',
      title: 'Emparelhamento de Rede',
      description: 'Configurar conexão de rede',
      order: 6,
      status: _currentVisitStepIndex > 5 ? VisitStepStatus.completed : (_currentVisitStepIndex == 5 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
      aiRecommendation: 'Use Magic Tools para diagnóstico automático.',
    ),
    VisitStep(
      id: 'VS07',
      title: 'Self-Provisioning',
      description: 'Configuração automática do equipamento',
      order: 7,
      status: _currentVisitStepIndex > 6 ? VisitStepStatus.completed : (_currentVisitStepIndex == 6 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
      requiresAction: true,
      actionLabel: 'Iniciar Provisioning',
    ),
    VisitStep(
      id: 'VS08',
      title: 'Certificação',
      description: 'Testes de qualidade do serviço',
      order: 8,
      status: _currentVisitStepIndex > 7 ? VisitStepStatus.completed : (_currentVisitStepIndex == 7 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
      requiresAction: true,
      actionLabel: 'Executar Testes',
    ),
    VisitStep(
      id: 'VS09',
      title: 'Equipamento Utilizado',
      description: 'Registrar materiais utilizados',
      order: 9,
      status: _currentVisitStepIndex > 8 ? VisitStepStatus.completed : (_currentVisitStepIndex == 8 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
    ),
    VisitStep(
      id: 'VS10',
      title: 'RVT',
      description: 'Relatório de Visita Técnica',
      order: 10,
      status: _currentVisitStepIndex > 9 ? VisitStepStatus.completed : (_currentVisitStepIndex == 9 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
      requiresAction: true,
      actionLabel: 'Preencher RVT',
    ),
    VisitStep(
      id: 'VS11',
      title: 'Cerca Eletrônica',
      description: 'Check-out da localização',
      order: 11,
      status: _currentVisitStepIndex > 10 ? VisitStepStatus.completed : (_currentVisitStepIndex == 10 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
      requiresAction: true,
      actionLabel: 'Fazer Check-out',
    ),
    VisitStep(
      id: 'VS12',
      title: 'Concluir Atividade',
      description: 'Finalizar atendimento',
      order: 12,
      status: _currentVisitStepIndex > 11 ? VisitStepStatus.completed : (_currentVisitStepIndex == 11 ? VisitStepStatus.inProgress : VisitStepStatus.pending),
    ),
  ];

  // AI Tooltips for each step
  List<AIInsight> _getAITooltipsForSteps() => [
    AIInsight(
      id: 'TIP01',
      title: '🚗 Rota Otimizada',
      description: 'Calculei a melhor rota considerando trânsito atual. Tempo estimado: 15 minutos. Evite a Av. Paulista - congestionamento.',
      type: InsightType.tip,
      actionLabel: 'Abrir Navegação',
      isProactive: true,
      priority: 2,
    ),
    AIInsight(
      id: 'TIP02',
      title: '📍 Chegou ao Local',
      description: 'Detectei que você está próximo ao endereço. Faça o check-in para registrar sua chegada.',
      type: InsightType.info,
      actionLabel: 'Check-in Automático',
      isProactive: true,
      priority: 1,
    ),
    AIInsight(
      id: 'TIP03',
      title: '⚠️ Cliente Sensível',
      description: 'Este cliente teve 3 chamados nos últimos 30 dias. Seja especialmente atencioso e explique cada etapa.',
      type: InsightType.warning,
      isProactive: true,
      priority: 1,
    ),
    AIInsight(
      id: 'TIP04',
      title: '✍️ Autorização Digital',
      description: 'Colete a assinatura digital do cliente antes de iniciar. Isso protege você e a empresa.',
      type: InsightType.info,
      actionLabel: 'Coletar Assinatura',
      isProactive: true,
      priority: 2,
    ),
    AIInsight(
      id: 'TIP05',
      title: '🔧 Materiais Sugeridos',
      description: 'Baseado no tipo de serviço, você vai precisar: 1x Cabo coaxial 10m, 1x Splitter 2 vias, 1x HGU.',
      type: InsightType.recommendation,
      actionLabel: 'Confirmar Lista',
      secondaryActionLabel: 'Editar',
      isProactive: true,
      priority: 2,
    ),
    AIInsight(
      id: 'TIP06',
      title: '🌐 Diagnóstico de Rede',
      description: 'Detectei instabilidade no sinal. Recomendo usar Magic Tools para diagnóstico antes de prosseguir.',
      type: InsightType.warning,
      actionLabel: 'Abrir Magic Tools',
      isProactive: true,
      priority: 1,
    ),
    AIInsight(
      id: 'TIP07',
      title: '⚡ Self-Provisioning',
      description: 'Equipamento HGU modelo ZTE F670L detectado. Posso configurar automaticamente em 2 minutos.',
      type: InsightType.tip,
      actionLabel: 'Configurar Agora',
      secondaryActionLabel: 'Manual',
      isProactive: true,
      priority: 2,
    ),
    AIInsight(
      id: 'TIP08',
      title: '✅ Certificação Automática',
      description: 'Executando testes de velocidade, latência e estabilidade. Resultado em 30 segundos.',
      type: InsightType.info,
      isProactive: true,
      priority: 3,
    ),
    AIInsight(
      id: 'TIP09',
      title: '📦 Registro de Materiais',
      description: 'Detectei os equipamentos utilizados via leitura de código. Confirme a lista para registro automático.',
      type: InsightType.tip,
      actionLabel: 'Confirmar',
      isProactive: true,
      priority: 2,
    ),
    AIInsight(
      id: 'TIP10',
      title: '📝 RVT Inteligente',
      description: 'Preenchi o relatório automaticamente com base nas ações realizadas. Revise e adicione observações.',
      type: InsightType.success,
      actionLabel: 'Revisar RVT',
      isProactive: true,
      priority: 2,
    ),
    AIInsight(
      id: 'TIP11',
      title: '📍 Check-out',
      description: 'Não esqueça de fazer check-out antes de sair. Isso valida o tempo de atendimento.',
      type: InsightType.info,
      actionLabel: 'Check-out',
      isProactive: true,
      priority: 1,
    ),
    AIInsight(
      id: 'TIP12',
      title: '🎉 Atendimento Concluído!',
      description: 'Excelente trabalho! Você ganhou +50 pontos. Próximo atendimento em 25 minutos.',
      type: InsightType.success,
      actionLabel: 'Ver Próximo',
      isProactive: true,
      priority: 3,
    ),
  ];

  // Exception Cases
  List<ExceptionCase> get exceptionCases => [
    ExceptionCase(
      id: 'EXC01',
      type: 'no_activity',
      title: 'Técnico sem atividade na fila',
      description: 'Não há atividades atribuídas no momento',
      availableActions: [
        ExceptionAction(id: 'EA01', label: 'Ligar Regional', description: 'Contatar supervisor regional', icon: '📞', actionType: 'call_regional'),
        ExceptionAction(id: 'EA02', label: 'Solicitar Atividade', description: 'Pedir nova atribuição', icon: '📋', actionType: 'manual'),
      ],
      status: 'open',
      createdAt: DateTime.now(),
    ),
    ExceptionCase(
      id: 'EXC02',
      type: 'customer_not_found',
      title: 'Cliente não encontrado',
      description: 'Cliente não está no local ou não reconhece o serviço',
      availableActions: [
        ExceptionAction(id: 'EA03', label: 'Ligar Regional', description: 'Contatar supervisor', icon: '📞', actionType: 'call_regional'),
        ExceptionAction(id: 'EA04', label: 'Reagendar', description: 'Agendar nova visita', icon: '📅', actionType: 'manual'),
      ],
      status: 'open',
      createdAt: DateTime.now(),
    ),
    ExceptionCase(
      id: 'EXC03',
      type: 'needs_maneuver',
      title: 'Necessita Manobra',
      description: 'Serviço requer manobra de rede',
      availableActions: [
        ExceptionAction(id: 'EA05', label: 'Magic Tools', description: 'Usar ferramentas de manobra', icon: '🔧', actionType: 'magic_tools'),
        ExceptionAction(id: 'EA06', label: 'Chat CO', description: 'Contatar Centro de Operações', icon: '💬', actionType: 'co_chat'),
      ],
      status: 'open',
      createdAt: DateTime.now(),
    ),
    ExceptionCase(
      id: 'EXC04',
      type: 'co_action',
      title: 'Ação via Centro de Operações',
      description: 'Requer intervenção do CO para Internet/Voz/TV',
      availableActions: [
        ExceptionAction(id: 'EA07', label: 'Chat CO - Internet', description: 'Suporte para problemas de internet', icon: '🌐', actionType: 'co_chat'),
        ExceptionAction(id: 'EA08', label: 'Chat CO - Voz', description: 'Suporte para telefonia', icon: '📞', actionType: 'co_chat'),
        ExceptionAction(id: 'EA09', label: 'Chat CO - TV', description: 'Suporte para TV', icon: '📺', actionType: 'co_chat'),
      ],
      status: 'open',
      createdAt: DateTime.now(),
    ),
    ExceptionCase(
      id: 'EXC05',
      type: 'equipment_issue',
      title: 'Problema ao indicar equipamento',
      description: 'Erro no registro de equipamento utilizado',
      availableActions: [
        ExceptionAction(id: 'EA10', label: 'Ligar Regional', description: 'Contatar supervisor', icon: '📞', actionType: 'call_regional'),
        ExceptionAction(id: 'EA11', label: 'Registro Manual', description: 'Inserir dados manualmente', icon: '✏️', actionType: 'manual'),
      ],
      status: 'open',
      createdAt: DateTime.now(),
    ),
    ExceptionCase(
      id: 'EXC06',
      type: 'rvt_error',
      title: 'RVT não funciona',
      description: 'Erro ao gerar ou enviar relatório',
      availableActions: [
        ExceptionAction(id: 'EA12', label: 'Ligar Regional', description: 'Contatar supervisor', icon: '📞', actionType: 'call_regional'),
        ExceptionAction(id: 'EA13', label: 'Salvar Offline', description: 'Salvar para envio posterior', icon: '💾', actionType: 'manual'),
      ],
      status: 'open',
      createdAt: DateTime.now(),
    ),
  ];

  // Magic Tools Data
  List<NetworkDiagnostic> get networkDiagnostics => [
    NetworkDiagnostic(
      id: 'ND01',
      type: 'speed_download',
      status: 'completed',
      result: 487.5,
      unit: 'Mbps',
      recommendation: 'Velocidade dentro do esperado para plano 500MB',
      timestamp: DateTime.now(),
    ),
    NetworkDiagnostic(
      id: 'ND02',
      type: 'speed_upload',
      status: 'completed',
      result: 245.2,
      unit: 'Mbps',
      recommendation: 'Upload adequado',
      timestamp: DateTime.now(),
    ),
    NetworkDiagnostic(
      id: 'ND03',
      type: 'latency',
      status: 'completed',
      result: 12.5,
      unit: 'ms',
      recommendation: 'Latência excelente',
      timestamp: DateTime.now(),
    ),
    NetworkDiagnostic(
      id: 'ND04',
      type: 'signal',
      status: 'completed',
      result: -18.5,
      unit: 'dBm',
      recommendation: 'Sinal óptico dentro dos parâmetros',
      timestamp: DateTime.now(),
    ),
  ];

  // Certification Tests
  List<CertificationTest> get certificationTests => [
    CertificationTest(
      id: 'CT01',
      name: 'Teste de Velocidade',
      description: 'Verificar velocidade de download e upload',
      status: 'passed',
      value: 487.5,
      expectedMin: 450,
      expectedMax: 550,
      unit: 'Mbps',
    ),
    CertificationTest(
      id: 'CT02',
      name: 'Teste de Latência',
      description: 'Verificar tempo de resposta',
      status: 'passed',
      value: 12.5,
      expectedMin: 0,
      expectedMax: 30,
      unit: 'ms',
    ),
    CertificationTest(
      id: 'CT03',
      name: 'Teste de Estabilidade',
      description: 'Verificar perda de pacotes',
      status: 'passed',
      value: 0.1,
      expectedMin: 0,
      expectedMax: 1,
      unit: '%',
    ),
    CertificationTest(
      id: 'CT04',
      name: 'Teste de Sinal Óptico',
      description: 'Verificar potência do sinal',
      status: 'passed',
      value: -18.5,
      expectedMin: -25,
      expectedMax: -8,
      unit: 'dBm',
    ),
  ];

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
        cpf: '123.456.789-00',
        segment: 'B2C',
        products: [
          Product(
            id: 'P001',
            name: 'Fibra 500MB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2023, 3, 15),
            speed: '500 Mbps',
            technology: 'GPON',
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
        segment: 'B2C',
        products: [
          Product(
            id: 'P003',
            name: 'Fibra 1GB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2022, 6, 10),
            speed: '1 Gbps',
            technology: 'GPON',
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
        segment: 'B2C',
        products: [
          Product(
            id: 'P004',
            name: 'Fibra 300MB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2024, 1, 5),
            speed: '300 Mbps',
            technology: 'GPON',
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
        segment: 'B2B Massivo',
        products: [
          Product(
            id: 'P005',
            name: 'Fibra 500MB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2023, 9, 20),
            speed: '500 Mbps',
            technology: 'GPON',
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
        segment: 'B2B Avançado',
        products: [
          Product(
            id: 'P007',
            name: 'Fibra 1GB',
            type: 'Internet',
            status: 'Ativo',
            installDate: DateTime(2024, 5, 12),
            speed: '1 Gbps',
            technology: 'GPON',
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
        id: 'INS01',
        title: 'Cliente Insatisfeito',
        description: 'Este cliente teve problemas recentes. Seja especialmente atencioso e ofereça soluções proativas.',
        type: InsightType.alert,
        priority: 1,
      ));
    }
    
    if (customer.serviceHistory.length > 2) {
      insights.add(AIInsight(
        id: 'INS02',
        title: 'Histórico de Chamados',
        description: 'Cliente com múltiplos chamados. Verifique se há um problema recorrente na infraestrutura.',
        type: InsightType.warning,
        priority: 2,
      ));
    }
    
    insights.add(AIInsight(
      id: 'INS03',
      title: 'Dica de Posicionamento',
      description: 'Baseado em visitas anteriores, o melhor local para o roteador é próximo à janela da sala.',
      type: InsightType.tip,
      priority: 3,
    ));
    
    if (customer.yearsAsCustomer >= 2) {
      insights.add(AIInsight(
        id: 'INS04',
        title: 'Oportunidade de Upgrade',
        description: 'Cliente fiel há ${customer.yearsAsCustomer} anos. Considere oferecer upgrade com desconto especial.',
        type: InsightType.recommendation,
        actionLabel: 'Ver Ofertas',
        priority: 3,
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
