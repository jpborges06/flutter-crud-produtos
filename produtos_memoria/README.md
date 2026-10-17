# produtos_memoria – Gerenciador de produtos (Exercícios 3 a 10)

CRUD de produtos feito somente com Flutter e Dart.

## Recursos

- Cadastro e edição com **o mesmo formulário** (`TelaFormulario`).
- Validação: nome (obrigatório, mín. 3 caracteres, sem repetição ignorando maiúsculas/minúsculas),
  preço (número finito > 0, aceita vírgula), quantidade (inteira ≥ 0), descrição opcional (máx. 120).
- Editar sem mudar o nome é permitido (o próprio registro é excluído da comparação).
- Cancelar cadastro, edição ou exclusão não altera os dados; exclusão exige confirmação.
- Busca por nome (ignora maiúsculas/minúsculas), com contadores separados de cadastrados e encontrados
  e a mensagem `Nenhum produto encontrado.`
- Cada produto tem um `id` inteiro estável, atribuído pela tela principal com um contador que nunca diminui.
  Edição e exclusão localizam o registro com `indexWhere()` por id, e nunca pela posição na lista filtrada.
- Valor por item (preço × quantidade) e valor total do estoque, calculado com um laço sobre **todos** os produtos
  (o filtro não altera o total).

## Como executar

```bash
flutter create produtos_memoria
# substitua produtos_memoria/lib/main.dart pelo arquivo desta pasta
cd produtos_memoria
flutter run
```

## Importante

Os dados ficam **apenas na memória**: ao reiniciar o aplicativo (hot restart ou fechar), os produtos desaparecem.

## Falha corrigida (preencha com a sua experiência)

Ao editar um item filtrado, a posição da lista visível não corresponde à posição na lista original.
Usar esse índice alteraria o produto errado. Solução: localizar o registro por `id` com `indexWhere()`.

## Para persistir depois de fechar o app (conceitual)

Gravar os produtos em armazenamento local (arquivo JSON, `shared_preferences` ou banco SQLite), carregar a lista
ao iniciar o app e salvar a cada cadastro, edição ou exclusão. Seria preciso serializar/desserializar o `Produto`
(`toMap`/`fromMap`) e trabalhar com operações assíncronas.
