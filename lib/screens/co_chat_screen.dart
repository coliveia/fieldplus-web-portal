import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class COChatScreen extends StatefulWidget {
  const COChatScreen({super.key});

  @override
  State<COChatScreen> createState() => _COChatScreenState();
}

class _COChatScreenState extends State<COChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedCategory = 'internet';

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final messages = provider.coMessages;

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
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.support_agent, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Centro de Operações', style: AppTheme.headingSmall.copyWith(fontSize: 16)),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('Online', style: AppTheme.bodySmall.copyWith(color: AppTheme.success)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.phone, color: AppTheme.primaryPurple),
                onPressed: _showCallOptions,
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppTheme.darkText),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              // Category Selector
              _buildCategorySelector(),
              
              // Messages
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessagesList(messages),
              ),
              
              // Quick Actions
              _buildQuickActions(provider),
              
              // Input
              _buildMessageInput(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          _buildCategoryChip('internet', 'Internet', Icons.wifi),
          const SizedBox(width: 8),
          _buildCategoryChip('voice', 'Voz', Icons.phone),
          const SizedBox(width: 8),
          _buildCategoryChip('tv', 'TV', Icons.tv),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label, IconData icon) {
    final isSelected = _selectedCategory == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = id),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppTheme.lightText,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.lightText,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent,
              size: 60,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Centro de Operações',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Inicie uma conversa para obter suporte técnico em tempo real.',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.primaryPurple),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'I.Ajuda pode sugerir soluções antes de escalar para o CO',
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

  Widget _buildMessagesList(List<COMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isFromTechnician = message.senderType == 'technician';
        
        return _buildMessageBubble(message, isFromTechnician);
      },
    );
  }

  Widget _buildMessageBubble(COMessage message, bool isFromTechnician) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isFromTechnician ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromTechnician) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.support_agent, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isFromTechnician
                    ? AppTheme.primaryPurple
                    : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isFromTechnician ? 16 : 4),
                  bottomRight: Radius.circular(isFromTechnician ? 4 : 16),
                ),
                boxShadow: isFromTechnician ? null : AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isFromTechnician)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message.senderName,
                        style: AppTheme.labelSmall.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isFromTechnician ? Colors.white : AppTheme.darkText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isFromTechnician
                          ? Colors.white.withOpacity(0.7)
                          : AppTheme.lightText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isFromTechnician) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('👨‍🔧', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildQuickActionButton(
              'Preciso de manobra',
              Icons.swap_horiz,
              () => _sendQuickMessage(provider, 'Preciso de uma manobra de rede'),
            ),
            const SizedBox(width: 8),
            _buildQuickActionButton(
              'Verificar sinal',
              Icons.signal_cellular_alt,
              () => _sendQuickMessage(provider, 'Pode verificar o sinal do cliente?'),
            ),
            const SizedBox(width: 8),
            _buildQuickActionButton(
              'Problema de velocidade',
              Icons.speed,
              () => _sendQuickMessage(provider, 'Cliente com problema de velocidade'),
            ),
            const SizedBox(width: 8),
            _buildQuickActionButton(
              'Escalar para N2',
              Icons.arrow_upward,
              () => _sendQuickMessage(provider, 'Preciso escalar para suporte N2'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppTheme.primaryPurple),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: AppTheme.lightText),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Digite sua mensagem...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (text) => _sendMessage(provider),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () => _sendMessage(provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(AppProvider provider) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    provider.sendCOMessage(text);
    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendQuickMessage(AppProvider provider, String message) {
    provider.sendCOMessage(message);

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showCallOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ligar para Suporte', style: AppTheme.headingSmall),
            const SizedBox(height: 20),
            _buildCallOption(
              'CO - Internet',
              '(11) 3456-7890',
              Icons.wifi,
              Colors.blue,
            ),
            _buildCallOption(
              'CO - Voz',
              '(11) 3456-7891',
              Icons.phone,
              Colors.green,
            ),
            _buildCallOption(
              'CO - TV',
              '(11) 3456-7892',
              Icons.tv,
              Colors.orange,
            ),
            _buildCallOption(
              'Supervisor Regional',
              '(11) 3456-7893',
              Icons.person,
              AppTheme.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallOption(String title, String number, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: AppTheme.labelLarge),
      subtitle: Text(number, style: AppTheme.bodySmall),
      trailing: IconButton(
        icon: Icon(Icons.phone, color: color),
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ligando para $title...'),
              backgroundColor: color,
            ),
          );
        },
      ),
    );
  }
}
