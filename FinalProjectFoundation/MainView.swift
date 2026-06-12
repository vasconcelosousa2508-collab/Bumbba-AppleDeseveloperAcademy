import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Group {
                Tab("Livros", systemImage: "square.stack.3d.down.right.fill") {
                    BibliotecaView()
                }
                
                Tab("Você", systemImage: "star") {
                    ZStack {
                        Color.fundo.ignoresSafeArea()
                        Text("Perfil")
                    }
                }
                
                Tab("Responsável", systemImage: "person.fill") {
                    ZStack {
                        Color.fundo.ignoresSafeArea()
                        Text("Acesso Responsável")
                    }
                }
            }
        }
        .tint(.roxoTab)
    }
}

#Preview {
    MainView()
}
