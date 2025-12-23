# D&D Character Manager

A Flutter application for managing character sheets for D&D and other tabletop RPG systems.

## Features

- Support for multiple RPG systems (D&D 5e, Pathfinder, Cyberpunk Red, etc.)
- Dynamic form generation based on system requirements
- Local storage of character sheets
- Extensible architecture for adding new RPG systems

## Architecture

The app follows a modular architecture with:

- `lib/core/` - Core functionality like database, utilities, and theme
- `lib/data/` - Data models and repositories
- `lib/features/` - Main app features
- `lib/forms/` - System-specific form implementations
- `lib/common/` - Shared widgets, services, and interfaces

## Adding New RPG Systems

To add support for a new RPG system:

1. Create a new directory under `lib/forms/` for the system
2. Define the form structure in the assets directory
3. Implement the specific form widget
4. Register the system in the form provider

## Getting Started

1. Make sure you have Flutter installed
2. Run `flutter pub get` to install dependencies
3. Run the app with `flutter run`