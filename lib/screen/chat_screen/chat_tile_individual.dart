import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/conversa.dart';
import 'package:flutter_application_1/model/militar.dart';
import 'package:flutter_application_1/model/militar_conversa.dart';
import 'package:flutter_application_1/screen/chat_screen/chat_screen.dart';
import 'package:flutter_application_1/storage/storage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatTileIndividual extends StatefulWidget {
  final Militar militar;

  const ChatTileIndividual({super.key, required this.militar});

  @override
  State<ChatTileIndividual> createState() => _ChatTileIndividualState();
}

class _ChatTileIndividualState extends State<ChatTileIndividual> {
  Conversa? conversa;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () async {
          await buscarOuCriarConversa();

          if (!mounted) return;

          if (conversa != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  conversa: conversa!,
                  listaParticipantes: [widget.militar],
                ),
              ),
            );
          }
        },
        child: ListTile(
          leading: const Icon(Icons.person, color: Colors.black),
          title: Text(widget.militar.nomeDeGuerra),
        ),
      ),
    );
  }

 Future<void> buscarOuCriarConversa() async {
  final storage = context.read<Storage>();

  final dadosUsuario = await storage.pegarDadosUsuario();

  if (dadosUsuario == null) return;

  if (!mounted) return;

  // Primeiro verifica se já existe uma conversa
  conversa = await storage.buscarConversaIndividual(
    dadosUsuario.idMilitar,
    widget.militar.idMilitar,
  );

  // Se já existe, utiliza a conversa existente
  if (conversa != null) {
    return;
  }

  // Se não existe, cria uma nova
  final idConversa = const Uuid().v4();

  final novaConversa = Conversa(
    idConversa: idConversa,
  );

  final militarConversaUsuario = MilitarConversa(
    idMilitar: dadosUsuario.idMilitar,
    idConversa: idConversa,
    sincronizado: false,
  );

  final militarConversaDestinatario = MilitarConversa(
    idMilitar: widget.militar.idMilitar,
    idConversa: idConversa,
    sincronizado: false,
  );

  // ==========================
  // SALVAR LOCALMENTE
  // ==========================

  await storage.criarConversa(
    idConversa,
  );

  await storage.criarMilitarConversa(
    idConversa,
    dadosUsuario.idMilitar,
  );

  await storage.criarMilitarConversa(
    idConversa,
    widget.militar.idMilitar,
  );

  // ==========================
  // SALVAR NO FIRESTORE
  // ==========================

  await storage.adicionarConversaNuvem(
    novaConversa,
  );

  await storage.adicionarMilitarConversaNuvem(
    militarConversaUsuario,
  );

  await storage.adicionarMilitarConversaNuvem(
    militarConversaDestinatario,
  );

  // ==========================
  // PEGAR CONVERSA LOCAL
  // ==========================

  conversa = await storage.pegarConversa(
    idConversa,
  );
}
}
