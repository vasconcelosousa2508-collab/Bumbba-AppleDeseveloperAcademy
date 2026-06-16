import SwiftUI

// --- 1. ATIVIDADE: SEGUIR PONTILHADO ---
struct AtividadePontilhadoView: View {
    @State private var progressoPainel: CGFloat = 0.0 // Simulador visual
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Siga o caminho pontilhado com o dedo para ladrilhar a rua:")
                .font(FontesDoApp.xBold(tamanho: 18)) // 👈 Enunciado padronizado
                .foregroundColor(.roxoTab)            // 👈 Cor Rosa
                .multilineTextAlignment(.center)      // 👈 Texto centralizado se quebrar linha
                .frame(maxWidth: .infinity, alignment: .center) // 👈 Centraliza na tela
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.sombra.opacity(0.3))
                    .frame(height: 120)
                
                Path { path in
                    path.move(to: CGPoint(x: 30, y: 60))
                    path.addQuadCurve(to: CGPoint(x: 310, y: 60), control: CGPoint(x: 170, y: 10))
                }
                .stroke(Color.roxoTab, style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [8]))
                
                Text("[ Arraste o dedo aqui ]")
                    .font(FontesDoApp.x(tamanho: 12))
                    .foregroundColor(.secondary)
                    .offset(y: 40)
            }
        }
        .cardEstiloAtividade()
    }
}

// --- 2. ATIVIDADE: MÚLTIPLA ESCOLHA ---
struct AtividadeMultiplaEscolhaView: View {
    let pergunta: String
    let opcoes: [String]
    let respostaCorreta: String
    @State private var opcaoSelecionada: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(pergunta)
                .font(FontesDoApp.xBold(tamanho: 18)) // 👈 Enunciado padronizado
                .foregroundColor(.roxoTab)            // 👈 Cor Rosa
                .multilineTextAlignment(.center)      // 👈 Texto centralizado se quebrar linha
                .frame(maxWidth: .infinity, alignment: .center) // 👈 Centraliza na tela
            
            ForEach(opcoes, id: \.self) { opcao in
                Button(action: { opcaoSelecionada = opcao }) {
                    HStack {
                        Text(opcao)
                            .font(FontesDoApp.x(tamanho: 16))
                            .foregroundColor(.primary)
                        Spacer()
                        if opcaoSelecionada == opcao {
                            Image(systemName: opcao == respostaCorreta ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(opcao == respostaCorreta ? .green : .red)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(opcaoSelecionada == opcao ? Color.roxoTab.opacity(0.15) : Color.sombra.opacity(0.4))
                    .cornerRadius(10)
                }
            }
        }
        .cardEstiloAtividade()
    }
}

// --- 3. ATIVIDADE: DESEMBARALHAR LETRAS ---
struct AtividadeLetrasView: View {
    let palavraCerta: String
    let letrasEmbaralhadas: [String]
    @State private var letrasColocadas: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Toque nas letras para formar a palavra secreta:")
                .font(FontesDoApp.xBold(tamanho: 18)) // 👈 Enunciado padronizado
                .foregroundColor(.roxoTab)            // 👈 Cor Rosa
                .multilineTextAlignment(.center)      // 👈 Texto centralizado se quebrar linha
                .frame(maxWidth: .infinity, alignment: .center) // 👈 Centraliza na tela
            
            HStack(spacing: 10) {
                ForEach(0..<palavraCerta.count, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.roxoTab, lineWidth: 2)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(letrasColocadas.indices.contains(i) ? letrasColocadas[i] : "")
                                .font(FontesDoApp.xBold(tamanho: 20))
                        )
                }
                
                if !letrasColocadas.isEmpty {
                    Button(action: { letrasColocadas.removeAll() }) {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .foregroundColor(.roxoTab)
                            .font(.title2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center) // Centraliza os blocos de resposta
            .padding(.vertical, 5)
            
            HStack(spacing: 12) {
                ForEach(letrasEmbaralhadas, id: \.self) { letra in
                    Button(action: {
                        if letrasColocadas.count < palavraCerta.count {
                            letrasColocadas.append(letra)
                        }
                    }) {
                        Text(letra)
                            .font(FontesDoApp.xBold(tamanho: 18))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color.roxoEscuroBnt)
                            .cornerRadius(100)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center) // Centraliza as opções de letras do jogo
        }
        .cardEstiloAtividade()
    }
}

// --- 4. ATIVIDADE: DESEMBARALHAR FRASE ---
struct AtividadeFraseView: View {
    let fraseCerta: String
    let palavrasEmbaralhadas: [String]
    @State private var fraseConstruida: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Organize as palavras na ordem correta da música:")
                .font(FontesDoApp.xBold(tamanho: 18)) // 👈 Enunciado padronizado
                .foregroundColor(.roxoTab)            // 👈 Cor Rosa
                .multilineTextAlignment(.center)      // 👈 Texto centralizado se quebrar linha
                .frame(maxWidth: .infinity, alignment: .center) // 👈 Centraliza na tela
            
            Text(fraseConstruida.joined(separator: " "))
                .font(FontesDoApp.xBold(tamanho: 18))
                .foregroundColor(.roxoTab)
                .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
                .padding(10)
                .background(Color.sombra.opacity(0.3))
                .cornerRadius(8)
            
            FlowLayoutGrid(items: palavrasEmbaralhadas) { palavra in
                Button(action: {
                    if !fraseConstruida.contains(palavra) {
                        fraseConstruida.append(palavra)
                    }
                }) {
                    Text(palavra)
                        .font(FontesDoApp.x(tamanho: 14))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.roxoEscuroBnt.opacity(fraseConstruida.contains(palavra) ? 0.4 : 1.0))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
            
            if !fraseConstruida.isEmpty {
                Button("Limpar Frase") { fraseConstruida.removeAll() }
                    .font(FontesDoApp.x(tamanho: 12))
                    .foregroundColor(.red)
            }
        }
        .cardEstiloAtividade()
    }
}

extension View {
    func cardEstiloAtividade() -> some View {
        self.padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.fundo)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            .padding(.horizontal, 20)
    }
}

// Grid adaptável corrigida para quebra automática de palavras
struct FlowLayoutGrid<Content: View>: View {
    let items: [String]
    let content: (String) -> Content
    
    let colunas = [
        GridItem(.adaptive(minimum: 80, maximum: 160), spacing: 8)
    ]
    
    var body: some View {
        LazyVGrid(columns: colunas, alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}
