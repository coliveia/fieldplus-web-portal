import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_tooltip.dart';
import '../models/models.dart';

class MagicToolsScreen extends StatefulWidget {
  const MagicToolsScreen({super.key});

  @override
  State<MagicToolsScreen> createState() => _MagicToolsScreenState();
}

class _MagicToolsScreenState extends State<MagicToolsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRunningDiagnostic = false;
  bool _showAIRecommendation = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.build, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text('Magic Tools', style: AppTheme.headingSmall),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryPurple,
          unselectedLabelColor: AppTheme.lightText,
          indicatorColor: AppTheme.primaryPurple,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Diagnóstico'),
            Tab(text: 'Manobras'),
            Tab(text: 'Provisioning'),
            Tab(text: 'Testes'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildDiagnosticTab(),
              _buildManeuversTab(),
              _buildProvisioningTab(),
              _buildTestsTab(),
            ],
          ),
          // AI Recommendation
          if (_showAIRecommendation)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildAIRecommendation(),
            ),
        ],
      ),
      floatingActionButton: FloatingAIButton(
        onPressed: () {
          setState(() {
            _showAIRecommendation = !_showAIRecommendation;
          });
        },
        hasNotification: true,
      ),
    );
  }

  Widget _buildDiagnosticTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final diagnostics = provider.networkDiagnostics;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Actions
              _buildSectionTitle('Ações Rápidas'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.speed,
                      title: 'Teste de\nVelocidade',
                      color: Colors.blue,
                      onTap: () => _runDiagnostic('speed'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.network_check,
                      title: 'Verificar\nConexão',
                      color: Colors.green,
                      onTap: () => _runDiagnostic('connectivity'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      icon: Icons.signal_cellular_alt,
                      title: 'Sinal\nÓptico',
                      color: Colors.orange,
                      onTap: () => _runDiagnostic('signal'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Run All Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isRunningDiagnostic ? null : () => _runAllDiagnostics(),
                  icon: _isRunningDiagnostic
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_isRunningDiagnostic
                      ? 'Executando diagnóstico...'
                      : 'Executar Diagnóstico Completo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Results
              _buildSectionTitle('Resultados'),
              const SizedBox(height: 12),
              ...diagnostics.map((d) => _buildDiagnosticResult(d)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildManeuversTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Tipos de Manobra'),
          const SizedBox(height: 12),
          _buildManeuverCard(
            title: 'Manobra Única',
            description: 'Reconfiguração de porta única na OLT',
            icon: Icons.swap_horiz,
            color: Colors.blue,
            steps: ['Identificar porta', 'Desconectar', 'Reconectar', 'Validar'],
          ),
          const SizedBox(height: 12),
          _buildManeuverCard(
            title: 'Manobra Unificada',
            description: 'Migração completa de serviços',
            icon: Icons.sync_alt,
            color: Colors.purple,
            steps: ['Backup config', 'Migrar serviços', 'Validar', 'Confirmar'],
          ),
          const SizedBox(height: 12),
          _buildManeuverCard(
            title: 'Manobra GPON',
            description: 'Configuração de rede GPON',
            icon: Icons.router,
            color: Colors.orange,
            steps: ['Verificar OLT', 'Configurar ONT', 'Ativar', 'Testar'],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Histórico de Manobras'),
          const SizedBox(height: 12),
          _buildManeuverHistory(),
        ],
      ),
    );
  }

  Widget _buildProvisioningTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Equipment Detection
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple.withOpacity(0.1),
                  AppTheme.accentPink.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.router,
                  size: 60,
                  color: AppTheme.primaryPurple,
                ),
                const SizedBox(height: 16),
                Text(
                  'Equipamento Detectado',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'ZTE F670L',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Serial: ZTEGC8F12345',
                  style: AppTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatusChip('Conectado', Colors.green),
                    const SizedBox(width: 8),
                    _buildStatusChip('GPON', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Self-Provisioning'),
          const SizedBox(height: 12),

          // Provisioning Steps
          _buildProvisioningStep(
            step: 1,
            title: 'Detectar Equipamento',
            status: 'completed',
            description: 'ZTE F670L identificado',
          ),
          _buildProvisioningStep(
            step: 2,
            title: 'Verificar Rede',
            status: 'completed',
            description: 'Conexão GPON ativa',
          ),
          _buildProvisioningStep(
            step: 3,
            title: 'Configurar Serviços',
            status: 'in_progress',
            description: 'Internet 500MB + TV',
          ),
          _buildProvisioningStep(
            step: 4,
            title: 'Ativar',
            status: 'pending',
            description: 'Aguardando configuração',
          ),
          _buildProvisioningStep(
            step: 5,
            title: 'Validar',
            status: 'pending',
            description: 'Testes de qualidade',
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _startProvisioning(),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar Provisioning Automático'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.success,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestsTab() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final tests = provider.certificationTests;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Certificação de Serviços'),
              const SizedBox(height: 12),

              // Service Type Selector
              Row(
                children: [
                  _buildServiceTypeChip('Internet', Icons.wifi, true),
                  const SizedBox(width: 8),
                  _buildServiceTypeChip('Voz', Icons.phone, false),
                  const SizedBox(width: 8),
                  _buildServiceTypeChip('TV', Icons.tv, false),
                ],
              ),
              const SizedBox(height: 24),

              // Test Results
              ...tests.map((test) => _buildTestResult(test)),

              const SizedBox(height: 24),

              // Overall Status
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Certificação Aprovada',
                            style: AppTheme.headingSmall.copyWith(
                              color: AppTheme.success,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Todos os testes passaram com sucesso',
                            style: AppTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text('Executar Novamente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.headingSmall.copyWith(fontSize: 16),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.labelSmall.copyWith(
                color: AppTheme.darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticResult(NetworkDiagnostic diagnostic) {
    IconData icon;
    String title;
    Color color;

    switch (diagnostic.type) {
      case 'speed_download':
        icon = Icons.download;
        title = 'Download';
        color = Colors.blue;
        break;
      case 'speed_upload':
        icon = Icons.upload;
        title = 'Upload';
        color = Colors.green;
        break;
      case 'latency':
        icon = Icons.timer;
        title = 'Latência';
        color = Colors.orange;
        break;
      case 'signal':
        icon = Icons.signal_cellular_alt;
        title = 'Sinal Óptico';
        color = Colors.purple;
        break;
      default:
        icon = Icons.analytics;
        title = 'Teste';
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.labelLarge),
                if (diagnostic.recommendation != null)
                  Text(
                    diagnostic.recommendation!,
                    style: AppTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${diagnostic.result?.toStringAsFixed(1)} ${diagnostic.unit}',
                style: AppTheme.headingSmall.copyWith(
                  color: color,
                  fontSize: 18,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✓ OK',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManeuverCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> steps,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.labelLarge),
                    Text(description, style: AppTheme.bodySmall),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _startManeuver(title),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Iniciar'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: steps.asMap().entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.value,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.darkText,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildManeuverHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildHistoryItem(
            'Manobra Única',
            'Concluída',
            '10:30',
            AppTheme.success,
          ),
          const Divider(),
          _buildHistoryItem(
            'Manobra GPON',
            'Concluída',
            '09:15',
            AppTheme.success,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String status, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.labelLarge),
                Text(status, style: AppTheme.bodySmall),
              ],
            ),
          ),
          Text(time, style: AppTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildProvisioningStep({
    required int step,
    required String title,
    required String status,
    required String description,
  }) {
    Color color;
    IconData icon;

    switch (status) {
      case 'completed':
        color = AppTheme.success;
        icon = Icons.check_circle;
        break;
      case 'in_progress':
        color = AppTheme.primaryPurple;
        icon = Icons.radio_button_checked;
        break;
      default:
        color = AppTheme.lightText;
        icon = Icons.radio_button_unchecked;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Column(
            children: [
              Icon(icon, color: color, size: 24),
              if (step < 5)
                Container(
                  width: 2,
                  height: 30,
                  color: status == 'completed' ? AppTheme.success : AppTheme.divider,
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: status == 'in_progress'
                    ? AppTheme.primaryPurple.withOpacity(0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: status == 'in_progress'
                    ? Border.all(color: AppTheme.primaryPurple.withOpacity(0.3))
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.labelLarge.copyWith(
                            color: status == 'pending'
                                ? AppTheme.lightText
                                : AppTheme.darkText,
                          ),
                        ),
                        Text(
                          description,
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (status == 'in_progress')
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeChip(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryPurple : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppTheme.primaryPurple : AppTheme.divider,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : AppTheme.lightText,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.lightText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResult(CertificationTest test) {
    final isPassed = test.status == 'passed';
    final color = isPassed ? AppTheme.success : AppTheme.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPassed ? Icons.check : Icons.close,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(test.name, style: AppTheme.labelLarge),
                Text(test.description, style: AppTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${test.value?.toStringAsFixed(1)} ${test.unit}',
                style: AppTheme.labelLarge.copyWith(color: color),
              ),
              Text(
                'Esperado: ${test.expectedMin}-${test.expectedMax}',
                style: AppTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIRecommendation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppTheme.primaryPurple.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'I.Ajuda Recomenda',
                  style: AppTheme.labelSmall.copyWith(
                    color: AppTheme.primaryPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Detectei instabilidade no sinal. Execute o diagnóstico de sinal óptico para identificar o problema.',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showAIRecommendation = false;
              });
            },
            icon: const Icon(Icons.close, size: 20),
            color: AppTheme.lightText,
          ),
        ],
      ),
    );
  }

  void _runDiagnostic(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Executando diagnóstico de $type...'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _runAllDiagnostics() {
    setState(() {
      _isRunningDiagnostic = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isRunningDiagnostic = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diagnóstico completo! Todos os testes passaram.'),
          backgroundColor: AppTheme.success,
        ),
      );
    });
  }

  void _startManeuver(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Iniciar $type'),
        content: const Text('Deseja iniciar esta manobra? O processo pode levar alguns minutos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$type iniciada...'),
                  backgroundColor: AppTheme.primaryPurple,
                ),
              );
            },
            child: const Text('Iniciar'),
          ),
        ],
      ),
    );
  }

  void _startProvisioning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Iniciando Self-Provisioning automático...'),
        backgroundColor: AppTheme.success,
      ),
    );
  }
}
