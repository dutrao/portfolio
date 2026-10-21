import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/militar.dart';
import 'package:flutter_application_1/screen/chat_screen/chat_tile_individual.dart';
import 'package:flutter_application_1/storage/storage.dart';
import 'package:provider/provider.dart';

class HomeChatScreen extends StatefulWidget {
  const HomeChatScreen({super.key});

  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
 final TextEditingController searchController =  TextEditingController();
 List<Militar> listaMilitaresConversa = [];
 

  @override
  Widget build(BuildContext context) {
    final listaTotalMilitares = context.read<Storage>().listaTotalMilitares;
    print('militares chat: ${listaTotalMilitares.length}');
       
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SearchBar(
                controller: searchController,
                leading: Icon(Icons.search),
                onChanged: (nome)async{
                  final resultado = listaTotalMilitares.where((militar) {
                    return militar.nomeCompleto.toLowerCase().contains(nome.toLowerCase());
                  },).toList();
                  //tirar usuario depois
                  final militar = await context.read<Storage>().pegarDadosUsuario();
                  
                  setState(() {
                  listaMilitaresConversa = resultado;
                  });
                } ,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listaMilitaresConversa.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                    child: ChatTileIndividual(
                      militar: listaMilitaresConversa[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void carregarConversas() {

  }
}