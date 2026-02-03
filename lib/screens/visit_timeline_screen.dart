import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_tooltip.dart';

class VisitTimelineScreen extends StatefulWidget {
  const VisitTimelineScreen({super.key});

  @override
  State<VisitTimelineScreen> createState() => _VisitTimelineScreenState();
}

class _VisitTimelineScreenState extends State<VisitTimelineScreen> {
  bool _showAITooltip = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final steps = provider.visitSteps;
        final currentStep = provider.currentVisitStepIndex;
        final tooltip = provider.currentAITooltip;
        final appointment = provider.selectedAppointment;

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppTheme.darkText),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jornada da Visita',
                  style: AppTheme.headingSmall,
                ),
                if (appointment != null)
                  Text(
                    appointment.customer.name,
                    style: AppTheme.bodySmall,
                  ),
              ],
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _showAITooltip = !_showAITooltip;
                  });
                  if (_showAITooltip) {
                    provider.showAITooltipAgain();
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  // Progress Header
                  _buildProgressHeader(steps, currentStep),
                  
                  // Timeline
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        return _buildTimelineItem(
                          context,
                          steps[index],
                          index,
                          currentStep,
                          provider,
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              // AI Tooltip Overlay
              if (_showAITooltip && tooltip != null && provider.showAITooltip)
                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: AITooltipWidget(
                    insight: tooltip,
                    onDismiss: () {
                      provider.dismissAITooltip();
                    },
                    onPrimaryAction: () {
                      provider.dismissAITooltip();
                      _handleTooltipAction(context, tooltip, provider);
                    },
                  ),
                ),
            ],
          ),
          bottomNavigationBar: _buildBottomActions(context, provider, currentStep, steps.length),
        );
      },
    );
  }

  Widget _buildProgressHeader(List<VisitStep> steps, int currentStep) {
    final completedSteps = steps.where((s) => s.status == VisitStepStatus.completed).length;
    final progress = completedSteps / steps.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Etapa ${currentStep + 1} de ${steps.length}',
                    style: AppTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps[currentStep].title,
                    style: AppTheme.headingSmall.copyWith(
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.lightPurple,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          // Mini step indicators
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(steps.length, (index) {
                final isCompleted = steps[index].status == VisitStepStatus.completed;
                final isCurrent = index == currentStep;
                final isError = steps[index].status == VisitStepStatus.error;
                
                return Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppTheme.success
                        : isError
                            ? AppTheme.error
                            : isCurrent
                                ? AppTheme.primaryPurple
                                : AppTheme.divider,
                    border: isCurrent
                        ? Border.all(color: AppTheme.primaryPurple, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : isError
                            ? const Icon(Icons.close, color: Colors.white, size: 14)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent ? Colors.white : AppTheme.lightText,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    VisitStep step,
    int index,
    int currentStep,
    AppProvider provider,
  ) {
    final isCompleted = step.status == VisitStepStatus.completed;
    final isCurrent = index == currentStep;
    final isError = step.status == VisitStepStatus.error;
    final isPending = step.status == VisitStepStatus.pending;

    return InkWell(
      onTap: isCurrent ? null : () => provider.goToVisitStep(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppTheme.success
                        : isError
                            ? AppTheme.error
                            : isCurrent
                                ? AppTheme.primaryPurple
                                : Colors.white,
                    border: Border.all(
                      color: isCompleted
                          ? AppTheme.success
                          : isError
                              ? AppTheme.error
                              : isCurrent
                                  ? AppTheme.primaryPurple
                                  : AppTheme.divider,
                      width: 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryPurple.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : isError
                            ? const Icon(Icons.close, color: Colors.white, size: 20)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent ? Colors.white : AppTheme.lightText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                ),
                if (index < provider.visitSteps.length - 1)
                  Container(
                    width: 2,
                    height: 60,
                    color: isCompleted ? AppTheme.success : AppTheme.divider,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.white : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: isCurrent
                      ? Border.all(color: AppTheme.primaryPurple.withOpacity(0.3), width: 2)
                      : null,
                  boxShadow: isCurrent ? AppTheme.cardShadow : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            step.title,
                            style: AppTheme.labelLarge.copyWith(
                              color: isPending ? AppTheme.lightText : AppTheme.darkText,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '✓ Concluído',
                              style: TextStyle(
                                color: AppTheme.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Em andamento',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step.description,
                      style: AppTheme.bodySmall.copyWith(
                        color: isPending ? AppTheme.lightText : AppTheme.mediumText,
                      ),
                    ),
                    if (step.requiresAction && isCurrent) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleStepAction(context, step, provider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(step.actionLabel ?? 'Executar'),
                        ),
                      ),
                    ],
                    if (step.aiRecommendation != null && isCurrent) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.primaryPurple.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: AppTheme.primaryPurple,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                step.aiRecommendation!,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    AppProvider provider,
    int currentStep,
    int totalSteps,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => provider.goToVisitStep(currentStep - 1),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Anterior'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryPurple,
                    side: const BorderSide(color: AppTheme.primaryPurple),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            if (currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: currentStep < totalSteps - 1
                    ? () => provider.advanceVisitStep()
                    : () => _completeVisit(context),
                icon: Icon(
                  currentStep < totalSteps - 1
                      ? Icons.arrow_forward
                      : Icons.check_circle,
                ),
                label: Text(
                  currentStep < totalSteps - 1 ? 'Próxima Etapa' : 'Concluir Visita',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentStep < totalSteps - 1
                      ? AppTheme.primaryPurple
                      : AppTheme.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleStepAction(BuildContext context, VisitStep step, AppProvider provider) {
    // Handle specific step actions
    switch (step.id) {
      case 'VS02': // Cerca Eletrônica - Check-in
      case 'VS11': // Cerca Eletrônica - Check-out
        _showGeoFenceDialog(context, provider, step.id == 'VS02');
        break;
      case 'VS04': // Autorização de Serviço
        _showSignatureDialog(context);
        break;
      case 'VS07': // Self-Provisioning
        Navigator.pushNamed(context, '/magic-tools');
        break;
      case 'VS08': // Certificação
        Navigator.pushNamed(context, '/certification');
        break;
      case 'VS10': // RVT
        Navigator.pushNamed(context, '/rvt');
        break;
      default:
        provider.advanceVisitStep();
    }
  }

  void _handleTooltipAction(BuildContext context, AIInsight tooltip, AppProvider provider) {
    // Handle tooltip actions based on type
    if (tooltip.actionLabel?.contains('Magic Tools') ?? false) {
      Navigator.pushNamed(context, '/magic-tools');
    } else if (tooltip.actionLabel?.contains('Navegação') ?? false) {
      // Open navigation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abrindo navegação...')),
      );
    } else {
      provider.advanceVisitStep();
    }
  }

  void _showGeoFenceDialog(BuildContext context, AppProvider provider, bool isCheckIn) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isCheckIn ? Icons.login : Icons.logout,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(width: 12),
            Text(isCheckIn ? 'Check-in' : 'Check-out'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: 60,
              color: AppTheme.success,
            ),
            const SizedBox(height: 16),
            Text(
              isCheckIn
                  ? 'Você está no local correto!'
                  : 'Confirmar saída do local?',
              style: AppTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Rua das Flores, 123 - Jardim Primavera',
              style: AppTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (isCheckIn) {
                provider.checkIn();
              } else {
                provider.checkOut();
              }
              Navigator.pop(context);
              provider.advanceVisitStep();
            },
            child: Text(isCheckIn ? 'Confirmar Check-in' : 'Confirmar Check-out'),
          ),
        ],
      ),
    );
  }

  void _showSignatureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.draw, color: AppTheme.primaryPurple),
            SizedBox(width: 12),
            Text('Assinatura Digital'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.divider),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Área de assinatura\n(Toque para assinar)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.lightText),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'O cliente deve assinar acima para autorizar o serviço.',
              style: AppTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AppProvider>(context, listen: false).advanceVisitStep();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _completeVisit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.celebration, color: AppTheme.success),
            SizedBox(width: 12),
            Text('Visita Concluída!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 80,
              color: AppTheme.success,
            ),
            const SizedBox(height: 16),
            Text(
              'Parabéns! Você concluiu o atendimento.',
              style: AppTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: AppTheme.warning),
                  const SizedBox(width: 8),
                  Text(
                    '+50 pontos',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
            ),
            child: const Text('Voltar ao Dashboard'),
          ),
        ],
      ),
    );
  }
}
