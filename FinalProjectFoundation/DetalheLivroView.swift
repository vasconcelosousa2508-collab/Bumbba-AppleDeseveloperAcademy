import SwiftUI

struct DetalheLivroView: View {
    let livro: Livro2
    let faixaEtaria: String
    
    // Para permitir voltar à tela anterior quando o botão "Concluir História" for pressionado
    @Environment(\.dismiss) var dismiss
    
    // Obtém a sequência misturada de textos e atividades para a idade selecionada
    var elementosDoLivro: [ElementoHistoria] {
        livro.conteudoPorIdade[faixaEtaria] ?? []
    }
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // APENAS ESTE BLOCO ROLA NA TELA
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        Spacer().frame(height: 10) // Pequeno respiro inicial antes da história
                        
                        // Loop Principal da História Intercalada (Corrigido com id)
                        ForEach(elementosDoLivro, id: \.id) { elemento in
                            
                            // 1. Se for texto da estrofe
                            if let textoEstrofe = elemento.texto {
                                Text(textoEstrofe)
                                    .font(FontesDoApp.x(tamanho: 22))
                                    .foregroundColor(.primary)
                                    .lineSpacing(10)
                                    .padding(.horizontal, 25)
                            }
                            
                            // 2. Se for uma Atividade Intercalada
                            if let atividade = elemento.atividade {
                                switch atividade.tipo {
                                case .seguirPontilhado:
                                    AtividadePontilhadoView()
                                    
                                case .multiplaEscolha(let pergunta, let opcoes, let resposta):
                                    AtividadeMultiplaEscolhaView(pergunta: pergunta, opcoes: opcoes, respostaCorreta: resposta)
                                    
                                case .desembaralharLetras(let palavra, let letras):
                                    AtividadeLetrasView(palavraCerta: palavra, letrasEmbaralhadas: letras)
                                    
                                case .desembaralharFrase(let frase, let palavras):
                                    AtividadeFraseView(fraseCerta: frase, palavrasEmbaralhadas: palavras)
                                }
                            }
                        }
                        
                        Spacer().frame(height: 20)
                        
                        // BOTÃO DE CONCLUIR HISTÓRIA (Ao final da rolagem, estilo BiblioAgeView)
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 10) {
                                Text("Concluir História")
                                    .font(FontesDoApp.x(tamanho: 16))
                            }
                            .foregroundColor(.white)
                            .frame(width: 320, height: 50)
                            .background(Color.roxoTab)
                            .cornerRadius(100)
                            .opacity(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Centraliza o botão na tela
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        // Define o modo inline para o título ficar centralizado na barra ao lado da seta padrão
        .navigationBarTitleDisplayMode(.inline)
        // Injeta o seu estilo customizado de texto exatamente na posição do título nativo
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(livro.titulo)
                    .font(FontesDoApp.xBold(tamanho: 20)) // Fonte Fredoka Bold
                    .foregroundColor(.roxoTab)          // Cor rosa/roxo do seu app
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetalheLivroView(livro: DadosManuais.listaLivros[0], faixaEtaria: "6 a 7")
    }
}
