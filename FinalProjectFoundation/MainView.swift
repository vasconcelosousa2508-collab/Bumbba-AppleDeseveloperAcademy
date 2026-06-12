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
                        Color.appFundo.ignoresSafeArea()
                        Text("Perfil")
                    }
                }
                
                Tab("Responsável", systemImage: "person.fill") {
                    ZStack {
                        Color.appFundo.ignoresSafeArea()
                        Text("Acesso Responsável")
                    }
                }
            }
        }
        .tint(.appRoxoTab)
    }
}

#Preview {
    MainView()
}
