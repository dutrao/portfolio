import 'package:drift/drift.dart';
import 'package:flutter_application_1/database/database.dart';

class StatusDestinatarioDao {
  final AppDatabase database;

  StatusDestinatarioDao({required this.database});
  Future<void> criarStatusDestinatario(
    String idMensagem,
    String idDestinatario,
  ) async {
    await database
        .into(database.statusDestinatarioTabela)
        .insert(
          StatusDestinatarioTabelaCompanion.insert(
            idMensagem: idMensagem,
            idDestinatario: idDestinatario,
            horarioEntrega: const Value.absent(),
            statusRecebimento: false,
          ),
        );
  }
}
