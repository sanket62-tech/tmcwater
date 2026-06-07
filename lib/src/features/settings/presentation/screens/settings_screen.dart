import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import 'package:water_collector/src/core/services/storage_service.dart';
import 'package:water_collector/src/features/auth/data/models/login_model.dart';
import 'package:water_collector/src/core/providers/locale_provider.dart';

import '../../../../../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = StorageService();
  LoginResponse? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await _storage.getUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: _buildAppBar(l10n),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  _buildProfileSection(l10n),
                  const SizedBox(height: 24),
                  _buildSettingItem(
                    icon: Icons.person_outline_rounded,
                    title: l10n.profileSettings,
                    subtitle: 'View your account information',
                    onTap: () => _showProfileDetailsDialog(context, l10n),
                  ),
                  _buildSettingItem(
                    icon: Icons.notifications_none_rounded,
                    title: l10n.notifications,
                    subtitle: 'Manage your alert preferences',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.security_rounded,
                    title: l10n.privacySecurity,
                    subtitle: 'Password and data protection',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.language_rounded,
                    title: l10n.language,
                    subtitle: Localizations.localeOf(context).languageCode == 'en' ? 'English' : 'मराठी',
                    onTap: () => _showLanguageDialog(context, l10n),
                  ),
                  const Divider(height: 32),
                  _buildSettingItem(
                    icon: Icons.help_outline_rounded,
                    title: l10n.helpSupport,
                    subtitle: 'FAQs and contact us',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.info_outline_rounded,
                    title: l10n.aboutApp,
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context, l10n),
                ],
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: const Color(0xFF0D47A1),
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('TMC',
                style: TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Jal Namuna',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5)),
              Text(l10n.settings,
                  style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  Widget _buildProfileSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: const Color(0xFF1565C0).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1565C0).withOpacity(0.2), width: 2),
            ),
            child: const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFF1565C0),
              child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData?.username ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.waterCollector,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1565C0).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF1565C0), size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: Color(0xFF37474F),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF90A4AE),
          fontSize: 13,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF90A4AE)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) {
        final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                trailing: localeProvider.locale.languageCode == 'en' ? const Icon(Icons.check, color: Color(0xFF1565C0)) : null,
                onTap: () {
                  localeProvider.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('मराठी'),
                trailing: localeProvider.locale.languageCode == 'mr' ? const Icon(Icons.check, color: Color(0xFF1565C0)) : null,
                onTap: () {
                  localeProvider.setLocale(const Locale('mr'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileDetailsDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF1565C0),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              const Icon(Icons.badge_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(l10n.profileDetails,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow(l10n.fullName, _userData?.fullName ?? 'N/A', Icons.person_outline),
            _buildDetailRow(l10n.email, _userData?.email ?? 'N/A', Icons.email_outlined),
            _buildDetailRow(l10n.username, _userData?.username ?? 'N/A', Icons.alternate_email),
            _buildDetailRow(l10n.role, _userData?.roleName ?? 'N/A', Icons.work_outline),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1565C0)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF90A4AE), fontWeight: FontWeight.w600)),
                Text(value,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF37474F), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: () async {
          await _storage.clearAll();
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.red, width: 1.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n.logout,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
