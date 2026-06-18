import SwiftUI
import SwiftData
import SwiftDataSQLite

struct LeituraView: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \ConteudoLinha.ordemPosicao) var todasAsLinhas: [ConteudoLinha]
    @Query var todosOsTrechos: [Trecho]
    @Query var todasAsVersoes: [LivroVersaoNivel]
    @Query var todosOsLivros: [Livro]
    
    var idVersaoSelecionada: Int // Recebe o ID dinâmico filtrado (ex: 101, 201)
    
    // MARK: - Título Dinâmico
    var tituloDoLivro: String {
        guard let versao = todasAsVersoes.first(where: { "\($0.id)" == "\(idVersaoSelecionada)" }),
              let livro = todosOsLivros.first(where: { "\($0.id)" == "\(versao.idLivro)" }) else {
            return "Livro"
        }
        return livro.titulo
    }
    
    // MARK: - Trechos Ordenados
    var trechosDaHistoria: [Trecho] {
        // 1. Filtra as linhas da versão selecionada que possuem trecho associado
        let linhasDaVersao = todasAsLinhas.filter {
            "\($0.idVersao)" == "\(idVersaoSelecionada)" && $0.idTrecho != nil
        }
        
        // Como 'todasAsLinhas' já veio ordenada pelo @Query(sort: \ConteudoLinha.ordemPosicao),
        // este map vai manter a sequência exata de exibição (1, 2, 3...)
        return linhasDaVersao.compactMap { linha in
            guard let idProcurado = linha.idTrecho else { return nil }
            return todosOsTrechos.first(where: { "\($0.id)" == "\(idProcurado)" })
        }
    }
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            if trechosDaHistoria.isEmpty {
                ContentUnavailableView(
                    "Conteúdo indisponível",
                    systemImage: "book.closed",
                    description: Text("Nenhum trecho adaptado foi encontrado para esta versão (\(idVersaoSelecionada)).")
                )
            } else {
                List(trechosDaHistoria) { trecho in
                    Text(trecho.texto)
                        .font(.title2)
                        .fontWeight(.regular)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
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
