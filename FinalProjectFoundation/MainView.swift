import SwiftUI
import SwiftData
import SwiftDataSQLite

struct MainView: View {
    // 🪙 Guarda o perfil ativo na sessão do app. Se for nil, mostra o seletor.
    @State private var criancaSelecionada: Crianca? = nil
    
    var body: some View {
        Group {
            if let criancaAtiva = criancaSelecionada {
                // Se tem criança selecionada, exibe o app dela
                TabView {
                    Group {
                        Tab("Livros", systemImage: "square.stack.3d.down.right.fill") {
                            // 🟢 CORRIGIDO: Usando 'criancaAtiva' e injetando via Environment
                            BibliotecaView()
                        }
                        
                        Tab("Você", systemImage: "star") {
                            ZStack {
                                // 🟢 CORRIGIDO: Usando 'criancaAtiva' e injetando via Environment
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
                // 🚀 Isso disponibiliza a criança ativa para TODAS as telas de dentro do TabView automaticamente
                .environment(\.criancaAtiva, criancaAtiva)
                .environment(\.perfilAtivo, $criancaSelecionada)
            } else {
                // 🎬 Se não tem perfil ativo, exibe a tela estilo Netflix
                SeletorPerfilView(perfilSelecionado: $criancaSelecionada)
            }
        }
    }
}

// 🚀 Chaves de ambiente para que qualquer tela filha consiga acessar a criança logada e o seletor
struct CriancaAtivaKey: EnvironmentKey {
    static let defaultValue: Crianca? = nil
}

struct PerfilAtivoKey: EnvironmentKey {
    static let defaultValue: Binding<Crianca?> = .constant(nil)
}

extension EnvironmentValues {
    var criancaAtiva: Crianca? {
        get { self[CriancaAtivaKey.self] }
        set { self[CriancaAtivaKey.self] = newValue }
    }
    var perfilAtivo: Binding<Crianca?> {
        get { self[PerfilAtivoKey.self] }
        set { self[PerfilAtivoKey.self] = newValue }
    }
}

// MARK: - Preview Oficial
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
