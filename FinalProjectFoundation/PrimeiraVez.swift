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


struct IdadeView: View {
    let nomeDaCrianca: String // 🚀 PASSO 2: Armazena o nome recebido da tela anterior
    
    @State private var idadeSelecionada: Int = 4
    let idades = Array(4...10)
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack {
                Image("bolo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 80)
                
                VStack(spacing: 35) {
                    Text("Qual a idade da sua criança?")
                        .font(FontesDoApp.xBold(tamanho: 32))
                        .foregroundColor(.roxoTab)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    HStack(spacing: 15) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                            .opacity(idadeSelecionada > idades.first! ? 0.5 : 0.1)
                            .onTapGesture {
                                if idadeSelecionada > idades.first! { idadeSelecionada -= 1 }
                            }
                        
                        ZStack {
                            TabView(selection: $idadeSelecionada) {
                                ForEach(idades, id: \.self) { idade in
                                    Text("\(idade)")
                                        .font(FontesDoApp.xBold(tamanho: idadeSelecionada == idade ? 32 : 20))
                                        .foregroundColor(idadeSelecionada == idade ? .roxoTab : .primary.opacity(0.3))
                                        .frame(width: 60, height: 70)
                                        .scaleEffect(idadeSelecionada == idade ? 1.2 : 1.0)
                                        .tag(idade)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(width: 160, height: 80)
                        }
                        .frame(width: 180, height: 80)
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black, location: 0.25),
                                    .init(color: .black, location: 0.75),
                                    .init(color: .clear, location: 1.0)
                                ]),
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                            .opacity(idadeSelecionada < idades.last! ? 0.5 : 0.1)
                            .onTapGesture {
                                if idadeSelecionada < idades.last! { idadeSelecionada += 1 }
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // 🚀 PASSO 3: Passa o Nome e a Idade selecionada para a tela da Senha
                NavigationLink(destination: DefinirSenhaView(nomeDaCrianca: nomeDaCrianca, idadeDaCrianca: idadeSelecionada)) {
                    Text("Confirmar")
                        .font(FontesDoApp.x(tamanho: 16))
                        .foregroundColor(.white)
                        .frame(width: 320, height: 50)
                        .background(Color.roxoTab.cornerRadius(100))
                }
                .padding(.bottom, 20)
            }
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.75), value: idadeSelecionada)
    }
}

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
