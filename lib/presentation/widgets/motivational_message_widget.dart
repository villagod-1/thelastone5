import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business_logic/app_state.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class MotivationalMessageWidget extends StatefulWidget {
  const MotivationalMessageWidget({super.key});

  @override
  State<MotivationalMessageWidget> createState() =>
      _MotivationalMessageWidgetState();
}

class _MotivationalMessageWidgetState
    extends State<MotivationalMessageWidget> {
  String _previousMessage = '';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentMessage = appState.currentMessage;

    // Detectar cambio de mensaje para animación
    if (currentMessage != _previousMessage) {
      _previousMessage = currentMessage;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey<String>(currentMessage),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingLarge,
          vertical: AppConstants.paddingMedium,
        ),
        child: Text(
          currentMessage.isEmpty ? 'Cargando...' : currentMessage,
          style: AppTextStyles.motivationalMessage,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
