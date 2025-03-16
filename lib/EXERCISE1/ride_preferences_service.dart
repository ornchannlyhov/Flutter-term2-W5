import 'package:observer/EXERCISE1/ride_pref.dart';
import 'package:observer/EXERCISE1/ride_preferences_listener.dart';

class RidePreferencesService {
  final List<RidePreferencesListener> _listeners = [];
  RidePreference? _selectedPreference; // Store the current preference

  RidePreference? get selectedPreference => _selectedPreference;

  set selectedPreference(RidePreference? newPreference) {
    _selectedPreference = newPreference;
    notifyListeners(); // Important: Notify listeners on change
  }

  void addListener(RidePreferencesListener listener) {
    _listeners.add(listener);
  }

  void removeListener(RidePreferencesListener listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener
          .onPreferenceSelected(_selectedPreference!); // Notify each listener
    }
  }
}
