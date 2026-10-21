import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/gps_screen/gps_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AcessoMapsWidget extends StatefulWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final String textoBotao;
  final IconData iconeBotao;
 

  const AcessoMapsWidget({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
    required this.textoBotao,
    required this.iconeBotao,
    
  });

  @override
  State<AcessoMapsWidget> createState() =>
      _AcessoMapsWidgetState();
}

class _AcessoMapsWidgetState
    extends State<AcessoMapsWidget> {

  static const Color vermelhoPrincipal = Color(0xFFAA1015);

  bool pegandoLocationPermission = true;

  late LocationPermission statusPermissaoLocalizacao;

  @override
  void initState() {
    super.initState();
    verificarPermissao();
  }

  Future<void> verificarPermissao() async {
    statusPermissaoLocalizacao =
        await Geolocator.checkPermission();

    if (!mounted) return;

    setState(() {
      pegandoLocationPermission = false;
    });

    print(statusPermissaoLocalizacao);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9E9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  widget.icone,
                  size: 38,
                  color: vermelhoPrincipal,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titulo,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF171717),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.descricao,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.4,
                        color: Color(0xFF5F6068),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          pegandoLocationPermission == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                        PermissionStatus statusPermition = await Permission
                            .location
                            .request();

                        if (statusPermition.isGranted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GpsScreen(),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    icon: Icon(
                      widget.iconeBotao,
                      size: 25,
                    ),
                    label: Text(
                      'Visualizar Mapa',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vermelhoPrincipal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}