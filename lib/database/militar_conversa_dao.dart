import 'package:flutter_application_1/database/database.dart';

class MilitarConversaDao {
  final AppDatabase database;

  MilitarConversaDao({required this.database});

  Future<void> criarMilitarConversa(String idConversa, String idMilitar) async {
   
   await database
        .into(database.militarConversaTabela)
        .insert(
          MilitarConversaTabelaCompanion.insert(
            idConversa: idConversa,
            idMilitar: idMilitar,
          ),
        );
  }
}
