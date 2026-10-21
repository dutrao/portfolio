class MilitarConversa {
  final String idMilitar;
  final String idConversa;
  final bool sincronizado;

  MilitarConversa({
    required this.idMilitar,
    required this.idConversa,
    required this.sincronizado,
  });

  Map<String, dynamic> toMap() {
    return {
      "idMilitar": idMilitar,
      "idConversa": idConversa,
      "sincronizado": sincronizado,
    };
  }

  factory MilitarConversa.fromMap(Map<String, dynamic> map) {
    return MilitarConversa(
      idMilitar: map["idMilitar"],
      idConversa: map["idConversa"],
      sincronizado: map["sincronizado"],
    );
  }
}