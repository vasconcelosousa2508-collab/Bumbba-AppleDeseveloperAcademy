import SwiftUI
import SwiftData
import SwiftDataSQLite

struct MainView: View {
    var body: some View {
        TabView {
            Group {
                Tab("Livros", systemImage: "square.stack.3d.down.right.fill") {
                    BibliotecaView()
                }
                
                Tab("Você", systemImage: "star") {
                    ZStack {
                        PerfilView()
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
        .modelContainer(
            for: [Livro.self],
            inMemory: true,
            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
        )
}
