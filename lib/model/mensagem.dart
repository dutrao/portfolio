import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagem {
  final String idMensagem;
  final String idRemetente;
  final String idConversa;
  final String conteudo;
  final bool statusEnvio;
  final DateTime horarioEnvio;
  final bool sincronizado;

  Mensagem({
    required this.idMensagem,
    required this.idRemetente,
    required this.idConversa,
    required this.conteudo,
    required this.statusEnvio,
    required this.horarioEnvio,
    required this.sincronizado,
  });

  Map<String, dynamic> toMap() {
    return {
      "idMensagem": idMensagem,
      "idRemetente": idRemetente,
      "idConversa": idConversa,
      "conteudo": conteudo,
      "statusEnvio": statusEnvio,
      "horarioEnvio": horarioEnvio,
      "sincronizado": sincronizado,
    };
  }

  factory Mensagem.fromMap(Map<String, dynamic> map) {
    return Mensagem(
      idMensagem: map["idMensagem"],
      idRemetente: map["idRemetente"],
      idConversa: map["idConversa"],
      conteudo: map["conteudo"],
      statusEnvio: map["statusEnvio"],
      horarioEnvio: (map["horarioEnvio"] as Timestamp).toDate(),
      sincronizado: map["sincronizado"],
    );
  }
}
