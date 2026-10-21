import 'package:cloud_firestore/cloud_firestore.dart';

class StatusDestinatario {
  final String idMensagem;
  final String idMilitar;
  final bool statusRecebimento;
  final DateTime? horarioEntrega;

  StatusDestinatario({
    required this.idMensagem,
    required this.idMilitar,
    required this.statusRecebimento,
    required this.horarioEntrega,
  });

  Map<String, dynamic> toMap() {
    return {
      "idMensagem": idMensagem,
      "idMilitar": idMilitar,
      "statusRecebimento": statusRecebimento,
      "horarioEntrega": horarioEntrega,
    };
  }

  factory StatusDestinatario.fromMap(Map<String, dynamic> map) {
    return StatusDestinatario(
      idMensagem: map["idMensagem"],
      idMilitar: map["idMilitar"],
      statusRecebimento: map["statusRecebimento"],
      horarioEntrega: map["horarioEntrega"] != null
          ? (map["horarioEntrega"] as Timestamp).toDate()
          : null,
    );
  }
}