import '../models/location_model.dart';

class LocationService {
  Future<LocationModel> getCurrentApproxLocation() async {
	// Fallback to Gwalior center until geolocator integration is enabled.
	return const LocationModel(
	  id: 'CURRENT',
	  name: 'Current Location',
	  lat: 26.2124,
	  lng: 78.1772,
	  city: 'Gwalior',
	);
  }
}

