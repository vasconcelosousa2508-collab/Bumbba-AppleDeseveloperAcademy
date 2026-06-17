//import SwiftUI
//import SwiftData
//import SwiftDataSQLite
//
//struct LeituraView: View {
//    @Environment(\.modelContext) private var context
//    
//    // 1. Queries para ler o banco de dados
//    @Query(sort: \ConteudoLinha.ordemPosicao) var todasAsLinhas: [ConteudoLinha]
//    @Query var todosOsTrechos: [Trecho]
//    
//    var idVersaoSelecionada: Int
//    
//    // 2. Lógica de filtragem e relacionamento de tabelas
//    var trechosDaHistoria: [Trecho] {
//        let linhasFiltradas = todasAsLinhas.filter {
//            Int($0.idVersao) == Int(idVersaoSelecionada) && $0.idTrecho != nil
//        }
//        
//        return linhasFiltradas.compactMap { linha in
//            guard let idProcurado = linha.idTrecho else { return nil }
//            return todosOsTrechos.first(where: { Int($0.id) == Int(idProcurado) })
//        }
//    }
//    
//    var body: some View {
//        ZStack {
//            // Fundo padrão do iOS
//            Color(.systemBackground)
//                .ignoresSafeArea()
//            
//            if trechosDaHistoria.isEmpty {
//                ContentUnavailableView(
//                    "História vazia",
//                    systemImage: "book.closed",
//                    description: Text("Nenhum texto foi encontrado para esta versão do livro.")
//                )
//            } else {
//                // Lista nativa contínua (exibe um embaixo do outro)
//                List(trechosDaHistoria) { trecho in
//                    Text(trecho.texto)
//                        .font(.title2)
//                        .fontWeight(.regular)
//                        .padding(.vertical, 8)
//                        // Deixa cada linha centralizada na tela se quiser o efeito de livro continuo
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .multilineTextAlignment(.center)
//                        // Remove a linha divisória padrão da lista
//                        .listRowSeparator(.hidden)
//                        // Deixa o fundo da linha transparente para usar o do sistema
//                        .listRowBackground(Color.clear)
//                }
//                // Transforma a lista em um bloco limpo sem bordas cinzas extras
//                .listStyle(.plain)
//            }
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("Título do Livro")
//                    .font(FontesDoApp.xBold(tamanho: 20))
//                    .foregroundColor(.roxoTab)
//                    .padding(.top, 30)
//            }
//        }
//    }
//}
//
//// MARK: - Preview Padrão
//#Preview {
//    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
//        NavigationStack {
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
