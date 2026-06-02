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
    var body: some View {
        NavigationStack {
            VStack {
                Text("Livros")
            }
            .navigationTitle("Biblioteca")
            .toolbar {
            }
        }
    }
}

#Preview {
    BibliotecaView()
}
