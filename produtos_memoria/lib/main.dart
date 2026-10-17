import 'package:flutter/material.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaProdutos(),
    );
  }
}

// ---------------------------------------------------------------------------
// Modelo (exercícios 5 e 9: quantidade e id estável)
// ---------------------------------------------------------------------------
class Produto {
  final int id;
  final String nome;
  final double preco;
  final String descricao;
  final int quantidade;

  const Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.quantidade,
  });

  // Exercício 6: valor do item em estoque.
  double get valorEstoque => preco * quantidade;

  // Usado pela tela principal ao aceitar um cadastro (ela atribui o id).
  Produto comId(int novoId) => Produto(
        id: novoId,
        nome: nome,
        preco: preco,
        descricao: descricao,
        quantidade: quantidade,
      );
}

String moeda(double valor) => 'R\$ ${valor.toStringAsFixed(2)}';

// ---------------------------------------------------------------------------
// Tela principal: lista, busca, total, cadastro e exclusão
// ---------------------------------------------------------------------------
class TelaProdutos extends StatefulWidget {
  const TelaProdutos({super.key});

  @override
  State<TelaProdutos> createState() => _TelaProdutosState();
}

class _TelaProdutosState extends State<TelaProdutos> {
  final List<Produto> produtos = [];
  final buscaController = TextEditingController();
  String busca = '';

  // Exercício 9: contador que nunca diminui, mesmo após exclusões.
  int proximoId = 1;

  // Exercício 8: lista filtrada mantém referências aos MESMOS objetos.
  List<Produto> get filtrados {
    final termo = busca.trim().toLowerCase();
    if (termo.isEmpty) return produtos;
    return produtos
        .where((p) => p.nome.toLowerCase().contains(termo))
        .toList();
  }

  // Exercício 6/10: total de TODOS os produtos, independente do filtro.
  double get totalEstoque {
    double total = 0;
    for (final p in produtos) {
      total += p.valorEstoque;
    }
    return total;
  }

  // Exercício 7: nomes (normalizados) dos outros produtos.
  List<String> nomesOutros({int? ignorarId}) => [
        for (final p in produtos)
          if (p.id != ignorarId) p.nome.trim().toLowerCase(),
      ];

