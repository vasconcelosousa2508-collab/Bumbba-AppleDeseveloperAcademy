//import SwiftUI
//import SwiftData
//import SwiftDataSQLite
//
//struct LeituraView: View {
//    @Environment(\.modelContext) private var context
//    
//    // 1. Queries para carregar as tabelas na memória
//    @Query(sort: \ConteudoLinha.ordemPosicao) var todasAsLinhas: [ConteudoLinha]
//    @Query var todosOsTrechos: [Trecho]
//    @Query var todasAsVersoes: [LivroVersaoLinha]
//    @Query var todosOsLivros: [Livro]
//    
//    var idVersaoSelecionada: Int // Aqui vai entrar o seu 101
//    
//    // 2. LÓGICA DO TÍTULO: Acha o Livro a partir da Versão 101
//    var tituloDoLivro: String {
//        // Procura a versão 101 para descobrir qual é o id_livro (no seu exemplo: id_livro 1)
//        guard let versao = todasAsVersoes.first(where: { Int($0.id) == Int(idVersaoSelecionada) }) else {
//            return "Livro Desconhecido"
//        }
//        
//        // Pega o id_livro (1) e vai buscar o nome dele na tabela Livro ("Se essa rua fosse minha")
//        guard let livro = todosOsLivros.first(where: { Int($0.id) == Int(versao.idLivro) }) else {
//            return "Livro Desconhecido"
//        }
//        
//        return livro.titulo
//    }
//    
//    // 3. LÓGICA DOS TRECHOS: Acha os textos a partir da Versão 101
//    var trechosDaHistoria: [Trecho] {
//        // Filtra na tabela Conteudo tudo o que for da versão 101 (acha o id_trecho 1)
//        let linhasFiltradas = todasAsLinhas.filter {
//            Int($0.idVersao) == Int(idVersaoSelecionada) && $0.idTrecho != nil
//        }
//        
//        // Pega o id_trecho (1) e busca o texto real dele lá na tabela Trecho
//        return linhasFiltradas.compactMap { linha in
//            guard let idProcurado = linha.idTrecho else { return nil }
//            return todosOsTrechos.first(where: { Int($0.id) == Int(idProcurado) })
//        }
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.fundo.ignoresSafeArea()
//            
//            if trechosDaHistoria.isEmpty {
//                ContentUnavailableView(
//                    "História vazia",
//                    systemImage: "book.closed",
//                    description: Text("Nenhum texto foi encontrado para esta versão.")
//                )
//            } else {
//                // Exibe os textos um embaixo do outro na tela
//                List(trechosDaHistoria) { trecho in
//                    Text(trecho.texto)
//                        .font(.title2)
//                        .fontWeight(.regular)
//                        .padding(.vertical, 8)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .multilineTextAlignment(.center)
//                        .listRowSeparator(.hidden)
//                        .listRowBackground(Color.clear)
//                }
//                .listStyle(.plain)
//            }
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                // Mostra o título ("Se essa rua fosse minha") lá no topo da barra
//                Text(tituloDoLivro)
//                    .font(FontesDoApp.xBold(tamanho: 20))
//                    .foregroundColor(.roxoTab)
//                    .padding(.top, 30)
//            }
//        }
//    }
//}
//
//// MARK: - Preview Padrão (Usando os seus dados de teste)
//#Preview {
//    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
//        NavigationStack {
//            // Testando exatamente com a versão 101 do seu exemplo
//            LeituraView(idVersaoSelecionada: 101)
//                .modelContainer(
//                    for: [ConteudoLinha.self, Trecho.self, Atividade.self, LivroVersaoLinha.self, Livro.self],
//                    inMemory: true,
//                    sqliteDatabasePath: dbPath
//                )
//        }
//    } else {
//        ContentUnavailableView("Banco db.sqlite não encontrado", systemImage: "exclamationmark.triangle")
//    }
//}
