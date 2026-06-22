import SwiftUI
import SwiftData

// MULTIPLA ESCOLHA
struct OpcaoEmbaralhada: Identifiable {
    let id = UUID()
    let texto: String
    let eCorreta: Bool
}

struct ComponenteMultiplaEscolha: View {
    let idAtividade: Int
    let instrucao: String
    let multiplaEscolha: AtividadeMultiplaEscolha
    
    var onCorreto: (Int) -> Void
    var onErrado: () -> Void
    
    @State private var indiceSelecionado: Int? = nil
    @State private var travado = false
    
    // Estado que vai guardar a lista embaralhada gerada na inicialização do componente
    @State private var opcoesEmbaralhadas: [OpcaoEmbaralhada] = []
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(instrucao)
                .font(FontesDoApp.xBold(tamanho: 16))
                .foregroundColor(.roxoTab)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
                .padding(.bottom, 4)
            
            // Renderiza a lista a partir do estado embaralhado
            ForEach(Array(opcoesEmbaralhadas.enumerated()), id: \.element.id) { index, opcao in
                Button(action: {
                    guard !travado else { return }
                    
                    indiceSelecionado = index
                    travado = true
                    
                    // Validamos diretamente pela propriedade interna da opção clicada
                    if opcao.eCorreta {
                        onCorreto(idAtividade)
                    } else {
                        onErrado()
                    }
                }) {
                    HStack {
                        Text(opcao.texto)
                            .font(.body)
                            .foregroundColor(indiceSelecionado == index ? .white : .primary)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        indiceSelecionado == index
                        ? (opcao.eCorreta ? Color.green : Color.red)
                        : Color.sombra
                    )
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.sombra.opacity(0.2))
        .cornerRadius(12)
        .padding(.vertical, 10)
        // Gera o embaralhamento assim que o componente aparece na tela
        .onAppear {
            gerarOpcoesEmbaralhadas()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetarAtividade"))) { _ in
            // Se errou e clicou em tentar novamente, desmarca o botão e re-embaralha para um novo desafio!
            if let selecionado = indiceSelecionado, !opcoesEmbaralhadas[selecionado].eCorreta {
                indiceSelecionado = nil
                travado = false
                gerarOpcoesEmbaralhadas()
            }
        }
    }
    
    /// Função interna que mapeia as opções originais limpando strings e jogando o método `.shuffled()` nelas
    private func gerarOpcoesEmbaralhadas() {
        let listaOriginal = multiplaEscolha.listaDeOpcoes
        
        // Buscamos qual é o texto da resposta correta de forma segura com base no índice numérico salvo no banco
        let textoRespostaCorretaBanco = listaOriginal[safe: multiplaEscolha.respostaCorreta] ?? ""
        let respostaLimpaBanco = textoRespostaCorretaBanco.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        var temporario: [OpcaoEmbaralhada] = []
        
        for textoOpcao in listaOriginal {
            let opcaoLimpaDoLoop = textoOpcao.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            // Comparação blindada contra maiúsculas, minúsculas e espaços extras
            let correta = (opcaoLimpaDoLoop == respostaLimpaBanco)
            
            temporario.append(OpcaoEmbaralhada(texto: textoOpcao, eCorreta: correta))
        }
        
        // Aplica o embaralhamento nativo do Swift
        self.opcoesEmbaralhadas = temporario.shuffled()
    }
}

// 💡 Extensão auxiliar segura para evitar crash caso o índice de respostaCorreta do banco esteja corrompido
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


// DESEMBARALHAR
struct BlocoElemento: Identifiable, Equatable {
    let id = UUID()
    let texto: String
    let cor: Color // 🚀 Nova propriedade para fixar a cor sorteada
}

struct ComponenteDesembaralhar: View {
    let idAtividade: Int
    let instrucao: String
    let dadosDesembaralhar: AtividadeDesembaralhar
    
    var onCorreto: (Int) -> Void
    var onErrado: () -> Void
    
    // MARK: - Estados Locais
    @State private var elementosDisponiveis: [BlocoElemento] = []
    @State private var respostaDoUsuario: [BlocoElemento] = []
    @State private var travado = false
    @State private var mostrarErroVisual = false
    @State private var mostrarSucessoVisual = false
    
    // Grid adaptativo para se ajustar bem tanto com letras soltas quanto com palavras grandes
    private let colunasGrid = [GridItem(.adaptive(minimum: 70, maximum: 140), spacing: 8)]
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Enunciado da Atividade (Tabela Mãe)
            Text(instrucao)
                .font(FontesDoApp.xBold(tamanho: 16))
                .foregroundColor(.roxoTab)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
            
