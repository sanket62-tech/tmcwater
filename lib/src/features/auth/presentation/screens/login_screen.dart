import 'package:flutter/material.dart';
import 'package:water_collector/src/core/routes/app_routes.dart';
import 'package:water_collector/src/core/services/storage_service.dart';
import 'package:water_collector/src/features/auth/data/services/auth_api_service.dart';
import 'package:water_collector/src/core/theme/app_theme.dart';
import 'package:water_collector/src/core/constants/asset_constants.dart';
import 'package:water_collector/src/core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authApi = AuthApiService();
  final _storage = StorageService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _authApi.login(
          _usernameController.text.trim(),
          _passwordController.text,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (response.success) {
            // Check for Role ID 6 (Water Collector)
            if (response.roleId == 6) {
              // Save token and user data securely
              await _storage.saveLoginResponse(response);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Welcome back, ${response.fullName ?? 'Collector'}!', 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppTheme.sectionColors[2],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );

              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Access Denied: You do not have the required permissions (${response.roleName ?? 'Unknown Role'}).'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 48),
                      _buildLoginForm(),
                      const Spacer(),
                      const SizedBox(height: 32),
                      _buildLoginButton(),
                      const SizedBox(height: 40),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF075195).withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Image.asset(
            AssetConstants.tmcLogo,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Water Testing',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Color(0xFF075195),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF075195).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Sample Collection Portal',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF075195),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Username'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Enter your username',
              prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF075195)),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF075195), width: 1.5),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 24),
          _buildFieldLabel('Password'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF075195)),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF075195), width: 1.5),
              ),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF333333),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF075195), Color(0xFF043B6E)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF075195).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              )
            : const Text(
                'SIGN IN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Text(
          'Thane Municipal Corporation',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '© ${DateTime.now().year} Developed by Alphonsol',
          style: TextStyle(
            color: Colors.grey.withValues(alpha: 0.7),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
