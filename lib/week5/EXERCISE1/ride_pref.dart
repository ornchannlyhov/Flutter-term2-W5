class RidePreference {
  final String name;
  final String? description;
  RidePreference({required this.name, this.description});
}

List<RidePreference> dummyRidePreferences = [
  RidePreference(name: "Economy", description: "The most affordable option."),
  RidePreference(
      name: "Premium", description: "More luxurious and comfortable."),
  RidePreference(
      name: "Electric", description: "Eco-friendly, all-electric vehicles."),
  RidePreference(
      name: "SUV", description: "Spacious and suitable for groups or luggage."),
  RidePreference(name: "Bike", description: "Just the biker"),
];
