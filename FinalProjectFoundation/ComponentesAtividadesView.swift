import SwiftUI
import SwiftData

struct ComponenteMultiplaEscolha: View {
    let idAtividade: Int // 💡 Recebe o ID para repassar nos callbacks
    let multiplaEscolha: AtividadeMultiplaEscolha
    
    var onCorreto: (Int) -> Void // Retorna o ID resolvido
    var onErrado: () -> Void
    
    @State private var indiceSelecionado: Int? = nil
    @State private var travado = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("\(multiplaEscolha.instrucao)")
                .font(FontesDoApp.xBold(tamanho: 16))
                .foregroundColor(.roxoTab)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
                .padding(.bottom, 4)
            
            ForEach(Array(multiplaEscolha.listaDeOpcoes.enumerated()), id: \.offset) { index, opcao in
                Button(action: {
                    guard !travado else { return }
                    
                    indiceSelecionado = index
                    travado = true
                    
                    if index == multiplaEscolha.respostaCorreta {
                        onCorreto(idAtividade)
                    } else {
                        onErrado()
                    }
                }) {
                    HStack {
                        Text("\(opcao)")
                            .font(.body)
                            .foregroundColor(indiceSelecionado == index ? .white : .primary)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        indiceSelecionado == index
                        ? (index == multiplaEscolha.respostaCorreta ? Color.green : Color.red)
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
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetarAtividade"))) { _ in
            if indiceSelecionado != multiplaEscolha.respostaCorreta {
                indiceSelecionado = nil
                travado = false
            }
        }
    }
}
