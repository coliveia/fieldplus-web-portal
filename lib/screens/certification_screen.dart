import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class CertificationScreen extends StatefulWidget {
  const CertificationScreen({super.key});

  @override
  State<CertificationScreen> createState() => _CertificationScreenState();
}

class _CertificationScreenState extends State<CertificationScreen> {
  bool _isRunningTests = false;
  int _currentTestIndex = 0;
  String _selectedService = 'internet';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final tests = provider.certificationTests;

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
                    color: AppTheme.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.verified, color: AppTheme.success, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Certificação', style: AppTheme.headingSmall),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Selector
                _buildServiceSelector(),
                const SizedBox(height: 24),

                // AI Recommendation
                _buildAIRecommendation(),
                const SizedBox(height: 24),

                // Test Progress
                if (_isRunningTests) ...[
                  _buildTestProgress(tests),
                  const SizedBox(height: 24),
                ],

                // Test Results
                _buildSectionTitle('Resultados dos Testes'),
                const SizedBox(height: 12),
                ...tests.map((test) => _buildTestCard(test)),
                const SizedBox(height: 24),

                // Overall Result
                _buildOverallResult(tests),
                const SizedBox(height: 24),

                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceSelector() {
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
          Text('Selecione o Serviço', style: AppTheme.labelLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildServiceChip('internet', 'Internet', Icons.wifi),
              const SizedBox(width: 8),
              _buildServiceChip('voice', 'Voz', Icons.phone),
              const SizedBox(width: 8),
              _buildServiceChip('tv', 'TV', Icons.tv),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String id, String label, IconData icon) {
    final isSelected = _selectedService == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedService = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primaryPurple : AppTheme.divider,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.lightText,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.lightText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIRecommendation() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'I.Ajuda Recomenda',
                  style: AppTheme.labelSmall.copyWith(color: AppTheme.primaryPurple),
                ),
                const SizedBox(height: 4),
                Text(
                  'Baseado no plano do cliente (500MB), os testes devem atingir no mínimo 450 Mbps de download.',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestProgress(List<CertificationTest> tests) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Executando Testes...',
                style: AppTheme.labelLarge,
              ),
              Text(
                '${_currentTestIndex + 1}/${tests.length}',
                style: AppTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentTestIndex + 1) / tests.length,
              backgroundColor: AppTheme.lightPurple,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tests[_currentTestIndex].name,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.primaryPurple),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTheme.headingSmall.copyWith(fontSize: 16));
  }

  Widget _buildTestCard(CertificationTest test) {
    final isPassed = test.status == 'passed';
    final color = isPassed ? AppTheme.success : AppTheme.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isPassed ? Icons.check_circle : Icons.error,
                  color: color,
                  size: 24,
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
                    style: AppTheme.headingSmall.copyWith(
                      color: color,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isPassed ? '✓ Aprovado' : '✗ Reprovado',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar showing value vs expected
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Esperado: ${test.expectedMin} - ${test.expectedMax} ${test.unit}',
                    style: AppTheme.bodySmall,
                  ),
                  Text(
                    'Obtido: ${test.value?.toStringAsFixed(1)} ${test.unit}',
                    style: AppTheme.bodySmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _calculateProgress(test),
                  backgroundColor: AppTheme.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateProgress(CertificationTest test) {
    if (test.value == null || test.expectedMax == null) return 0;
    final progress = test.value! / test.expectedMax!;
    return progress.clamp(0.0, 1.0);
  }

  Widget _buildOverallResult(List<CertificationTest> tests) {
    final allPassed = tests.every((t) => t.status == 'passed');
    final passedCount = tests.where((t) => t.status == 'passed').length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: allPassed
            ? AppTheme.success.withOpacity(0.1)
            : AppTheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allPassed
              ? AppTheme.success.withOpacity(0.3)
              : AppTheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: allPassed ? AppTheme.success : AppTheme.error,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              allPassed ? Icons.verified : Icons.warning,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allPassed ? 'Certificação Aprovada!' : 'Certificação Reprovada',
                  style: AppTheme.headingSmall.copyWith(
                    color: allPassed ? AppTheme.success : AppTheme.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$passedCount de ${tests.length} testes aprovados',
                  style: AppTheme.bodyMedium,
                ),
                if (allPassed) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.warning, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '+30 pontos',
                        style: AppTheme.labelSmall.copyWith(
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isRunningTests ? null : _runTests,
            icon: _isRunningTests
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(_isRunningTests ? 'Executando...' : 'Executar Testes Novamente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check),
            label: const Text('Confirmar e Continuar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.success,
              side: const BorderSide(color: AppTheme.success),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _runTests() {
    setState(() {
      _isRunningTests = true;
      _currentTestIndex = 0;
    });

    // Simulate test execution
    _simulateTest();
  }

  void _simulateTest() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_currentTestIndex < 3) {
        setState(() {
          _currentTestIndex++;
        });
        _simulateTest();
      } else {
        setState(() {
          _isRunningTests = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todos os testes concluídos com sucesso!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    });
  }
}
