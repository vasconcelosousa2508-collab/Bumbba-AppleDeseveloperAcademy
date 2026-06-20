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
    @Query var todasAsVersoes: [LivroVersaoNivel]
    @Query var todosOsLivros: [Livro]
    
    // Banners Inferiores
    @State private var mostrarBannerCorreto = false
    @State private var mostrarBannerErrado = false
    
    // 💡 Controle de validação: Rastreia quais IDs de atividades foram respondidos com sucesso
    @State private var atividadesResolvidas: [Int: Bool] = [:]
    
    var linhasDaVersao: [ConteudoLinha] {
        todasAsLinhas.filter { "\($0.idVersao)" == "\(idVersaoSelecionada)" }
    }
    
    // 💡 Lista de todas as atividades obrigatórias que pertencem especificamente a esta versão
    var idsAtividadesObrigatorias: [Int] {
        linhasDaVersao.compactMap { $0.idAtividade }
    }
    
    // 💡 Computed property que diz se TODAS as atividades obrigatórias foram concluídas
    var todasAtividadesConcluidas: Bool {
        guard !idsAtividadesObrigatorias.isEmpty else { return true } // Se não houver desafios, libera direto
        return idsAtividadesObrigatorias.allSatisfy { atividadesResolvidas[$0] == true }
    }
    
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
                List {
                    ForEach(linhasDaVersao) { linha in
                        
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
                        
                        else if let idAtividade = linha.idAtividade,
                                let atividade = todasAtividades.first(where: { $0.id == idAtividade }),
                                let multiplaEscolha = todasMultiplaEscolhas.first(where: { $0.idAtividade == atividade.id }) {
                            
                            ComponenteMultiplaEscolha(
                                idAtividade: atividade.id, // 💡 Repassa o id único
                                multiplaEscolha: multiplaEscolha,
                                onCorreto: { id in
                                    // Marca a atividade como resolvida no dicionário
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
                    
                    // ==========================================
                    // BOTÃO CONCLUIR (BLOQUEADO/DYNAMIC)
                    // ==========================================
                    Button(action: {
                        if todasAtividadesConcluidas {
                            dismiss()
                        }
                    }) {
                        Text(todasAtividadesConcluidas ? "Concluir Jornada" : "Responda os desafios para concluir")
                            .font(FontesDoApp.x(tamanho: 16))
                            .foregroundColor(.white)
                            .frame(width: 320, height: 50)
                            // Fica roxo se liberado, senão assume tom cinza opaco de indisponível
                            .background(todasAtividadesConcluidas ? Color.roxoTab : Color.gray.opacity(0.4))
                            .cornerRadius(100)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .disabled(!todasAtividadesConcluidas) // Bloqueia a ação de clique se não concluiu tudo
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .disabled(mostrarBannerCorreto || mostrarBannerErrado)
            }
            
            // BANNER INFERIOR - CORRETO (VERDE)
            if mostrarBannerCorreto {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                        Text("Excelente! Você acertou!")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundColor(.green)
                    
                    Button(action: {
                        withAnimation { mostrarBannerCorreto = false }
                    }) {
                        Text("Continuar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 34)
                .background(Color(.fundo).shadow(color: Color.fundo.opacity(0.15), radius: 10, y: -5))
                .transition(.move(edge: .bottom))
            }
            
            // BANNER INFERIOR - ERRADO (VERMELHO)
            if mostrarBannerErrado {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                        Text("Resposta errada. Tente novamente!")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundColor(.red)
                    
                    Button(action: {
                        withAnimation { mostrarBannerErrado = false }
                        NotificationCenter.default.post(name: NSNotification.Name("ResetarAtividade"), object: nil)
                    }) {
                        Text("Tentar Novamente")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 34)
                .background(Color(.fundo).shadow(color: Color.fundo.opacity(0.15), radius: 10, y: -5))
                .transition(.move(edge: .bottom))
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
