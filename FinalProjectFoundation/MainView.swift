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
                        InserirSenhaView()
                    }
                }
            }
        }
        .tint(.roxoTab)
    }
}

// MARK: - Preview Oficial com todos os Modelos Injetados
#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        MainView()
            .modelContainer(
                for: [
                    Crianca.self, Responsavel.self, Avatar.self,
                    Livro.self, LivroVersaoNivel.self, ConteudoLinha.self,
                    Trecho.self, Atividade.self,
                    AtividadeMultiplaEscolha.self,
                    AtividadeDesembaralhar.self
                ],
                inMemory: true,
                sqliteDatabasePath: dbPath
            )
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado no Bundle", systemImage: "exclamationmark.triangle")
    }
}
