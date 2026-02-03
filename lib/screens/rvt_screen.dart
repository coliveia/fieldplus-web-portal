import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class RVTScreen extends StatefulWidget {
  const RVTScreen({super.key});

  @override
  State<RVTScreen> createState() => _RVTScreenState();
}

class _RVTScreenState extends State<RVTScreen> {
  final _formKey = GlobalKey<FormState>();
  final _observationsController = TextEditingController();
  String _selectedResult = 'success';
  bool _clientSigned = false;
  bool _showAIFill = true;
  List<String> _selectedEquipment = ['HGU ZTE F670L', 'Cabo Óptico 10m'];

  final List<String> _availableEquipment = [
    'HGU ZTE F670L',
    'HGU Huawei HG8245',
    'Cabo Óptico 5m',
    'Cabo Óptico 10m',
    'Cabo Óptico 20m',
    'Splitter 1x2',
    'Splitter 1x4',
    'Conector SC/APC',
    'Roseta Óptica',
    'Caixa de Emenda',
  ];

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
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
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.description, color: AppTheme.primaryPurple, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Relatório de Visita', style: AppTheme.headingSmall),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AI Auto-fill Banner
                  if (_showAIFill) _buildAIAutoFillBanner(),
                  const SizedBox(height: 16),

                  // Visit Summary
                  _buildVisitSummary(appointment),
                  const SizedBox(height: 24),

                  // Result Selection
                  _buildSectionTitle('Resultado do Atendimento'),
                  const SizedBox(height: 12),
                  _buildResultSelector(),
                  const SizedBox(height: 24),

                  // Equipment Used
                  _buildSectionTitle('Equipamentos Utilizados'),
                  const SizedBox(height: 12),
                  _buildEquipmentSelector(),
                  const SizedBox(height: 24),

                  // Observations
                  _buildSectionTitle('Observações'),
                  const SizedBox(height: 12),
                  _buildObservationsField(),
                  const SizedBox(height: 24),

                  // Photos
                  _buildSectionTitle('Fotos do Atendimento'),
                  const SizedBox(height: 12),
                  _buildPhotoGrid(),
                  const SizedBox(height: 24),

                  // Client Signature
                  _buildSectionTitle('Assinatura do Cliente'),
                  const SizedBox(height: 12),
                  _buildSignatureSection(),
                  const SizedBox(height: 24),

