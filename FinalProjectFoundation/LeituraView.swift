import SwiftUI
import SwiftData
import SwiftDataSQLite

struct LeituraView: View {
    @Environment(\.modelContext) private var context
    
    // 1. Queries para carregar as tabelas na memória
    @Query(sort: \ConteudoLinha.ordemPosicao) var todasAsLinhas: [ConteudoLinha]
    @Query var todosOsTrechos: [Trecho]
    @Query var todasAsVersoes: [LivroVersaoNivel]
    @Query var todosOsLivros: [Livro]
    
    var idVersaoSelecionada: Int // Passando 101
    
    // 2. LÓGICA DO TÍTULO: Acha o Livro a partir da Versão 101
    var tituloDoLivro: String {
        // CORREÇÃO: Compara convertendo ambos os IDs para string ou Int64 para evitar falhas de tipagem do SQLite
        guard let versao = todasAsVersoes.first(where: { "\($0.id)" == "\(idVersaoSelecionada)" }) else {
            return "Livro Desconhecido"
        }
        
        guard let livro = todosOsLivros.first(where: { "\($0.id)" == "\(versao.idLivro)" }) else {
            return "Livro Desconhecido"
        }
        
        return livro.titulo
    }
    
    // 3. LÓGICA DOS TRECHOS: Acha os textos a partir da Versão 101
    var trechosDaHistoria: [Trecho] {
        // CORREÇÃO: Filtra comparando os tipos de forma flexível como String
        let linhasFiltradas = todasAsLinhas.filter {
            "\($0.idVersao)" == "\(idVersaoSelecionada)" && $0.idTrecho != nil
        }
        
        // Pega o id_trecho e busca o texto real dele lá na tabela Trecho
        return linhasFiltradas.compactMap { linha in
            guard let idProcurado = linha.idTrecho else { return nil }
            return todosOsTrechos.first(where: { "\($0.id)" == "\(idProcurado)" })
        }
    }
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            if trechosDaHistoria.isEmpty {
                ContentUnavailableView(
                    "História vazia",
                    systemImage: "book.closed",
                    description: Text("Nenhum texto foi encontrado para a versão \(idVersaoSelecionada).\nTotal de linhas no banco: \(todasAsLinhas.count)")
                )
            } else {
                List(trechosDaHistoria) { trecho in
                    Text(trecho.texto)
                        .font(.title2)
                        .fontWeight(.regular)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(tituloDoLivro)
                    .font(FontesDoApp.xBold(tamanho: 20))
                    .foregroundColor(.roxoTab)
                    .padding(.top, 30)
            }
        }
    }
}

// MARK: - Preview Corrigido
#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        NavigationStack {
            LeituraView(idVersaoSelecionada: 101)
                // CORREÇÃO: inMemory precisa ser FALSE para ele ler o arquivo do dbPath
                .modelContainer(
                    for: [ConteudoLinha.self, Trecho.self, Atividade.self, LivroVersaoNivel.self, Livro.self],
                    inMemory: false,
                    sqliteDatabasePath: dbPath
                )
        }
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado no Bundle", systemImage: "exclamationmark.triangle")
    }
}
