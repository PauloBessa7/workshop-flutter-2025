import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        // Nossa tela
        appBar: AppBar(
          // Nosso cabeçalho
          title: Text('Lista de tarefas'), // Titulo de nosso cabeçalho
        ),
        body: ListView(
          children: [
            Tarefa(titulo: 'Ir para Expoinga 2025'),
            Tarefa(titulo: 'Finalizar aula de Flutter',),
            Tarefa(titulo: 'Postar código da aula no Linkdin'),
          ],
        ),
      ),
    );
  }
}

class Tarefa extends StatefulWidget {
  // abstração do widget
  final String titulo;
  const Tarefa({super.key, required this.titulo});

  @override
  State<Tarefa> createState() => _TarefaState();
}

class _TarefaState extends State<Tarefa> {
  int valorStatus = 1;
  @override
  Widget build(BuildContext context) {
    // construção do widget
    String validaStatus() {
      if (valorStatus <= 1) {
        return "A FAZER";
      } else if (valorStatus == 2) {
        return "FAZENDO";
      } else if (valorStatus >= 3) {
        return "FINALIZADO";
      } else {
        return "ERRO";
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          valorStatus++;
          if (valorStatus > 3) {
            valorStatus = 1;
          }
        });
      },
      child: Card(
        // (condição) ? true : false
        color:
            (valorStatus == 1)
                ? Colors.redAccent
                : // validar 1 ou
                (valorStatus == 2)
                ? Colors.blueAccent
                : // validar 2 ou
                Colors.greenAccent, // caso 3
        child: ListTile(
          title: Text(widget.titulo),
          trailing: Text(validaStatus(), style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
