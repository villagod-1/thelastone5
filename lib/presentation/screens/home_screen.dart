import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../business_logic/app_state.dart';
import '../widgets/tap_counter_widget.dart';
import '../widgets/motivational_message_widget.dart';
import '../widgets/confirmation_dialog.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final screens = [
      _buildHomeTab(appState),
      const ProgressScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('The Last One'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showResetDialog(context, appState),
            tooltip: 'Reiniciar contador',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progreso',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(AppState appState) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Contador
              const TapCounterWidget(),
              
              const SizedBox(height: 60),
              
              // Botón principal de registro
              _buildTapButton(appState),
              
              const SizedBox(height: 40),
              
              // Mensaje motivacional
              const MotivationalMessageWidget(),
              
              const SizedBox(height: 20),
              
              // Mostrar error si existe
              if (appState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    appState.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTapButton(AppState appState) {
    return GestureDetector(
      onTap: () => _handleTap(appState),
      child: Container(
        width: AppConstants.tapButtonSize,
        height: AppConstants.tapButtonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: appState.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Icon(
                Icons.touch_app,
                size: 48,
                color: Colors.white,
              ),
      ),
    );
  }

  void _handleTap(AppState appState) {
    // Implementar debouncing de 500ms
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 500) {
      return;
    }
    _lastTapTime = now;

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Registrar toque
    appState.registerTap();

    // Mostrar feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Toque registrado'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showResetDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: '¿Reiniciar contador?',
        message:
            'Esto establecerá el contador en cero y comenzará un nuevo ciclo. Los datos históricos se conservarán.',
        onConfirm: () {
          appState.resetCounter();
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contador reiniciado'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
