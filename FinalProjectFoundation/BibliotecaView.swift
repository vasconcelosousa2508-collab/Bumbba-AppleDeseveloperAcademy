import SwiftUI

//struct BibliotecaView : View {
//    var body: some View {
//        TabView {
//            Group {
//                Tab("Livros", systemImage: "square.stack.3d.down.right.fill") {
//                    ZStack {
//                        Color.fundo.ignoresSafeArea()
//                        VStack {
//                            Text("Biblioteca")
//                        }
//                    }
//                }
//                Tab("Você", systemImage: "star") {
//                    ZStack {
//                        Color.fundo.ignoresSafeArea()
//                        VStack {
//                            Text("Perfil")
//                        }
//                    }
//                }
//                Tab("Responsável", systemImage: "person.fill") {
//                    ZStack {
//                        Color.fundo.ignoresSafeArea()
//                        VStack {
//                            Text("Acesso Responsável")
//                        }
//                    }
//                }
//            }
//        }
//        .tint(.roxoTab)
//    }
//}


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
                    LazyVGrid(columns: colunas, spacing: 16) {
                        ForEach(0..<5) { index in
                            Button(action: {
                                print("Botão \(index + 1) pressionado")
                            }) {
                                Text("Botão \(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    // Mudamos de 180 para 170 para caber a margem na tela
                                    .frame(width: 170, height: 170)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    // Essa margem afasta a grade inteira das bordas da tela
                    .padding(.horizontal, 16)
                    .padding(.top, 10)


                }
            }
            .navigationTitle("Biblioteca")
        }
    }
}

#Preview {
    BibliotecaView()
}
