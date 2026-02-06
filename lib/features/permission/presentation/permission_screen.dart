import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phone_storage_cleaner/features/dashboard/presentation/home_screen.dart';

class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.photos.status;
    if (status.isGranted) {
      _navigateToHome();
    }
  }

  Future<void> _requestPermission() async {
    setState(() => _isLoading = true);
    // Request 'photos' permission. On iOS 14+, this handles Limited vs Full automatically mostly,
    // but we might need 'photosAddOnly' or specific handling for full access.
    // Ideally we want full access for a cleaner app.
    final status = await Permission.photos.request();
    
    // For iOS 14+, we might want to check for limited.
    if (status.isGranted || status.isLimited) {
      _navigateToHome();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    setState(() => _isLoading = false);
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cleaning_services_rounded,
                  size: 100,
                  color: Color(0xFF6C63FF),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 32),
                Text(
                  'Clean Your Storage',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 16),
                Text(
                  'To find duplicates and clean up your storage, we need access to your photos.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 48),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _requestPermission,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Allow Access',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
