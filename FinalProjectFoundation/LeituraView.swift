import SwiftUI
import SwiftData
import SwiftDataSQLite

struct FluxoHistoriaEAtividadeView: View {
    @Environment(\.dismiss) var dismiss
    
    let idVersaoSelecionada: Int
    
    // 1. Queries principais trazidas do banco
    @Query(sort: \ConteudoLinha.ordemPosicao) var todasAsLinhas: [ConteudoLinha]
    @Query var todosOsTrechos: [Trecho]
    @Query var todasAtividades: [Atividade]
    @Query var todasMultiplaEscolhas: [AtividadeMultiplaEscolha]
    @Query var todasAsVersoes: [LivroVersaoNivel]
    @Query var todosOsLivros: [Livro]
    
    // 2. Filtra apenas as linhas pertencentes a esta versão específica
    var linhasDaVersao: [ConteudoLinha] {
        todasAsLinhas.filter { "\($0.idVersao)" == "\(idVersaoSelecionada)" }
    }
    
    // 3. Título dinâmico do Livro
    var tituloDoLivro: String {
        guard let versao = todasAsVersoes.first(where: { "\($0.id)" == "\(idVersaoSelecionada)" }),
              let livro = todosOsLivros.first(where: { "\($0.id)" == "\(versao.idLivro)" }) else {
            return "Livro Desconhecido"
        }
        return livro.titulo
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.fundo.ignoresSafeArea()
            
            if linhasDaVersao.isEmpty {
                ContentUnavailableView(
                    "Nenhum conteúdo",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text("Nenhum trecho ou atividade nesta versão.")
                )
            } else {
                // Scroll principal contendo a história misturada com os desafios
                List {
                    ForEach(linhasDaVersao) { linha in
                        
                        // CASO A: A linha atual aponta para um Trecho de texto
                        if let idTrecho = linha.idTrecho,
                           let trecho = todosOsTrechos.first(where: { "\($0.id)" == "\(idTrecho)" }) {
                            
                            Text(trecho.texto)
                                .font(.title2)
                                .fontWeight(.regular)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        
                        // CASO B: A linha atual aponta para uma Atividade
                        else if let idAtividade = linha.idAtividade,
                                let atividade = todasAtividades.first(where: { $0.id == idAtividade }),
                                let multiplaEscolha = todasMultiplaEscolhas.first(where: { $0.idAtividade == atividade.id }) {
                            
                            // Renderiza o bloco de atividade diretamente na timeline
                            ComponenteMultiplaEscolha(multiplaEscolha: multiplaEscolha)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                    
                    // Botão final para concluir a jornada (só aparece no fim da List)
                    Button(action: { dismiss() }) {
                        Text("Concluir Jornada")
                            .font(FontesDoApp.x(tamanho: 16))
                            .foregroundColor(.white)
                            .frame(width: 320, height: 50)
                            .background(Color.roxoTab)
                            .cornerRadius(100)
                            .opacity(0.8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
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


#Preview {
    ZStack {
        if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
            NavigationStack {
                FluxoHistoriaEAtividadeView(idVersaoSelecionada: 101)
                    .modelContainer(
                        for: [
                            Responsavel.self, Crianca.self, Avatar.self,
                            Livro.self, LivroVersaoNivel.self, ConteudoLinha.self,
                            Trecho.self, Atividade.self, AtividadeMultiplaEscolha.self
                        ],
                        inMemory: false,
                        sqliteDatabasePath: dbPath
                    )
            }
        } else {
            ContentUnavailableView(
                "Banco não encontrado",
                systemImage: "xmark.rectangle",
                description: Text("Certifique-se de que o arquivo 'db.sqlite' foi adicionado ao target do projeto.")
            )
        }
    }
}
