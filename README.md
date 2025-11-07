# The Last One

Una aplicación móvil desarrollada con Flutter para ayudar a las personas a reducir y eliminar el hábito del vapeo mediante un sistema de registro, análisis y motivación progresiva.

## Características

- 🧮 Contador de toques con registro manual
- 📊 Gráfica de progreso con tendencias
- 💬 Mensajes motivacionales rotativos
- 💾 Persistencia de datos local
- 🎨 Diseño minimalista y enfocado

## Requisitos

- Flutter 3.0 o superior
- Dart 3.0 o superior

## Instalación

1. Clona el repositorio
2. Ejecuta `flutter pub get`
3. Ejecuta `flutter run`

## Estructura del Proyecto

```
lib/
├── data/              # Capa de datos
│   ├── models/        # Modelos de datos
│   ├── repositories/  # Repositorios
│   └── datasources/   # Fuentes de datos
├── business_logic/    # Lógica de negocio
│   └── services/      # Servicios
├── presentation/      # Capa de presentación
│   ├── screens/       # Pantallas
│   ├── widgets/       # Widgets reutilizables
│   └── theme/         # Tema y estilos
└── main.dart          # Punto de entrada
```
