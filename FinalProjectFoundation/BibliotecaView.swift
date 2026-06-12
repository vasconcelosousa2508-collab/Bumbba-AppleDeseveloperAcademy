import SwiftUI

struct BibliotecaView: View {
    let colunas = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fundo.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("Biblioteca")
                                .font(FontesDoApp.xBold(tamanho: 32))
                                .foregroundColor(.appRoxoTab)
                            
                            Spacer()
                            
                            // Correção: Substituído Button por NavigationLink
                            NavigationLink(destination: BiblioAgeView()) {
                                HStack(spacing: 10) {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.system(size: 12, weight: .bold))
                                    Text("Idade")
                                        .font(FontesDoApp.x(tamanho: 16))
                                }
                                .foregroundColor(.white)
                                .frame(width: 100, height: 35)
                                .background(Color.appRoxoEscuroBtn)
                                .cornerRadius(100)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 45)
                        
                        // Grid de Livros / Itens
                        LazyVGrid(columns: colunas, spacing: 20) {
                            ForEach(0..<5) { index in
                                Button(action: {
                                    print("Botão \(index) pressionado")
                                }) {
                                    Text("")
                                        .font(FontesDoApp.xBold(tamanho: 18))
                                        .foregroundColor(.white)
                                        .frame(width: 170, height: 170)
                                        .background(Color.appSombra)
                                        .cornerRadius(12)
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
