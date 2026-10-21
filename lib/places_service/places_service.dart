import 'package:flutter_places_sdk/flutter_places_sdk.dart';

class PlacesService {
  final FlutterPlacesSdk places;

  PlacesService({
    required String apiKey,
  }) : places = FlutterPlacesSdk(apiKey);

  Future<List<AutocompletePrediction>> pesquisar(
    String texto,
  ) async {
    if (texto.trim().isEmpty) {
      return [];
    }

    return await places.findAutocompletePredictions(
      texto,
      countries: ['BR'],
    );
  }

  Future<Place?> buscarLocal(
    String placeId,
  ) async {
    return await places.fetchPlace(
      placeId,
      fields: const [
        PlaceField.id,
        PlaceField.name,
        PlaceField.address,
        PlaceField.location,
      ],
    );
  }
}