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

// MARK: - Preview Corrigido com todos os Modelos e Lendo o SQLite Real
#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        MainView()
            .modelContainer(
                for: [
                    // Modelos da sua Main/Perfil
                    Crianca.self, Responsavel.self, Avatar.self,
                    // Modelos cruciais da Biblioteca e Leitura
                    Livro.self, LivroVersaoNivel.self, ConteudoLinha.self, Trecho.self, Atividade.self
                ],
                inMemory: false, // OBRIGATÓRIO false para ler o arquivo do dbPath
                sqliteDatabasePath: dbPath
            )
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado no Bundle", systemImage: "exclamationmark.triangle")
    }
}
