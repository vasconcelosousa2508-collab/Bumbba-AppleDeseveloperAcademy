import SwiftUI
import SwiftData

struct DefinirSenhaView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("usuarioJaCadastrado") private var usuarioJaCadastrado = false // Flag de controle de fluxo do app
    
    // 🚀 Dados vindos do fluxo anterior
    let nomeDaCrianca: String
    let idadeDaCrianca: Int
    
    @State private var texto: String = ""
    @State private var navegarParaMain = false // Controla o gatilho da navegação após salvar
    
    private var estaVazio: Bool {
        texto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack {
                Image(systemName: "figure.and.child.holdinghands")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .padding(20)
                    .padding(.top, 70)
                    .foregroundColor(.roxoTab)
                    .opacity(0.8)
                
                VStack(spacing: 25) {
                    Text("Defina sua senha de responsável")
                        .font(FontesDoApp.xBold(tamanho: 32))
                        .foregroundColor(.roxoTab)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding()
                    
                    // Recomendo SecureField para senhas no futuro, mas mantive o TextField do seu design
                    TextField("Digite uma senha...", text: $texto)
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
                
                // 🚀 Botão com Lógica de Banco de Dados
                Button(action: salvarDadosNoBanco) {
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
        .animation(.easeInOut(duration: 0.2), value: texto)
        // Destino invisível que dispara ao concluir com sucesso o banco
        .navigationDestination(isPresented: $navegarParaMain) {
            MainView()
        }
    }
    
    // 🔥 LÓGICA DE SALVAMENTO NO SWIFTDATA
    private var idUnicoResponsavel: Int { 1 } // Como você disse: Só existirá 1 responsável no app local

    private func salvarDadosNoBanco() {
        let senhaLimpa = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. Criar o Responsável (ID fixo = 1)
        let novoResponsavel = Responsavel(id: idUnicoResponsavel, senha: senhaLimpa)
        context.insert(novoResponsavel)
        
        // 2. Criar a Criança atrelada ao Responsável (idResponsavel: 1)
        // Nota: Ajuste os nomes das propriedades se o seu modelo usar nomes levemente diferentes
        let novaCrianca = Crianca(
            id: Int(Date().timeIntervalSince1970), // Gera um ID único numérico baseado no timestamp
            nome: nomeDaCrianca,
            idade: idadeDaCrianca,
            idResponsavel: idUnicoResponsavel,
            idAvatar: 1 // Começa com um avatar padrão (ID 1)
        )
        context.insert(novaCrianca)
        
        // 3. Persistir fisicamente no SQLite
        do {
            try context.save()
            usuarioJaCadastrado = true // Salva globalmente que o Onboarding acabou!
            navegarParaMain = true     // Dispara a mudança de tela
        } catch {
            print("Erro ao salvar cadastro inicial: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
//        DefinirSenhaView()
//            .modelContainer(
//                for: [
//                    Crianca.self, Responsavel.self, Avatar.self,
//                    Livro.self, LivroVersaoNivel.self, ConteudoLinha.self,
//                    Trecho.self, Atividade.self,
//                    AtividadeMultiplaEscolha.self,
//                    AtividadeDesembaralhar.self
//                ],
//                inMemory: false,
//                sqliteDatabasePath: dbPath
//            )
//    } else {
//        ContentUnavailableView("Banco db.sqlite não encontrado no Bundle", systemImage: "exclamationmark.triangle")
//    }
//}
