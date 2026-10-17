import 'package:flutter/material.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaNome(),
    );
  }
}

class TelaNome extends StatefulWidget {
  const TelaNome({super.key});

  @override
  State<TelaNome> createState() => _TelaNomeState();
}

class _TelaNomeState extends State<TelaNome> {
  final chave = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  String mensagem = '';

  // Exercício 1: nome obrigatório e com pelo menos 3 caracteres após trim().
  String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o nome.';
    }
    if (valor.trim().length < 3) {
      return 'O nome deve ter pelo menos três caracteres.';
    }
    return null;
  }

  // Exercício 2: saudação antiga é apagada quando a entrada é inválida.
  void confirmar() {
    if (chave.currentState!.validate()) {
      setState(() {
        mensagem = 'Olá, ${nomeController.text.trim()}!';
      });
    } else {
      setState(() {
        mensagem = '';
      });
    }
  }

  // Exercício 2: Limpar apaga campo, saudação e mensagens de validação.
  void limpar() {
    nomeController.clear();
    chave.currentState!.reset();
    setState(() {
      mensagem = '';
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nome validado')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: chave,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: validarNome,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: confirmar,
                child: const Text('Confirmar'),
              ),
              TextButton(
                onPressed: limpar,
                child: const Text('Limpar'),
              ),
              const SizedBox(height: 20),
              Text(mensagem),
            ],
          ),
        ),
      ),
    );
  }
}
