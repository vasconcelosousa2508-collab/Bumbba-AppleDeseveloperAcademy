import SwiftUI
import SwiftData

struct AtividadeTesteView: View {
    var atividade: Atividade
    
    @Query var todosOsDetalhesME: [AtividadeMultiplaEscolha]
    
    // Estados locais para controlar o jogo atualizado
    @State private var opcoesExibição: [String] = []
    @State private var gabaritoTexto: String = ""
    @State private var opcaoSelecionada: String? = nil
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Cabeçalho / Categoria
                Text(atividade.categoria.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.sombra)
                    .cornerRadius(8)
                
                // Enunciado (Vem da tabela Atividade)
                Text(atividade.instrucao)
                    .font(FontesDoApp.xBold(tamanho: 22))
                    .foregroundColor(.roxoTab)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Card com as Opções Embaralhadas
                VStack(spacing: 14) {
                    ForEach(opcoesExibição, id: \.self) { opcao in
                        Button(action: {
                            opcaoSelecionada = opcao
                        }) {
                            HStack {
                                Text(opcao)
                                    .font(FontesDoApp.x(tamanho: 16))
                                    .foregroundColor(.primary)
                                Spacer()
                                
                                // Validação visual baseada no TEXTO correto, não no índice
                                if opcaoSelecionada == opcao {
                                    Image(systemName: opcao == gabaritoTexto ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(opcao == gabaritoTexto ? .green : .red)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                opcaoSelecionada == opcao ? Color.roxoTab.opacity(0.15) : Color.sombra.opacity(0.4)
                            )
                            .cornerRadius(12)
                        }
                        // Desabilita os botões após o clique para a criança não ficar trocando
                        .disabled(opcaoSelecionada != nil)
                    }
                }
                .padding()
                .background(Color.fundo)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
                .padding(.horizontal, 20)
                
                // Botão de reiniciar o teste (para ver o embaralhamento funcionar de novo)
                if opcaoSelecionada != nil {
                    Button("Tentar Novamente") {
                        carregarConfiguracaoDoJogo()
                    }
                    .font(FontesDoApp.xBold(tamanho: 16))
                    .foregroundColor(.roxoTab)
                    .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .onAppear {
            carregarConfiguracaoDoJogo()
        }
    }
    
    // MARK: - Função de Carga Única
    private func carregarConfiguracaoDoJogo() {
        opcaoSelecionada = nil
        
        // Encontra a linha correspondente na tabela filha
        if let detalhe = todosOsDetalhesME.first(where: { $0.idAtividade == atividade.id }),
           let jogoConfigurado = detalhe.prepararJogo() {
            self.opcoesExibição = jogoConfigurado.opcoesEmbaralhadas
            self.gabaritoTexto = jogoConfigurado.textoCorreto
        }
    }
}


