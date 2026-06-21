import SwiftUI
import SwiftData
import SwiftDataSQLite

struct FluxoHistoriaEAtividadeView: View {
    @Environment(\.dismiss) var dismiss
    let idVersaoSelecionada: Int
    
    @Query(sort: \ConteudoLinha.ordemPosicao) var todasAsLinhas: [ConteudoLinha]
    @Query var todosOsTrechos: [Trecho]
    @Query var todasAtividades: [Atividade]
    @Query var todasMultiplaEscolhas: [AtividadeMultiplaEscolha]
    @Query var todasDesembaralhar: [AtividadeDesembaralhar] // 🚀 Adicionado a Query da nova tabela
    @Query var todasAsVersoes: [LivroVersaoNivel]
    @Query var todosOsLivros: [Livro]
    
    @State private var mostrarBannerCorreto = false
    @State private var mostrarBannerErrado = false
    @State private var atividadesResolvidas: [Int: Bool] = [:]
    
    var linhasDaVersao: [ConteudoLinha] {
        todasAsLinhas.filter { $0.idVersao == idVersaoSelecionada }
    }
    
    var idsAtividadesObrigatorias: [Int] {
        linhasDaVersao.compactMap { $0.idAtividade }
    }
    
    var todasAtividadesConcluidas: Bool {
        guard !idsAtividadesObrigatorias.isEmpty else { return true }
        return idsAtividadesObrigatorias.allSatisfy { atividadesResolvidas[$0] == true }
    }
    
    var tituloDoLivro: String {
        guard let versao = todasAsVersoes.first(where: { $0.id == idVersaoSelecionada }),
              let livro = todosOsLivros.first(where: { $0.id == versao.idLivro }) else {
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
                List {
                    ForEach(linhasDaVersao) { linha in
                        
                        if let idTrecho = linha.idTrecho,
                           let trecho = todosOsTrechos.first(where: { $0.id == idTrecho }) {
                            
                            Text(trecho.texto)
                                .font(.title2)
                                .fontWeight(.regular)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        
                        else if let idAtividade = linha.idAtividade,
                                let atividade = todasAtividades.first(where: { $0.id == idAtividade }) {
                            
                            // 💡 INTEGRAÇÃO TIPO 1: Múltipla Escolha
                            if let multiplaEscolha = todasMultiplaEscolhas.first(where: { $0.idAtividade == atividade.id }) {
                                ComponenteMultiplaEscolha(
                                    idAtividade: atividade.id,
                                    instrucao: atividade.instrucao,
                                    multiplaEscolha: multiplaEscolha,
                                    onCorreto: { id in
                                        atividadesResolvidas[id] = true
                                        withAnimation(.spring()) {
                                            mostrarBannerErrado = false
                                            mostrarBannerCorreto = true
                                        }
                                    },
                                    onErrado: {
                                        withAnimation(.spring()) {
                                            mostrarBannerCorreto = false
                                            mostrarBannerErrado = true
                                        }
                                    }
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            
                            // 💡 INTEGRAÇÃO TIPO 2: Desembaralhar (Frases ou Palavras)
                            else if let desembaralhar = todasDesembaralhar.first(where: { $0.idAtividade == atividade.id }) {
                                ComponenteDesembaralhar(
                                    idAtividade: atividade.id,
                                    instrucao: atividade.instrucao,
                                    dadosDesembaralhar: desembaralhar,
                                    onCorreto: { id in
                                        atividadesResolvidas[id] = true
                                        withAnimation(.spring()) {
                                            mostrarBannerErrado = false
                                            mostrarBannerCorreto = true
                                        }
                                    },
                                    onErrado: {
                                        withAnimation(.spring()) {
                                            mostrarBannerCorreto = false
                                            mostrarBannerErrado = true
                                        }
                                    }
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                    
                    Button(action: {
                        if todasAtividadesConcluidas { dismiss() }
                    }) {
                        Text(todasAtividadesConcluidas ? "Concluir Jornada" : "Responda os desafios para concluir")
                            .font(FontesDoApp.x(tamanho: 16))
                            .foregroundColor(.white)
                            .frame(width: 320, height: 50)
                            .background(todasAtividadesConcluidas ? Color.roxoTab : Color.gray.opacity(0.4))
                            .cornerRadius(100)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .disabled(!todasAtividadesConcluidas)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .disabled(mostrarBannerCorreto || mostrarBannerErrado)
            }
            
            // Banners mantidos de forma idêntica
            if mostrarBannerCorreto { bannerSucesso }
            if mostrarBannerErrado { bannerErro }
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
    
    private var bannerSucesso: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill").font(.title2)
                Text("Excelente! Você acertou!").font(.headline)
                Spacer()
            }.foregroundColor(.green)
            Button(action: { withAnimation { mostrarBannerCorreto = false } }) {
                Text("Continuar").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.green).cornerRadius(12)
            }
        }.padding(.horizontal, 24).padding(.top, 20).padding(.bottom, 34).background(Color(.fundo).shadow(color: Color.fundo.opacity(0.15), radius: 10, y: -5)).transition(.move(edge: .bottom))
    }
    
    private var bannerErro: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "xmark.circle.fill").font(.title2)
                Text("Resposta errada. Tente novamente!").font(.headline)
                Spacer()
            }.foregroundColor(.red)
            Button(action: {
                withAnimation { mostrarBannerErrado = false }
                NotificationCenter.default.post(name: NSNotification.Name("ResetarAtividade"), object: nil)
            }) {
                Text("Tentar Novamente").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.red).cornerRadius(12)
            }
        }.padding(.horizontal, 24).padding(.top, 20).padding(.bottom, 34).background(Color(.fundo).shadow(color: Color.fundo.opacity(0.15), radius: 10, y: -5)).transition(.move(edge: .bottom))
    }
}

// MARK: - Preview Oficial
#Preview {
    ZStack {
        if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
            NavigationStack {
                FluxoHistoriaEAtividadeView(idVersaoSelecionada: 101)
                    .modelContainer(
                        for: [
                            Responsavel.self, Crianca.self, Avatar.self,
                            Livro.self, LivroVersaoNivel.self, ConteudoLinha.self,
                            Trecho.self, Atividade.self, AtividadeMultiplaEscolha.self,
                            AtividadeDesembaralhar.self // 🚀 Nova tabela incluída também para o Preview funcionar localmente
                        ],
                        inMemory: true,
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
