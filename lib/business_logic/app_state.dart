import 'package:flutter/foundation.dart';
import '../data/models/cycle.dart';
import '../data/repositories/tap_repository.dart';
import 'services/tap_counter_service.dart';
import 'services/progress_service.dart';
import 'services/motivational_message_service.dart';

class AppState extends ChangeNotifier {
  final TapCounterService _tapCounterService;
  final ProgressService _progressService;
  final MotivationalMessageService _messageService;

  int _currentCount = 0;
  Cycle? _currentCycle;
  String _currentMessage = '';
  bool _isLoading = false;
  String? _errorMessage;

  AppState({
    required TapCounterService tapCounterService,
    required ProgressService progressService,
    required MotivationalMessageService messageService,
  })  : _tapCounterService = tapCounterService,
        _progressService = progressService,
        _messageService = messageService {
    _initialize();
  }

  // Getters
  int get currentCount => _currentCount;
  Cycle? get currentCycle => _currentCycle;
  String get currentMessage => _currentMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Cargar contador actual
      _currentCount = await _tapCounterService.getCurrentCount();

      // Iniciar servicio de mensajes
      await _messageService.startRotation();
      _currentMessage = _messageService.getCurrentMessage();

      // Escuchar cambios en el contador
      _tapCounterService.watchCounter().listen((count) {
        _currentCount = count;
        notifyListeners();
      });

      // Escuchar cambios en mensajes
      _messageService.watchMessages().listen((message) {
        _currentMessage = message;
        notifyListeners();
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al inicializar la aplicación';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerTap() async {
    try {
      _errorMessage = null;
      await _tapCounterService.registerTap();
    } catch (e) {
      _errorMessage = 'No se pudo guardar el registro. Intenta nuevamente.';
      notifyListeners();
    }
  }

  Future<void> resetCounter() async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      await _tapCounterService.resetCounter();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'No se pudo reiniciar el contador.';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _tapCounterService.dispose();
    _messageService.dispose();
    super.dispose();
  }
}
