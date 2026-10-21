import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/geolocator_service/geolocator_service.dart';
import 'package:flutter_application_1/places_service/places_service.dart';
import 'package:flutter_application_1/storage/storage.dart';
import 'package:flutter_places_sdk/flutter_places_sdk.dart' hide LatLng;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GpsScreen extends StatefulWidget {
  const GpsScreen({super.key});

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  StreamSubscription? posicaoDeUsuariosSubscription;

  final Set<Marker> setMarkers = {};

  late BitmapDescriptor iconeMilitar;

  GoogleMapController? mapController;

  final TextEditingController pesquisaController = TextEditingController();

  List<AutocompletePrediction> sugestoes = [];

  bool pesquisando = false;

  // Localização usada para iniciar a câmera do mapa.
  LatLng? localizacaoInicial;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await carregarDadosIniciais();
    });
  }

  Future<void> carregarDadosIniciais() async {
    // 1. Busca a localização atual do usuário.
    try {
      final location = await context
          .read<GeolocatorService>()
          .pegarLocalizacaoAtual();

      if (!mounted) return;

      setState(() {
        localizacaoInicial = LatLng(
          location.lat,
          location.long,
        );
      });
    } catch (e) {
      debugPrint('Erro ao buscar localização atual: $e');

      if (!mounted) return;

      // Localização padrão caso não seja possível obter o GPS.
      setState(() {
        localizacaoInicial = const LatLng(-15.0, -44.0);
      });
    }

    // 2. Carrega o ícone dos militares.
    await carregarIconeMilitar();

    if (!mounted) return;

    // 3. Inicia o acompanhamento das posições dos militares.
    posicaoDeUsuariosSubscription = context
        .read<Storage>()
        .buscarPosicaoDeUsuarios()
        .listen((listaMarkers) async {
          if (!mounted) return;

          final novosMarkers = <Marker>{};

          for (final marker in listaMarkers) {
            final militar = await context
                .read<Storage>()
                .buscarMilitarPorIdNoDrift(marker.id);

            novosMarkers.add(
              Marker(
                infoWindow: InfoWindow(
                  title: '${militar?.cargo} ${militar?.nomeDeGuerra}',
                  snippet: 'Lat: ${marker.lat} / Long: ${marker.long}',
                ),
                icon: iconeMilitar,
                markerId: MarkerId(marker.id),
                position: LatLng(
                  marker.lat,
                  marker.long,
                ),
              ),
            );
          }

          if (!mounted) return;

          setState(() {
            setMarkers
              ..clear()
              ..addAll(novosMarkers);
          });
        });
  }

  @override
  void dispose() {
    posicaoDeUsuariosSubscription?.cancel();
    pesquisaController.dispose();
    mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Enquanto ainda estamos obtendo a localização inicial,
    // o mapa não é criado.
    if (localizacaoInicial == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,

              // Desativa o botão padrão porque estamos
              // utilizando nosso próprio botão.
              myLocationButtonEnabled: false,

              initialCameraPosition: CameraPosition(
                target: localizacaoInicial!,
                zoom: 16,
              ),

              markers: setMarkers,

              onMapCreated: (controller) {
                mapController = controller;
              },

              onTap: (_) {
                FocusScope.of(context).unfocus();

                setState(() {
                  sugestoes = [];
                });
              },
            ),

            // CAMPO DE PESQUISA
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Column(
                children: [
                  TextField(
                    controller: pesquisaController,
                    onChanged: pesquisarLocal,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar local...',
                      prefixIcon: const Icon(Icons.search),

                      suffixIcon: pesquisando
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : pesquisaController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: limparPesquisa,
                                )
                              : null,

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  // SUGESTÕES DA PESQUISA
                  if (sugestoes.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: sugestoes.length,
                        separatorBuilder: (context, index) {
                          return const Divider(height: 1);
                        },
                        itemBuilder: (context, index) {
                          final local = sugestoes[index];

                          return ListTile(
                            leading: const Icon(
                              Icons.location_on,
                            ),
                            title: Text(
                              local.primaryText,
                            ),
                            subtitle: local.secondaryText.isNotEmpty
                                ? Text(
                                    local.secondaryText,
                                  )
                                : null,
                            onTap: () {
                              selecionarLocal(local);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // BOTÃO PARA VOLTAR À LOCALIZAÇÃO DO USUÁRIO
            Positioned(
              right: 6,
              bottom: 100,
              child: FloatingActionButton(
                backgroundColor: Colors.white60,
                mini: true,
                onPressed: centralizarNaMinhaLocalizacao,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> centralizarNaMinhaLocalizacao() async {
    try {
      final location = await context
          .read<GeolocatorService>()
          .pegarLocalizacaoAtual();

      if (!mounted) return;

      final controller = mapController;

      if (controller == null) return;

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              location.lat,
              location.long,
            ),
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Erro ao centralizar localização: $e');
    }
  }

  Future<void> pesquisarLocal(String texto) async {
    if (texto.trim().length < 3) {
      setState(() {
        sugestoes = [];
        pesquisando = false;
      });

      return;
    }

    setState(() {
      pesquisando = true;
    });

    try {
      final resultado = await context
          .read<PlacesService>()
          .pesquisar(texto);

      if (!mounted) return;

      setState(() {
        sugestoes = resultado;
        pesquisando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        sugestoes = [];
        pesquisando = false;
      });

      debugPrint('Erro ao pesquisar local: $e');
    }
  }

  Future<void> selecionarLocal(
    AutocompletePrediction local,
  ) async {
    FocusScope.of(context).unfocus();

    try {
      final lugar = await context
          .read<PlacesService>()
          .buscarLocal(local.placeId);

      if (lugar == null) {
        return;
      }

      final coordenadas = lugar.latLng;

      if (coordenadas == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        pesquisaController.text = local.primaryText;
        sugestoes = [];
      });

      final controller = mapController;

      if (controller == null) return;

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              coordenadas.lat,
              coordenadas.lng,
            ),
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Erro ao selecionar local: $e');
    }
  }

  void limparPesquisa() {
    pesquisaController.clear();

    FocusScope.of(context).unfocus();

    setState(() {
      sugestoes = [];
      pesquisando = false;
    });
  }

  Future<void> carregarIconeMilitar() async {
    iconeMilitar = await BitmapDescriptor.asset(
      const ImageConfiguration(
        size: Size(48, 48),
      ),
      'assets/militar_marker.png',
    );
  }
}