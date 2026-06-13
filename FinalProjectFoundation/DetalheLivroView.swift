import SwiftUI

struct DetalheLivroView: View {
    let livro: Livro
    let faixaEtaria: String
    
    // Propriedade computada para pegar as frases certas com base na idade
    var paragrafosDaHistoria: [String] {
        livro.textosPorIdade[faixaEtaria] ?? ["Nenhum texto cadastrado para esta idade."]
    }
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {
                    
                    // Cabeçalho com Título e a Indicação da Idade atual
                    VStack(alignment: .leading, spacing: 8) {
                        Text(livro.titulo)
                            .font(FontesDoApp.xBold(tamanho: 28))
                            .foregroundColor(.roxoTab)
                        
                        Text("Modo de leitura: \(faixaEtaria) anos")
                            .font(FontesDoApp.x(tamanho: 14))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Lista Dinâmica Manual (Varre os textos do nível escolhido)
                    ForEach(paragrafosDaHistoria, id: \.self) { paragrafo in
                        Text(paragrafo)
                            .font(FontesDoApp.x(tamanho: 20))
                            .foregroundColor(.primary)
                            .lineSpacing(8)
                            .padding(.horizontal, 20)
                    }
                    
                    // Elemento estático visual de atividade para compor o layout
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("🎯 Atividade Integrada")
                                .font(FontesDoApp.xBold(tamanho: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.roxoEscuroBnt)
                                .cornerRadius(8)
                            Spacer()
                        }
                        
                        Text("O que você achou dessa parte da história? Faça um lindo desenho!")
                            .font(FontesDoApp.xBold(tamanho: 18))
                            .foregroundColor(.black)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .frame(height: 150)
                            .overlay(
                                Text("[ Área de desenho da criança ]")
                                    .font(FontesDoApp.x(tamanho: 14))
                                    .foregroundColor(.gray)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                }
            }
        }
    }
}

#Preview {
    // Preview mockado passando o primeiro livro na idade padrão
    DetalheLivroView(livro: DadosManuais.listaLivros[0], faixaEtaria: "4 a 5")
}
