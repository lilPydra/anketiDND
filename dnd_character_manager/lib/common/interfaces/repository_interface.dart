// lib/common/interfaces/repository_interface.dart
import 'form_provider.dart';
import 'character_repository.dart';

/// Combined interface for all repository operations
abstract class RepositoryInterface implements FormProvider, CharacterRepository {}