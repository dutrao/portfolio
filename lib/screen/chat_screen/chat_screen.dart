import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/conversa.dart';
import 'package:flutter_application_1/model/mensagem.dart';
import 'package:flutter_application_1/model/militar.dart';
import 'package:flutter_application_1/storage/storage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final Conversa conversa;
  final List<Militar> listaParticipantes;
  const ChatScreen({
    super.key,
    required this.conversa,
    required this.listaParticipantes,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController mensagemController = TextEditingController();
  List<Mensagem> listaMensagem = [];
  Militar? usuario;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();

    usuario = context.read<Storage>().dadosUsuario;

    Future.microtask(() async {
      listaMensagem = await context.read<Storage>().buscarMensagensConversa(
        widget.conversa.idConversa,
      );

      print("mensagens anteriores ${listaMensagem.length}");

      if (!mounted) return;

      setState(() {});

      streamSubscription = context
          .read<Storage>()
          .abrirStremMensagemNuvem(
            widget.conversa.idConversa,
            usuario!.idMilitar,
          )
          .listen((event) async {
            for (final change in event.docChanges) {
              if (change.type == DocumentChangeType.added) {
                final map = change.doc.data();

                if (map != null) {
                  final mensagem = Mensagem.fromMap(map);

                  final mensagemJaExiste = listaMensagem.any(
                    (item) => item.idMensagem == mensagem.idMensagem,
                  );

                  if (!mensagemJaExiste) {
                    await context.read<Storage>().criarMensagemLocal(
                      mensagem.idMensagem,
                      mensagem.idConversa,
                      mensagem.idRemetente,
                      mensagem.horarioEnvio,
                      mensagem.statusEnvio,
                      mensagem.conteudo,
                    );

                    if (!mounted) return;

                    setState(() {
                      listaMensagem.add(mensagem);
                    });
                  }
                }
              }
            }
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
    mensagemController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listaMensagem.length,
                itemBuilder: (context, index) {
                  return listaMensagem[index].idRemetente != usuario!.idMilitar
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(listaMensagem[index].conteudo),
                              Row(
                                children: [
                                  Text(
                                    '${listaMensagem[index].horarioEnvio.hour}:${listaMensagem[index].horarioEnvio.minute}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(listaMensagem[index].conteudo),
                                Text(
                                  '${listaMensagem[index].horarioEnvio.hour}:${listaMensagem[index].horarioEnvio.minute}',
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
            ),
            Row(
              children: [
                Expanded(child: TextFormField(controller: mensagemController)),
                IconButton(
                  onPressed: () async {
                    final idMensagem = const Uuid().v4();
                    await enviarMensagemLocal(idMensagem);
                    await enviarMensagemNuvem(idMensagem);
                    mensagemController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> enviarMensagemLocal(String idMensagem) async {
    if (usuario != null) {
      listaMensagem.add(
        Mensagem(
          idMensagem: idMensagem,
          idRemetente: usuario!.idMilitar,
          idConversa: widget.conversa.idConversa,
          conteudo: mensagemController.text,
          statusEnvio: true,
          horarioEnvio: DateTime.now(),
          sincronizado: false,
        ),
      );
      context.read<Storage>().criarMensagemLocal(
        idMensagem,
        widget.conversa.idConversa,
        usuario!.idMilitar,
        DateTime.now(),
        true,
        mensagemController.text,
      );
      context.read<Storage>().criarStatusDestinatario(
        idMensagem,
        widget.listaParticipantes[0].idMilitar,
      );
    }
  }

  Future<void> enviarMensagemNuvem(String idMensagem) async {
    context.read<Storage>().adicionarMensagemNuvem(
      Mensagem(
        idMensagem: idMensagem,
        idRemetente: usuario!.idMilitar,
        idConversa: widget.conversa.idConversa,
        conteudo: mensagemController.text,
        statusEnvio: true,
        horarioEnvio: DateTime.now(),
        sincronizado: true,
      ),
    );
    /*context.read<Storage>().adicionarStatusDestinatarioNuvem(
        idMensagem,
        widget.listaParticipantes[0].idMilitar,
      );*/
  }
}