                  // Submit Button
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAIAutoFillBanner() {
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
                  'RVT Preenchido Automaticamente',
                  style: AppTheme.labelLarge.copyWith(color: AppTheme.primaryPurple),
                ),
                const SizedBox(height: 4),
                Text(
                  'I.Ajuda preencheu o relatório com base nas ações realizadas. Revise e ajuste se necessário.',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _showAIFill = false),
            icon: const Icon(Icons.close, size: 20),
            color: AppTheme.lightText,
          ),
        ],
      ),
    );
  }

  Widget _buildVisitSummary(dynamic appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildSummaryRow('Cliente', appointment?.customer.name ?? 'Ana Maria Santos'),
          const Divider(height: 24),
          _buildSummaryRow('Endereço', appointment?.customer.address ?? 'Rua das Flores, 123'),
          const Divider(height: 24),
          _buildSummaryRow('Tipo de Serviço', appointment?.type ?? 'Reparo'),
          const Divider(height: 24),
          _buildSummaryRow('Horário', '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'),
          const Divider(height: 24),
          _buildSummaryRow('Duração', '45 minutos'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.bodySmall),
        Text(value, style: AppTheme.labelLarge),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTheme.headingSmall.copyWith(fontSize: 16));
  }

  Widget _buildResultSelector() {
    return Row(
      children: [
        _buildResultOption('success', 'Sucesso', Icons.check_circle, AppTheme.success),
        const SizedBox(width: 12),
        _buildResultOption('partial', 'Parcial', Icons.warning, AppTheme.warning),
        const SizedBox(width: 12),
        _buildResultOption('failed', 'Insucesso', Icons.cancel, AppTheme.error),
      ],
    );
  }

  Widget _buildResultOption(String id, String label, IconData icon, Color color) {
    final isSelected = _selectedResult == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedResult = id),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppTheme.divider,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : AppTheme.lightText, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : AppTheme.lightText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentSelector() {
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
          // Selected Equipment
          if (_selectedEquipment.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedEquipment.map((eq) => _buildEquipmentChip(eq, true)).toList(),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
          ],
          
          // Add Equipment Button
          InkWell(
            onTap: _showEquipmentPicker,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.divider, style: BorderStyle.solid),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Text(
                    'Adicionar Equipamento',
                    style: AppTheme.labelLarge.copyWith(color: AppTheme.primaryPurple),
                  ),
                ],
              ),
            ),
          ),

          // AI Suggestion
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.primaryPurple, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Equipamentos detectados automaticamente via leitura de código',
                    style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryPurple),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentChip(String equipment, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            equipment,
            style: TextStyle(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              setState(() {
                _selectedEquipment.remove(equipment);
              });
            },
            child: Icon(
              Icons.close,
              size: 18,
              color: AppTheme.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationsField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: TextFormField(
        controller: _observationsController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Descreva as ações realizadas e observações importantes...',
          hintStyle: AppTheme.bodySmall,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
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
            children: [
              _buildPhotoThumbnail('CTO', Icons.router, true),
              const SizedBox(width: 12),
              _buildPhotoThumbnail('Instalação', Icons.cable, true),
              const SizedBox(width: 12),
              _buildPhotoThumbnail('Equipamento', Icons.devices, true),
              const SizedBox(width: 12),
              _buildAddPhotoButton(),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.success, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '3 fotos capturadas e validadas pela IA',
                    style: AppTheme.bodySmall.copyWith(color: AppTheme.success),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnail(String label, IconData icon, bool hasPhoto) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: hasPhoto ? AppTheme.primaryPurple.withOpacity(0.1) : AppTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasPhoto ? AppTheme.primaryPurple.withOpacity(0.3) : AppTheme.divider,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasPhoto ? Icons.check_circle : icon,
              color: hasPhoto ? AppTheme.success : AppTheme.lightText,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: hasPhoto ? AppTheme.primaryPurple : AppTheme.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return Expanded(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.divider, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, color: AppTheme.primaryPurple, size: 28),
              const SizedBox(height: 4),
              Text(
                'Adicionar',
                style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          if (!_clientSigned) ...[
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.draw, color: AppTheme.lightText, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Toque para coletar assinatura',
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => _clientSigned = true);
                },
                icon: const Icon(Icons.draw),
                label: const Text('Coletar Assinatura'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ] else ...[
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.success.withOpacity(0.3)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppTheme.success, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Assinatura coletada',
                      style: AppTheme.labelLarge.copyWith(color: AppTheme.success),
                    ),
                    Text(
                      'Ana Maria Santos',
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isValid = _clientSigned && _selectedEquipment.isNotEmpty;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isValid ? _submitRVT : null,
            icon: const Icon(Icons.send),
            label: const Text('Enviar Relatório'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              disabledBackgroundColor: AppTheme.divider,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (!isValid) ...[
          const SizedBox(height: 8),
          Text(
            'Colete a assinatura do cliente para enviar',
            style: AppTheme.bodySmall.copyWith(color: AppTheme.error),
          ),
        ],
      ],
    );
  }

  void _showEquipmentPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecionar Equipamento', style: AppTheme.headingSmall),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableEquipment.map((eq) {
                final isSelected = _selectedEquipment.contains(eq);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedEquipment.remove(eq);
                      } else {
                        _selectedEquipment.add(eq);
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryPurple.withOpacity(0.1)
                          : AppTheme.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryPurple : AppTheme.divider,
                      ),
                    ),
                    child: Text(
                      eq,
                      style: TextStyle(
                        color: isSelected ? AppTheme.primaryPurple : AppTheme.darkText,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRVT() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success),
            SizedBox(width: 12),
            Text('RVT Enviado!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description, size: 60, color: AppTheme.success),
            const SizedBox(height: 16),
            Text(
              'Relatório de Visita Técnica enviado com sucesso!',
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
                    '+20 pontos',
                    style: AppTheme.labelLarge.copyWith(color: AppTheme.primaryPurple),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}
