import '../domain/enhancement.dart';
import '../domain/game.dart';
import '../domain/game_item.dart';
import '../domain/office.dart';

abstract class NavigationState {}

class OpenEnhancementsState extends NavigationState {}

class OpenGamesState extends NavigationState {}

class OpenCompanyState extends NavigationState {}

class OpenSettingsState extends NavigationState {}

class ClosedDialogsState extends NavigationState {}