            // --- ÁREA DE CONSTRUÇÃO DA FRASE/PALAVRA ---
            VStack {
                if respostaDoUsuario.isEmpty {
                    Text("Toque nos blocos para responder")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.6))
                        .italic()
                        .frame(maxWidth: .infinity, minHeight: 45)
                } else {
                    // Exibe os blocos que a criança já selecionou
                    LazyVGrid(columns: colunasGrid, spacing: 8) {
                        ForEach(respostaDoUsuario) { bloco in
                            Button(action: {
                                guard !travado else { return }
                                removerBloco(bloco)
                            }) {
                                Text(bloco.texto)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    // 🚀 Texto preto/primary se a cor for clara, ou branco se for o roxoTab
                                    .foregroundColor((bloco.cor == .laranjaClaro || bloco.cor == .roxoTab) ? .white : .black)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(bloco.cor) // 🚀 Aplica a cor sorteada e mantida pelo bloco
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        mostrarErroVisual ? Color.red : (mostrarSucessoVisual ? Color.green : Color.roxoTab.opacity(0.3)),
                        lineWidth: 2
                    )
                    .background(Color.fundo.opacity(0.5))
            )
            .cornerRadius(12)
            
            // --- ÁREA DE BLOCOS DISPONÍVEIS ---
            LazyVGrid(columns: colunasGrid, spacing: 8) {
                ForEach(elementosDisponiveis) { bloco in
                    Button(action: {
                        guard !travado else { return }
                        adicionarBloco(bloco)
                    }) {
                        Text(bloco.texto)
                            .font(.body)
                            .fontWeight(.bold) // Mudei para bold para destacar mais nas cores claras
                            .foregroundColor((bloco.cor == .laranjaClaro || bloco.cor == .roxoTab) ? .white : .black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(minWidth: 60)
                            .background(bloco.cor) // 🚀 Aplica a cor sorteada aqui também
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 8)
            
            // --- BOTÃO LOCAL DE VERIFICAÇÃO ---
            if !respostaDoUsuario.isEmpty && !travado {
                Button(action: {
                    verificarResposta()
                }) {
                    Text("Verificar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.roxoTab)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(16)
        .background(Color.sombra.opacity(0.2))
        .cornerRadius(12)
        .padding(.vertical, 10)
        .onAppear {
            inicializarComponente()
        }
        // Escuta o "Tentar Novamente" do banner global
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetarAtividade"))) { _ in
            if mostrarErroVisual {
                withAnimation(.spring()) {
                    respostaDoUsuario.removeAll()
                    mostrarErroVisual = false
                    travado = false
                    inicializarComponente() // Re-embaralha para a nova tentativa
                }
            }
        }
    }
    
    // MARK: - Regras de Negócio e Ações
    
    private func inicializarComponente() {
        let listaOriginal = dadosDesembaralhar.listaDeElementos
        
        // 🚀 Lista das cores disponíveis no seu Assets
        let coresDisponiveis: [Color] = [.verdeClaro, .azulClaro, .amareloClaro, .laranjaClaro, .roxoTab]
        
        let blocosMapeados = listaOriginal.map { elemento in
            // Sorteia uma cor da lista (usa .roxoTab como fallback seguro)
            let corSorteada = coresDisponiveis.randomElement() ?? .roxoTab
            return BlocoElemento(texto: elemento, cor: corSorteada)
        }
        
        // Força o embaralhamento dos blocos ao carregar na tela
        self.elementosDisponiveis = blocosMapeados.shuffled()
    }
    
    private func adicionarBloco(_ bloco: BlocoElemento) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            respostaDoUsuario.append(bloco)
            elementosDisponiveis.removeAll(where: { $0.id == bloco.id })
        }
    }
    
    private func removerBloco(_ bloco: BlocoElemento) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            elementosDisponiveis.append(bloco)
            respostaDoUsuario.removeAll(where: { $0.id == bloco.id })
        }
    }
    
    private func verificarResposta() {
        travado = true
        
        // 1. Limpa espaços e quebras de linha tanto da resposta do banco quanto da montagem
        let respostaLimpaBanco = dadosDesembaralhar.respostaCorreta.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // 2. Descobre se é letra solta limpando os espaços invisíveis antes de contar os caracteres
        let eLetraSolta = dadosDesembaralhar.listaDeElementos.allSatisfy { elemento in
            let elementoLimpo = elemento.trimmingCharacters(in: .whitespacesAndNewlines)
            return elementoLimpo.count == 1
        }
        
        let stringMontada: String
        if eLetraSolta {
            // Junta grudado: "BOSQUE"
            stringMontada = respostaDoUsuario.map { $0.texto.trimmingCharacters(in: .whitespacesAndNewlines) }.joined()
        } else {
            // Junta com espaço (para o caso de frases)
            stringMontada = respostaDoUsuario.map { $0.texto.trimmingCharacters(in: .whitespacesAndNewlines) }.joined(separator: " ")
        }
        
        let respostaLimpaUsuario = stringMontada.lowercased()
        
        // 3. Validação
        if respostaLimpaUsuario == respostaLimpaBanco {
            withAnimation { mostrarSucessoVisual = true }
            onCorreto(idAtividade)
        } else {
            withAnimation { mostrarErroVisual = true }
            onErrado()
        }
    }
}
