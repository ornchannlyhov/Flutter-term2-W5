import 'package:observer/week5/EXERCISE1/console_logger.dart';
import 'package:observer/week5/EXERCISE1/ride_preferences_service.dart';
import 'package:observer/week5/EXERCISE1/ride_pref.dart';

void main() {
  final service = RidePreferencesService();
  final logger = ConsoleLogger();

  // Register the logger to listen to changes
  service.addListener(logger);

  // Simulate changing preferences
  service.selectedPreference = RidePreference(name: "Economy"); 
  service.selectedPreference = RidePreference(name: "Premium"); 

  // Remove the listener and try changing the preference
  service.removeListener(logger);
  service.selectedPreference = RidePreference(name: "Electric"); 
}
