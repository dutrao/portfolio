class Conversa {
  final String idConversa;
  final String nomeConversa;
  final bool tipoGrupo;

  Conversa({
    required this.idConversa,
    this.nomeConversa = '',
    this.tipoGrupo = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "idConversa": idConversa,
      "nomeConversa": nomeConversa,
      "tipoGrupo": tipoGrupo,
    };
  }

  factory Conversa.fromMap(Map<String, dynamic> map) {
    return Conversa(
      idConversa: map["idConversa"],
      nomeConversa: map["nomeConversa"],
      tipoGrupo: map["tipoGrupo"],
    );
  }
}