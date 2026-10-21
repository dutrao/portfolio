import 'dart:async';

import 'package:flutter_application_1/storage/storage.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  final Storage storage;
  GeolocatorService({required this.storage});

  StreamSubscription<Position>? streamPositionSubscription;

  Future<({double lat,double long})> pegarLocalizacaoAtual()async{
   final position = await Geolocator.getCurrentPosition();
   return (lat: position.latitude,long: position.longitude);
  }
  void iniciar(String idUsuario) {
    final locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationTitle: 'Localização sendo compartilhada',
        notificationText:
            'Sua localização está sendo compartilhada em tempo real.',
        enableWakeLock: true,
      ),
    );

    streamPositionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((
      posicao,
    ) {
      storage.adicionarOuAtualizarPosicaoUsuario(
        idUsuario,
        posicao.latitude,
        posicao.longitude,
      );
      print("$idUsuario - $posicao.lat - $posicao.long");
    });
  }

  void finalizar() {
    streamPositionSubscription?.cancel();
  }
}
