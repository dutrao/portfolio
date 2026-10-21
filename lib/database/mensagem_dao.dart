import 'package:flutter_application_1/database/database.dart';
import 'package:flutter_application_1/model/mensagem.dart';
import 'package:uuid/uuid.dart';

class MensagemDao {
  final AppDatabase database;

  MensagemDao({required this.database});

  Future<void> criarMensagemLocal(
    String idMensagem,
    String idConversa,
    String remetente,
    DateTime horarioEnvio,
    bool statusEnvio,
    String conteudo,
  ) async {  
    await database
        .into(database.mensagemTabela)
        .insert(
          MensagemTabelaCompanion.insert(
            idMensagem: idMensagem,
            idConversa: idConversa,
            remetente: remetente,
            horarioEnvio: horarioEnvio,
            statusEnvio: statusEnvio,
            conteudo: conteudo,
          ),
        );
  }

  Future<List<Mensagem>> buscarMensagensConversa(String idConversa) async {
    List<Mensagem> listaMensagem = [];
    final resultados = await (database.select(
      database.mensagemTabela,
    )..where((tbl) => tbl.idConversa.equals(idConversa))).get();
    for (final resultado in resultados) {
      listaMensagem.add(
        Mensagem(
          idMensagem: resultado.idMensagem,
          idRemetente: resultado.remetente,
          idConversa: resultado.idConversa,
          conteudo: resultado.conteudo,
          statusEnvio: resultado.statusEnvio,          
          horarioEnvio: resultado.horarioEnvio,
          sincronizado: resultado.sincronizado,
        ),
      );
    }
    return listaMensagem;
  }
}
