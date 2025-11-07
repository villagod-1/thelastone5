import 'dart:async';
import 'package:hive/hive.dart';

class MotivationalMessageService {
  static const List<String> _messages = [
    "Cada toque menos es una victoria.",
    "Respira profundo. Eres más fuerte que el hábito.",
    "Tu cuerpo te agradecerá cada día sin vape.",
    "El cambio comienza con la conciencia.",
    "Hoy es un buen día para reducir.",
    "Tu salud vale más que cualquier hábito.",
    "Cada decisión cuenta. Tú tienes el control.",
    "Pequeños pasos, grandes cambios.",
    "Eres capaz de más de lo que imaginas.",
    "La libertad está en tus manos.",
    "Cada día sin vape es un logro.",
    "Tu futuro yo te lo agradecerá.",
  ];

  static const String _settingsBoxName = 'settings_box';
  static const String _lastMessageIndexKey = 'last_message_index';
  static const Duration _rotationInterval = Duration(seconds: 10);

  final _messageController = StreamController<String>.broadcast();
  Timer? _rotationTimer;
  int _currentIndex = 0;

  Stream<String> watchMessages() => _messageController.stream;

  String getCurrentMessage() {
    return _messages[_currentIndex];
  }

  Future<void> startRotation() async {
    // Cargar último índice guardado
    await _loadLastIndex();
    
    // Emitir mensaje inicial
    _messageController.add(_messages[_currentIndex]);

    // Iniciar rotación automática
    _rotationTimer = Timer.periodic(_rotationInterval, (_) {
      _rotateMessage();
    });
  }

  void stopRotation() {
    _rotationTimer?.cancel();
    _rotationTimer = null;
  }

  Future<void> _rotateMessage() async {
    _currentIndex = (_currentIndex + 1) % _messages.length;
    _messageController.add(_messages[_currentIndex]);
    
    // Persistir índice actual
    await _saveLastIndex();
  }

  Future<void> _loadLastIndex() async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      final savedIndex = box.get(_lastMessageIndexKey) as int?;
      if (savedIndex != null && savedIndex < _messages.length) {
        _currentIndex = savedIndex;
      }
    } catch (e) {
      // Si hay error, usar índice 0
      _currentIndex = 0;
    }
  }

  Future<void> _saveLastIndex() async {
    try {
      final box = await Hive.openBox(_settingsBoxName);
      await box.put(_lastMessageIndexKey, _currentIndex);
    } catch (e) {
      // Ignorar errores de guardado
    }
  }

  void dispose() {
    stopRotation();
    _messageController.close();
  }
}
