//import SwiftUI
//import SwiftData
//import SwiftDataSQLite
//
//struct AtividadeTesteDebugView: View {
//    let idAtividade: Int
//    
//    @Query var todasAtividades: [Atividade]
//    @Query var todasMultiplaEscolhas: [AtividadeMultiplaEscolha]
//    
//    // Estados de controle da interface
//    @State private var indiceSelecionado: Int? = nil
//    @State private var mostrarAviso = false
//    @State private var acertouResposta = false
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            // Define a cor de fundo geral da View vinda dos seus Assets
//            Color.fundo.ignoresSafeArea()
//            
//            // Conteúdo Principal
//            List {
//                ForEach(todasAtividades) { atividade in
//                    VStack(alignment: .center, spacing: 20) { // 💡 Alinhamento centralizado na VStack
//                        if let multiplaEscolha = atividadeFilha(atividade) {
//                            
//                            // 💡 Enunciado Centralizado com margem interna
//                            Text("\(multiplaEscolha.instrucao)")
//                                .font(FontesDoApp.xBold(tamanho: 16))
//                                .foregroundColor(.roxoTab)
//                                .multilineTextAlignment(.center) // Garante a centralização se quebrar linha
//                                .frame(maxWidth: .infinity, alignment: .center) // Força o container a centralizar
//                                .padding(.top, 8)
//                                .padding(.bottom, 4)
//                            
//                            ForEach(Array(multiplaEscolha.listaDeOpcoes.enumerated()), id: \.offset) { index, opcao in
//                                Button(action: {
//                                    // Só permite o clique se o aviso não estiver na tela
//                                    guard !mostrarAviso else { return }
//                                    
//                                    indiceSelecionado = index
//                                    acertouResposta = (index == multiplaEscolha.respostaCorreta)
//                                    
//                                    // Sobe a barra estilo Duolingo com animação
//                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                                        mostrarAviso = true
//                                    }
//                                }) {
//                                    HStack {
//                                        Text("\(opcao)")
//                                            .font(.body)
//                                            .foregroundColor(indiceSelecionado == index ? .white : .primary)
//                                        Spacer()
//                                    }
//                                    .padding()
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .background(
//                                        indiceSelecionado == index
//                                        ? (index == multiplaEscolha.respostaCorreta ? Color.green : Color.red)
//                                        : Color.sombra
//                                    )
//                                    .cornerRadius(8)
//                                }
//                                .buttonStyle(.plain)
//                            }
//                        } else {
//                            Text("Sem dados de múltipla escolha para esta ID.")
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                        }
//                    }
//                    .padding(.horizontal, 16) // 💡 Margem lateral adicionada para afastar das bordas do iPhone
//                    .padding(.vertical, 8)
//                    // Remove o fundo padrão branco de cada célula da lista
//                    .listRowBackground(Color.clear)
//                    .listRowSeparator(.hidden)
//                }
//            }
//            .listStyle(.plain)
//            // Esconde o fundo padrão cinza/branco da List para revelar o Color.fundo do ZStack
//            .scrollContentBackground(.hidden)
//            
//            // ==========================================
//            // BANNERS ESTILO DUOLINGO (SOBE DO BOTTOM)
//            // ==========================================
//            if mostrarAviso {
//                VStack(spacing: 16) {
//                    HStack(spacing: 12) {
//                        Image(systemName: acertouResposta ? "checkmark.circle.fill" : "xmark.circle.fill")
//                            .font(.title)
//                        
//                        Text(acertouResposta ? "Excelente! Você acertou!" : "Resposta errada")
//                            .font(.headline)
//                        
//                        Spacer()
//                    }
//                    .foregroundColor(acertouResposta ? .green : .red)
//                    
//                    // Botão dinâmico baseado no acerto/erro
//                    Button(action: {
//                        if acertouResposta {
//                            // Ação de avançar para a próxima tela
//                            withAnimation { mostrarAviso = false }
//                        } else {
//                            // Tentar Novamente: limpa o erro para o usuário escolher outra
//                            withAnimation(.easeOut(duration: 0.2)) {
//                                mostrarAviso = false
//                                indiceSelecionado = nil
//                            }
//                        }
//                    }) {
//                        Text(acertouResposta ? "Continuar" : "Tentar Novamente")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(acertouResposta ? Color.green : Color.red)
//                            .cornerRadius(12)
//                    }
//                }
//                .padding(.horizontal, 24)
//                .padding(.top, 24)
//                .padding(.bottom, 34) // Margem de segurança para a Dynamic Island/Home Indicator do iPhone
//                .background(
//                    Color(.roxoEscuroBnt)
//                        .shadow(color: Color.black.opacity(0.15), radius: 10, y: -5)
//                )
//                .transition(.move(edge: .bottom)) // Define que a animação surge de baixo
//            }
//        }
//        .onChange(of: idAtividade) { _, _ in
//            indiceSelecionado = nil
//            mostrarAviso = false
//        }
//    }
//    
//    func atividadeFilha(_ atividade: Atividade) -> AtividadeMultiplaEscolha? {
//        todasMultiplaEscolhas.first(where: { $0.idAtividade == atividade.id })
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    ZStack {
//        if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
//            NavigationStack {
//                AtividadeTesteDebugView(idAtividade: 1)
//                    .modelContainer(
//                        for: [
//                            Responsavel.self, Crianca.self, Avatar.self,
//                            Livro.self, LivroVersaoNivel.self, ConteudoLinha.self,
//                            Trecho.self, Atividade.self, AtividadeMultiplaEscolha.self
//                        ],
//                        inMemory: false,
//                        sqliteDatabasePath: dbPath
//                    )
//            }
//        } else {
//            ContentUnavailableView("Banco não encontrado", systemImage: "xmark.rectangle")
//        }
//    }
//}