  void avisar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> cadastrar() async {
    final novo = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => TelaFormulario(nomesOutros: nomesOutros()),
      ),
    );
    if (!mounted || novo == null) return;
    setState(() {
      produtos.add(novo.comId(proximoId));
      proximoId++;
    });
    avisar('Produto cadastrado com sucesso.');
  }

  Future<void> abrirDetalhes(Produto selecionado) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => TelaDetalhes(
          produto: selecionado,
          nomesOutros: nomesOutros(ignorarId: selecionado.id),
        ),
      ),
    );
    if (!mounted || atualizado == null) return;

    // Exercício 9: localiza por id, nunca pela posição visível.
    final indice = produtos.indexWhere((p) => p.id == atualizado.id);
    if (indice == -1) {
      avisar('Produto não encontrado. Nada foi alterado.');
      return;
    }
    setState(() {
      produtos[indice] = atualizado;
    });
    avisar('Produto atualizado.');
  }

  Future<void> excluir(Produto produto) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja excluir ${produto.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (!mounted || confirmou != true) return;

    final indice = produtos.indexWhere((p) => p.id == produto.id);
    if (indice == -1) {
      avisar('Produto não encontrado. Nada foi excluído.');
      return;
    }
    setState(() {
      produtos.removeAt(indice);
    });
    avisar('Produto excluído.');
  }

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visiveis = filtrados;

    Widget corpoLista;
    if (produtos.isEmpty) {
      corpoLista = const Center(child: Text('Nenhum produto cadastrado.'));
    } else if (visiveis.isEmpty) {
      corpoLista = const Center(child: Text('Nenhum produto encontrado.'));
    } else {
      corpoLista = ListView.builder(
        itemCount: visiveis.length,
        itemBuilder: (context, indice) {
          final produto = visiveis[indice];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              title: Text(produto.nome),
              subtitle: Text(
                '${moeda(produto.preco)} • Qtd: ${produto.quantidade}\n'
                'Valor em estoque: ${moeda(produto.valorEstoque)}',
              ),
              isThreeLine: true,
              onTap: () => abrirDetalhes(produto),
              trailing: IconButton(
                tooltip: 'Excluir produto',
                icon: const Icon(Icons.delete),
                onPressed: () => excluir(produto),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos em memória')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: buscaController,
              decoration: InputDecoration(
                labelText: 'Buscar por nome',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: busca.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          buscaController.clear();
                          setState(() {
                            busca = '';
                          });
                        },
                      ),
              ),
              onChanged: (valor) {
                setState(() {
                  busca = valor;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Produtos cadastrados: ${produtos.length}'),
                Text('Produtos encontrados: ${visiveis.length}'),
                Text('Valor total do estoque: ${moeda(totalEstoque)}'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: corpoLista),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: cadastrar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tela de detalhes
// ---------------------------------------------------------------------------
class TelaDetalhes extends StatelessWidget {
  final Produto produto;
  final List<String> nomesOutros;

  const TelaDetalhes({
    super.key,
    required this.produto,
    required this.nomesOutros,
  });

  Future<void> editar(BuildContext context) async {
    final atualizado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute<Produto>(
        builder: (_) => TelaFormulario(
          produto: produto,
          nomesOutros: nomesOutros,
        ),
      ),
    );
    if (!context.mounted || atualizado == null) return;
    Navigator.pop(context, atualizado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(produto.nome, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            Text('Preço: ${moeda(produto.preco)}'),
            const SizedBox(height: 12),
            Text('Quantidade em estoque: ${produto.quantidade}'),
            const SizedBox(height: 12),
            Text('Valor em estoque: ${moeda(produto.valorEstoque)}'),
            const SizedBox(height: 12),
            Text(
              produto.descricao.isEmpty ? 'Sem descrição.' : produto.descricao,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => editar(context),
              child: const Text('Editar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Formulário reutilizado para cadastro e edição
// ---------------------------------------------------------------------------
class TelaFormulario extends StatefulWidget {
  final Produto? produto;

  // Exercício 7: nomes dos OUTROS produtos (já em minúsculas e sem espaços
  // nas pontas). Na edição, o próprio produto não está nesta lista.
  final List<String> nomesOutros;

  const TelaFormulario({
    super.key,
    this.produto,
    this.nomesOutros = const [],
  });

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final chave = GlobalKey<FormState>();
  late final TextEditingController nomeController;
  late final TextEditingController precoController;
  late final TextEditingController quantidadeController;
  late final TextEditingController descricaoController;

  @override
  void initState() {
    super.initState();
    final produto = widget.produto;
    nomeController = TextEditingController(text: produto?.nome ?? '');
    precoController = TextEditingController(
      text: produto?.preco.toString() ?? '',
    );
    quantidadeController = TextEditingController(
      text: produto?.quantidade.toString() ?? '',
    );
    descricaoController = TextEditingController(
      text: produto?.descricao ?? '',
    );
  }

  double? converterPreco(String texto) {
    return double.tryParse(texto.trim().replaceAll(',', '.'));
  }

  String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o nome.';
    }
    if (valor.trim().length < 3) {
      return 'O nome deve ter pelo menos três caracteres.';
    }
    if (widget.nomesOutros.contains(valor.trim().toLowerCase())) {
      return 'Já existe um produto com esse nome.';
    }
    return null;
  }

  String? validarPreco(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o preço.';
    }
    final preco = converterPreco(valor);
    if (preco == null || !preco.isFinite) {
      return 'Digite um número válido.';
    }
    if (preco <= 0) return 'O preço deve ser maior que zero.';
    return null;
  }

  String? validarQuantidade(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe a quantidade.';
    }
    final quantidade = int.tryParse(valor.trim());
    if (quantidade == null) return 'Digite um número inteiro.';
    if (quantidade < 0) return 'A quantidade não pode ser negativa.';
    return null;
  }

  String? validarDescricao(String? valor) {
    if (valor != null && valor.trim().length > 120) {
      return 'A descrição deve ter no máximo 120 caracteres.';
    }
    return null;
  }

  void salvar() {
    if (!chave.currentState!.validate()) return;
    final produto = Produto(
      // Na edição preserva o id original; no cadastro 0 é provisório,
      // a tela principal atribui o id definitivo.
      id: widget.produto?.id ?? 0,
      nome: nomeController.text.trim(),
      preco: converterPreco(precoController.text)!,
      descricao: descricaoController.text.trim(),
      quantidade: int.tryParse(quantidadeController.text.trim())!,
    );
    Navigator.pop(context, produto);
  }

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    quantidadeController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.produto != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar produto' : 'Cadastrar produto'),
      ),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: precoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Preço'),
                validator: validarPreco,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade em estoque',
                ),
                validator: validarQuantidade,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição opcional (máx. 120)',
                ),
                maxLines: 3,
                validator: validarDescricao,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
