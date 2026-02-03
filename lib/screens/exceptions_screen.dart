import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class ExceptionsScreen extends StatefulWidget {
  const ExceptionsScreen({super.key});

  @override
  State<ExceptionsScreen> createState() => _ExceptionsScreenState();
}

class _ExceptionsScreenState extends State<ExceptionsScreen> {
  String? _selectedExceptionId;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final exceptions = provider.exceptionCases;

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
                    color: AppTheme.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.warning_amber, color: AppTheme.warning, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Fluxo de Exceção', style: AppTheme.headingSmall),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Recommendation
                _buildAIRecommendation(),
                const SizedBox(height: 24),

                // Exception Types
                _buildSectionTitle('Selecione o Problema'),
                const SizedBox(height: 12),
                ...exceptions.map((exc) => _buildExceptionCard(exc)),
                const SizedBox(height: 24),

                // Quick Actions
                if (_selectedExceptionId != null) ...[
                  _buildSectionTitle('Ações Disponíveis'),
                  const SizedBox(height: 12),
                  _buildActionsForException(
                    exceptions.firstWhere((e) => e.id == _selectedExceptionId),
                  ),
                ],
              ],
            ),
          ),
        );
      },
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
                  'I.Ajuda Detectou',
                  style: AppTheme.labelSmall.copyWith(color: AppTheme.primaryPurple),
                ),
                const SizedBox(height: 4),
                Text(
                  'Parece que você está enfrentando um problema. Selecione o tipo de exceção para ver as soluções disponíveis.',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTheme.headingSmall.copyWith(fontSize: 16));
  }

  Widget _buildExceptionCard(ExceptionCase exception) {
    final isSelected = _selectedExceptionId == exception.id;
    IconData icon;
    Color color;

    switch (exception.type) {
      case 'no_activity':
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        break;
      case 'customer_not_found':
        icon = Icons.person_off;
        color = Colors.red;
        break;
      case 'needs_maneuver':
        icon = Icons.build;
        color = Colors.blue;
        break;
      case 'co_action':
        icon = Icons.support_agent;
        color = Colors.purple;
        break;
      case 'equipment_issue':
        icon = Icons.devices;
        color = Colors.amber;
        break;
      case 'rvt_error':
        icon = Icons.description;
        color = Colors.red;
        break;
      default:
        icon = Icons.error;
        color = Colors.grey;
    }

    return InkWell(
      onTap: () => setState(() => _selectedExceptionId = exception.id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppTheme.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? null : AppTheme.cardShadow,
        ),
        child: Row(
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
                  Text(exception.title, style: AppTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(exception.description, style: AppTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.chevron_right,
              color: isSelected ? color : AppTheme.lightText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsForException(ExceptionCase exception) {
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
              Icon(Icons.flash_on, color: AppTheme.primaryPurple),
              const SizedBox(width: 8),
              Text(
                'Soluções Recomendadas',
                style: AppTheme.labelLarge.copyWith(color: AppTheme.primaryPurple),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...exception.availableActions.map((action) => _buildActionButton(action)),
        ],
      ),
    );
  }

  Widget _buildActionButton(ExceptionAction action) {
    IconData icon;
    Color color;

    switch (action.actionType) {
      case 'call_regional':
        icon = Icons.phone;
        color = Colors.green;
        break;
      case 'magic_tools':
        icon = Icons.build;
        color = AppTheme.primaryPurple;
        break;
      case 'co_chat':
        icon = Icons.chat;
        color = Colors.blue;
        break;
      case 'manual':
        icon = Icons.edit;
        color = Colors.orange;
        break;
      default:
        icon = Icons.arrow_forward;
        color = AppTheme.lightText;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _handleAction(action),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
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
                    Text(action.label, style: AppTheme.labelLarge),
                    Text(action.description, style: AppTheme.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAction(ExceptionAction action) {
    switch (action.actionType) {
      case 'call_regional':
        _showCallDialog();
        break;
      case 'magic_tools':
        Navigator.pushNamed(context, '/magic-tools');
        break;
      case 'co_chat':
        Navigator.pushNamed(context, '/co-chat');
        break;
      case 'manual':
        _showManualActionDialog();
        break;
    }
  }

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.phone, color: Colors.green),
            SizedBox(width: 12),
            Text('Ligar para Regional'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.support_agent, size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  Text('Supervisor Regional', style: AppTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text('(11) 3456-7890', style: AppTheme.headingSmall),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Iniciando chamada...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.phone),
            label: const Text('Ligar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  void _showManualActionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.orange),
            SizedBox(width: 12),
            Text('Ação Manual'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Descreva a ação que será realizada manualmente:',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Descreva a ação...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exceção registrada com sucesso!'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    );
  }
}
