import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phone_storage_cleaner/features/gallery/data/photo_provider.dart';
import 'package:phone_storage_cleaner/features/gallery/presentation/all_photos_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isImported = false;

  @override
  void initState() {
    super.initState();
    // Simulate "Importing" delay for better UX (perception of work)
    // In reality, we are just fetching the count index which is fast.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isImported = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalAssetsAsync = ref.watch(totalAssetsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Storage Cleaner',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              if (!_isImported)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFF6C63FF),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Importing Photos...',
                          style: Theme.of(context).textTheme.titleLarge,
                        ).animate().fadeIn(),
                        const SizedBox(height: 8),
                        Text(
                          'Analyzing storage usage',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      // Stats Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF00C6FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Items Scanned',
                              style:
                                  Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white70,
                                      ),
                            ),
                            const SizedBox(height: 8),
                            totalAssetsAsync.when(
                              data: (count) => Text(
                                count.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ).animate().scale(
                                    duration: 600.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                              loading: () => const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              error: (err, stack) => Text(
                                'Error',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Ready to optimize',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                      
                      const SizedBox(height: 32),
                      
                      // Action Grid
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                          children: [
                            _buildActionCard(
                              context,
                              'All Photos',
                              Icons.photo_library,
                              Colors.orange,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AllPhotosScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildActionCard(
                              context,
                              'Duplicates',
                              Icons.copy_all,
                              Colors.red,
                              () {
                                // TODO: Implement Duplicates
                              },
                              isComingSoon: true,
                            ),
                            _buildActionCard(
                              context,
                              'Large Videos',
                              Icons.videocam,
                              Colors.purple,
                              () {},
                              isComingSoon: true,
                            ),
                            _buildActionCard(
                              context,
                              'Screenshots',
                              Icons.screenshot,
                              Colors.blue,
                              () {},
                              isComingSoon: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isComingSoon = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (isComingSoon) ...[
              const SizedBox(height: 4),
              Text(
                'Coming Soon',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
              ),
            ]
          ],
        ),
      ),
    ).animate().fadeIn().scale(delay: 200.ms);
  }
}
