import SwiftUI

struct BibliotecaView: View {
    let colunas = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var idadeSelecionada = "4 a 5"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fundo.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("Biblioteca")
                                .font(FontesDoApp.xBold(tamanho: 32))
                                .foregroundColor(.roxoTab)
                            
                            Spacer()
                            
                            NavigationLink(destination: BiblioAgeView(idadeSelecionada: $idadeSelecionada)) {
                                HStack(spacing: 10) {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.system(size: 12, weight: .bold))
                                    Text(idadeSelecionada + " anos")
                                        .font(FontesDoApp.x(tamanho: 16))
                                }
                                .foregroundColor(.white)
                                .frame(width: 130, height: 35)
                                .background(Color.roxoEscuroBnt)
                                .cornerRadius(100)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 45)
                        
                        LazyVGrid(columns: colunas, spacing: 20) {
                            // Puxando direto dos dados manuais configurados no Models
                            ForEach(DadosManuais.listaLivros) { livro in
                                // Enviando o livro E a idade selecionada para o Detalhe
                                NavigationLink(destination: DetalheLivroView(livro: livro, faixaEtaria: idadeSelecionada)) {
                                    VStack(spacing: 12) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.sombra)
                                            .frame(width: 170, height: 170)
                                            .overlay(
                                                Image(systemName: "book.closed.fill")
                                                    .font(.system(size: 38))
                                                    .foregroundColor(.roxoTab.opacity(0.6))
                                            )
                                        
                                        Text(livro.titulo)
                                            .font(FontesDoApp.x(tamanho: 16))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .frame(height: 40)
                                    }
                                    .padding(10)
                                    .background(Color.fundo)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    BibliotecaView()
}
