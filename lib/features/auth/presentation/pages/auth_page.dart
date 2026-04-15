import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../../core/auth/auth_provider.dart';
import '../../../../core/network/api_client.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'Admin';
  bool _showPassword = false;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  // Forgot Password States
  bool _showForgot = false;
  int _forgotStep = 1; // 1: Email, 2: OTP, 3: Reset
  final _forgotEmailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _resetToken = "";
  bool _forgotLoading = false;
  int _countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Pre-fill Admin credentials by default
    _emailController.text = 'branding@gmail.com';
    _passwordController.text = 'branding';
  }

  void _startTimer() {
    _timer?.cancel();
    _countdown = 300; // 5 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _forgotEmailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool isValid = true;
    setState(() {
      _emailError = null;
      _passwordError = null;

      if (_emailController.text.isEmpty) {
        _emailError = _role == 'Customer' ? "Account ID is required." : "Email is required.";
        isValid = false;
      } else if (_role != 'Customer') {
        final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
        if (!emailRegex.hasMatch(_emailController.text)) {
          _emailError = "Enter a valid email address.";
          isValid = false;
        }
      }

      if (_passwordController.text.isEmpty) {
        _passwordError = "Password is required.";
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = "Password must be at least 6 characters.";
        isValid = false;
      }
    });
    return isValid;
  }

  Future<void> _handleSubmit() async {
    if (!_validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(_role, _emailController.text.trim(), _passwordController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully'), backgroundColor: Colors.green),
        );
        context.go('/'); // Navigate to dashboard
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? "Login failed. Try again.";
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSendOTP() async {
    if (_forgotEmailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your registered email.'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _forgotLoading = true);
    try {
      final res = await apiClient.dio.post('/auth/forgot-password', data: {'email': _forgotEmailController.text.trim()});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.data['message']), backgroundColor: Colors.green));
        setState(() {
          _forgotStep = 2;
          _startTimer();
        });
      }
    } on DioException catch (err) {
      final msg = err.response?.data?['message'] ?? "Failed to send OTP.";
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _forgotLoading = false);
    }
  }

  Future<void> _handleVerifyOTP() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the OTP.'), backgroundColor: Colors.red));
      return;
    }
    setState(() => _forgotLoading = true);
    try {
      final res = await apiClient.dio.post('/auth/verify-otp', data: {
        'email': _forgotEmailController.text.trim(),
        'otp': _otpController.text.trim()
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.data['message']), backgroundColor: Colors.green));
        setState(() {
          _resetToken = res.data['resetToken'];
          _forgotStep = 3;
        });
      }
    } on DioException catch (err) {
      final msg = err.response?.data?['message'] ?? "Invalid OTP.";
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _forgotLoading = false);
    }
  }

  Future<void> _handleResetPassword() async {
    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters.'), backgroundColor: Colors.red));
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match.'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _forgotLoading = true);
    try {
      final res = await apiClient.dio.post('/auth/reset-password', data: {
        'resetToken': _resetToken,
        'newPassword': _newPasswordController.text
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.data['message']), backgroundColor: Colors.green));
        _closeForgotModal();
      }
    } on DioException catch (err) {
      final msg = err.response?.data?['message'] ?? "Failed to reset password.";
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _forgotLoading = false);
    }
  }

  void _closeForgotModal() {
    _timer?.cancel();
    setState(() {
      _showForgot = false;
      _forgotStep = 1;
      _forgotEmailController.clear();
      _otpController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _resetToken = "";
      _countdown = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showForgot) {
      return _buildForgotModal();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // slate-50 to blue-50 blend base
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 448, // max-w-md
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF), // blue-50 approx
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    border: Border(bottom: BorderSide(color: const Color(0xFFE2E8F0))),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(LucideIcons.logIn, color: Color(0xFFB56965), size: 28), // reddish
                          SizedBox(width: 12),
                          Text(
                            "Sign in to your account",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)), // slate-800
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Welcome back.",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF475569)), // slate-600
                      ),
                    ],
                  ),
                ),
                
                // Form
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Role
                      const Text("Role", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFCBD5E1)), // slate-300
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _role,
                            isExpanded: true,
                            items: ['Admin', 'Manager', 'Employee', 'Super Admin', 'Customer']
                                .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _role = val;
                                  _emailError = null;
                                  _passwordError = null;
                                  
                                  // Auto-fill credentials based on role
                                  if (_role == 'Admin') {
                                    _emailController.text = 'branding@gmail.com';
                                    _passwordController.text = 'branding';
                                  } else if (_role == 'Customer') {
                                    _emailController.text = '1001';
                                    _passwordController.text = 'abhi';
                                  } else {
                                    _emailController.clear();
                                    _passwordController.clear();
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Email
                      Text(_role == 'Customer' ? "Account ID" : "Email", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(_role == 'Customer' ? LucideIcons.user : LucideIcons.mail, color: const Color(0xFF94A3B8), size: 20),
                          hintText: _role == 'Customer' ? "Enter account ID" : "you@company.com",
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _emailError != null ? Colors.red.shade400 : const Color(0xFFCBD5E1))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _emailError != null ? Colors.red.shade400 : const Color(0xFFCBD5E1))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _emailError != null ? Colors.red.shade400 : const Color(0xFFF5D0CE), width: 2)), // light red
                        ),
                      ),
                      if (_emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(_emailError!, style: TextStyle(color: Colors.red.shade600, fontSize: 14)),
                        ),
                      
                      const SizedBox(height: 16),
                      
                      // Password
                      const Text("Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.lock, color: Color(0xFF94A3B8), size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword ? LucideIcons.eyeOff : LucideIcons.eye, color: const Color(0xFF475569), size: 20),
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                          ),
                          hintText: "Enter your password",
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _passwordError != null ? Colors.red.shade400 : const Color(0xFFCBD5E1))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _passwordError != null ? Colors.red.shade400 : const Color(0xFFCBD5E1))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _passwordError != null ? Colors.red.shade400 : const Color(0xFFF5D0CE), width: 2)),
                        ),
                      ),
                      if (_passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(_passwordError!, style: TextStyle(color: Colors.red.shade600, fontSize: 14)),
                        ),
                      
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(() => _showForgot = true),
                          child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFFB56965), fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                      ),
                      
                      const SizedBox(height: 16),

                      // Submit
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB56965), // reddish
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 1,
                          ),
                          child: _isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(LucideIcons.logIn, size: 18),
                                    const SizedBox(width: 8),
                                    const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                
                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                  ),
                  child: const Text(
                    "By signing in you agree to the company policies.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF475569), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Forgot Password Modal UI
  Widget _buildForgotModal() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.6),
      body: Center(
        child: Container(
          width: 448,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(LucideIcons.keyRound, color: Color(0xFFB56965), size: 20),
                        SizedBox(width: 8),
                        Text("Forgot Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Color(0xFF94A3B8), size: 20),
                      onPressed: _closeForgotModal,
                      splashRadius: 20,
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Step Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [1, 2, 3].map((step) {
                        return Row(
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _forgotStep >= step ? const Color(0xFFB56965) : const Color(0xFFF1F5F9), // reddish : slate-100
                              ),
                              alignment: Alignment.center,
                              child: Text("$step", style: TextStyle(fontWeight: FontWeight.bold, color: _forgotStep >= step ? Colors.white : const Color(0xFF94A3B8))),
                            ),
                            if (step < 3)
                              Container(
                                width: 32, height: 2,
                                color: _forgotStep > step ? const Color(0xFFB56965) : const Color(0xFFF1F5F9),
                              )
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    if (_forgotStep == 1) ...[
                      const Text("Enter your registered email address to receive a verification OTP.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF475569))),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _forgotEmailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.mail, color: Color(0xFF94A3B8), size: 20),
                          hintText: "you@company.com",
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _forgotLoading ? null : _handleSendOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB56965), foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: _forgotLoading ? const SizedBox() : const Icon(LucideIcons.arrowRight, size: 20),
                          label: _forgotLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Send OTP", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],

                    if (_forgotStep == 2) ...[
                      Text("We've sent a 6-digit code to ${_forgotEmailController.text}", textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF475569))),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _otpController,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 8),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          counterText: "",
                          prefixIcon: const Icon(LucideIcons.shieldCheck, color: Color(0xFF94A3B8), size: 20),
                          hintText: "000000",
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _countdown > 0 ? "Expires in ${_formatTime(_countdown)}" : "OTP Expired",
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                          ),
                          TextButton(
                            onPressed: _countdown > 240 ? null : _handleSendOTP, // Resend blocked for 1 min
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(
                                color: _countdown > 240 ? const Color(0xFF94A3B8) : const Color(0xFFB56965),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity, height: 48,
                        child: ElevatedButton(
                          onPressed: _forgotLoading ? null : _handleVerifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB56965), foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _forgotLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Verify OTP", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],

                    if (_forgotStep == 3) ...[
                      const Text("OTP Verified! Set your new password below.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.w500)),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.lock, color: Color(0xFF94A3B8), size: 20),
                          hintText: "New Password",
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.lock, color: Color(0xFF94A3B8), size: 20),
                          hintText: "Confirm New Password",
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, height: 48,
                        child: ElevatedButton(
                          onPressed: _forgotLoading ? null : _handleResetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669), // emerald-600
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _forgotLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Set Password", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    ]
                  ],
                ),
              ),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: TextButton(
                  onPressed: _closeForgotModal,
                  child: const Text("Back to Login", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500)), // slate-500
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
