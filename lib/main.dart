import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'data/models/tap_record.dart';
import 'data/models/cycle.dart';
import 'data/repositories/tap_repository.dart';
import 'business_logic/services/tap_counter_service.dart';
import 'business_logic/services/progress_service.dart';
import 'business_logic/services/motivational_message_service.dart';
import 'business_logic/app_state.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(TapRecordAdapter());
  Hive.registerAdapter(CycleAdapter());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final tapRepository = TapRepositoryImpl();
    final tapCounterService = TapCounterService(tapRepository);
    final progressService = ProgressService(tapRepository);
    final messageService = MotivationalMessageService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(
            tapCounterService: tapCounterService,
            progressService: progressService,
            messageService: messageService,
          ),
        ),
        Provider.value(value: progressService),
      ],
      child: MaterialApp(
        title: 'The Last One',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
