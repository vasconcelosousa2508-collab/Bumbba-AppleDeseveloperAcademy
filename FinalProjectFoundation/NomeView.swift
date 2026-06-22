import SwiftUI
import SwiftData
import SwiftDataSQLite

struct NomeView: View {
    @State private var texto: String = ""
    
    private var estaVazio: Bool {
        texto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fundo.ignoresSafeArea()
                
                VStack {
                    Image("rostoBoi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230, height: 230)
                        .padding(20)
                        .padding(.top, 30)
                    
                    VStack(spacing: 25) {
                        Text("Qual o nome da sua criança?")
                            .font(FontesDoApp.xBold(tamanho: 32))
                            .foregroundColor(.roxoTab)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding()
                        
                        TextField("Digite um nome...", text: $texto)
                            .font(FontesDoApp.x(tamanho: 20))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 23)
                                    .stroke(Color.primary, lineWidth: 1)
                                    .background(Color.fundo.cornerRadius(15))
                            )
                            .padding(.horizontal, 40)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // 🚀 PASSO 1: Enviando o nome digitado para a tela de Idade
                    NavigationLink(destination: IdadeView(nomeDaCrianca: texto.trimmingCharacters(in: .whitespacesAndNewlines))) {
                        Text("Confirmar")
                            .font(FontesDoApp.x(tamanho: 16))
                            .foregroundColor(.white)
                            .frame(width: 320, height: 50)
                            .background(Color.roxoTab.cornerRadius(100))
                    }
                    .disabled(estaVazio)
                    .opacity(estaVazio ? 0.4 : 1.0)
                    .padding(.bottom, 20)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: texto)
    }
}

#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        NomeView()
            .modelContainer(
                for: [
                    Crianca.self, Responsavel.self, Avatar.self,
                    Livro.self, LivroVersaoNivel.self, ConteudoLinha.self,
                    Trecho.self, Atividade.self,
                    AtividadeMultiplaEscolha.self,
                    AtividadeDesembaralhar.self
                ],
                inMemory: false,
                sqliteDatabasePath: dbPath
            )
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado no Bundle", systemImage: "exclamationmark.triangle")
    }
}
