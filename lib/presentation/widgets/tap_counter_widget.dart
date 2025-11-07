import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../business_logic/app_state.dart';
import '../theme/app_text_styles.dart';

class TapCounterWidget extends StatelessWidget {
  const TapCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${appState.currentCount}',
              style: AppTextStyles.counterDisplay,
            ),
            const SizedBox(height: 8),
            const Text(
              'toques registrados',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
