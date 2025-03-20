// ignore_for_file: avoid_print

import 'package:observer/week5/EXERCISE1/ride_pref.dart';
import 'package:observer/week5/EXERCISE1/ride_preferences_listener.dart';

class ConsoleLogger implements RidePreferencesListener {
  @override
  void onPreferenceSelected(RidePreference selectedPreference) {
    print(
        "On preference changed: Ride preference is now ${selectedPreference.name}");
  }
}
