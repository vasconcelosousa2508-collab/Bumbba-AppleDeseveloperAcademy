import SwiftUI
import SwiftData
import SwiftDataSQLite

struct LeituraView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss // Permite voltar para a tela anterior ao concluir
    
    // 1. Queries para carregar as tabelas na memória
    @Query(sort: \ConteudoLinha.ordemPosicao) var todasAsLinhas: [ConteudoLinha]
    @Query var todosOsTrechos: [Trecho]
    @Query var todasAsVersoes: [LivroVersaoNivel]
    @Query var todosOsLivros: [Livro]
    
    var idVersaoSelecionada: Int // Passando 101
    
    // 2. LÓGICA DO TÍTULO: Acha o Livro a partir da Versão 101
    var tituloDoLivro: String {
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
        let linhasFiltradas = todasAsLinhas.filter {
            "\($0.idVersao)" == "\(idVersaoSelecionada)" && $0.idTrecho != nil
        }
        
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
                // Organiza a lista de leitura e o botão fixo na parte inferior da tela
                VStack(spacing: 0) {
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
                    
                    // Botão Concluir integrado no estilo solicitado
                    Button(action: {
                        // Ação ao concluir a leitura (ex: voltar de tela)
                        dismiss()
                    }) {
                        HStack {
                            Text("Concluir")
                                .font(FontesDoApp.x(tamanho: 16))
                        }
                        .foregroundColor(.white)
                        .frame(width: 320, height: 50)
                        .background(Color.roxoTab)
                        .cornerRadius(100)
                        .opacity(0.8)
                    }
                    .padding(.vertical, 20) // Espaçamento confortável em relação à borda inferior
                }
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
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Preview Corrigido
#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        NavigationStack {
            LeituraView(idVersaoSelecionada: 101)
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
