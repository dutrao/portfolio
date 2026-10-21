import 'package:flutter_application_1/database/database.dart';
import 'package:flutter_application_1/model/conversa.dart';
import 'package:uuid/uuid.dart';

class ConversaDao {
  final AppDatabase database;

  ConversaDao({required this.database});

  Future<void> criarConversa(String idConversa) async {
    await database
        .into(database.conversaTabela)
        .insert(
          ConversaTabelaCompanion.insert(
            idConversa: idConversa,
            tipoGrupo: false,
            nome: '',
            descricao: '',
          ),
        );
  }

  Future<Conversa?> pegarConversa(String idConversa) async {
    final resultado = await (database.select(
      database.conversaTabela,
    )..where((tbl) => tbl.idConversa.equals(idConversa))).getSingleOrNull();
    if (resultado != null) {
      return Conversa(
        idConversa: resultado.idConversa,
        nomeConversa: resultado.nome,
        tipoGrupo: resultado.tipoGrupo,
      );
    } else {
      return null;
    }
  }
}
