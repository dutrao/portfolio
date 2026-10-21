import 'package:flutter/material.dart';
import 'package:flutter_application_1/geolocator_service/geolocator_service.dart';
import 'package:flutter_application_1/screen/gps_screen/gps_screen.dart';
import 'package:flutter_application_1/screen/permissao_screen/acesso_maps_widget.dart';
import 'package:flutter_application_1/screen/permissao_screen/compartilhar_localizacao_widget.dart';
import 'package:flutter_application_1/storage/storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PermissaoScreen extends StatefulWidget {
  const PermissaoScreen({super.key});

  @override
  State<PermissaoScreen> createState() => _PermissaoScreenState();
}

class _PermissaoScreenState extends State<PermissaoScreen> {
  // Cor principal próxima à utilizada na Home.
  static const Color vermelhoPrincipal = Color(0xFFAA1015);
  static const Color fundoTela = Color(0xFFF7F7F7);

  bool pegandoLocationPermission = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final statusPermissaoLocalizacao = await Geolocator.checkPermission();
      if (!mounted) return;
      setState(() {
        pegandoLocationPermission = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoTela,
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // CABEÇALHO
            // ============================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 15, 24, 15),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFB20D12), Color(0xFFD42B21)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 35,
                    color: Colors.white,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Localização GPS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Acompanhe o efetivo em tempo real e contribua '
                    'para uma resposta mais rápida.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // ============================================================
            // CONTEÚDO
            // ============================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  children: [
                    // ====================================================
                    // CARD ACESSAR MAPA
                    // ====================================================
                    AcessoMapsWidget(
                      icone: Icons.map_outlined,
                      titulo: 'Acessar o mapa',
                      descricao:
                          'Para utilizar o mapa e visualizar a localização '
                          'do efetivo, é necessário permitir que o aplicativo '
                          'acesse os recursos de localização do seu telefone.',
                      textoBotao: 'Acessar mapa',
                      iconeBotao: Icons.location_on_rounded,

                      // LÓGICA ORIGINAL
                      
                    ),

                    const SizedBox(height: 20),

                    // ====================================================
                    // CARD COMPARTILHAR LOCALIZAÇÃO
                    // ====================================================
                    CompartilharLocalizacaoWidget(
                      icone: Icons.groups_rounded,
                      titulo: 'Compartilhar localização',
                      descricao:
                          'Permita que outras pessoas acompanhem sua '
                          'localização em tempo real, contribuindo para '
                          'uma melhor coordenação da equipe.',
                      textoBotao: 'Compartilhar localização',
                      iconeBotao: Icons.people_alt_rounded,                   
                      
                    ),
                    const SizedBox(height: 20),  
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } 

 
}
