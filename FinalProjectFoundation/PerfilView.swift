import SwiftUI
import SwiftData
import SwiftDataSQLite

struct PerfilView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.perfilAtivo) private var perfilAtivo
    // 🚀 Pegamos a criança ativa direto do Environment injetado pela MainView
    @Environment(\.criancaAtiva) private var criancaAtivaEnvironment
    
    // 🔎 Buscamos a lista global (sem filtros rígidos no init para não travar a View)
    @Query var criancas: [Crianca]
    @Query var avatares: [Avatar]
    @Query var todosOsLivros: [Livro]
    
    var idSelecionado: Int?
    
    // Simplificamos o init para evitar que o SwiftData trave o estado inicial da Query
    init(idSelecionado: Int? = nil) {
        self.idSelecionado = idSelecionado
    }
    
    // 🔄 Descobre dinamicamente qual criança exibir (seja por ID fixo ou pelo Environment atual)
    var criancaAtual: Crianca? {
        if let idFiltro = idSelecionado {
            return criancas.first(where: { $0.id == idFiltro })
        }
        return criancaAtivaEnvironment
    }
    
    var avatarAtual: Avatar? {
        guard let idAvatarDaCrianca = criancaAtual?.idAvatar else { return nil }
        return avatares.first(where: { Int("\($0.id)") == Int("\(idAvatarDaCrianca)") })
    }
    
    var livrosConcluidos: [Livro] {
        todosOsLivros.filter { $0.concluido == 1 }
    }

    var body: some View {
        let colunas = [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ]
        
        NavigationStack {
            ZStack {
                Color.fundo
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let crianca = criancaAtual {
                            // MARK: - Foto de Perfil
                            ZStack(alignment: .topTrailing) {
                                if let avatarDados = avatarAtual?.imagem, let uiImage = UIImage(data: avatarDados) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 160)
                                        .clipShape(Circle())
                                        .shadow(radius: 4)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 160, height: 160)
                                        .foregroundColor(.gray)
                                }
                                
                                NavigationLink(destination: SelectAvatarView(crianca: crianca)) {
                                    Circle()
                                        .fill(Color.azulClaro)
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Image(systemName: "pencil.circle")
                                                .foregroundColor(.white)
                                                .font(.system(size: 50, weight: .bold))
                                        )
                                }
                                .offset(x: 10, y: 10)
                            }
                            
                            // MARK: - Informações da Criança
                            VStack(spacing: 12) {
                                Text(crianca.nome)
                                    .font(FontesDoApp.xBold(tamanho: 32))
                                    .foregroundColor(.roxoTab)
                                
                                Text("\(crianca.idade) anos")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                
                                // Botão de Trocar Perfil funcionando perfeitamente
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        perfilAtivo.wrappedValue = nil
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "arrow.left.arrow.right.circle")
                                        Text("Trocar de Perfil")
                                    }
                                    .font(FontesDoApp.xBold(tamanho: 14))
                                    .foregroundColor(.roxoTab)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Capsule().fill(Color.roxoTab.opacity(0.1)))
                                }
                                .padding(.top, 4)
                            }
                            
                        } else {
                            ContentUnavailableView("Criança não encontrada", systemImage: "person.fill.questionmark")
                                .padding(.top, 100)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 8) {
                        Divider()
                            .background(Color.roxoTab.opacity(0.2))

                        HStack {
                            Text("Histórias Concluídas (\(livrosConcluidos.count))")
                                .font(FontesDoApp.x(tamanho: 18))
                                .foregroundColor(.roxoLetras.opacity(0.8))
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 25)
                    .padding(.top, 20)

                    // GRID DE LIVROS DINÂMICO
                    if livrosConcluidos.isEmpty {
                        ContentUnavailableView(
                            "Nenhum livro concluído",
                            systemImage: "book",
                            description: Text("Complete as atividades para ver suas conquistas aqui!")
                        )
                        .padding(.top, 20)
                    } else {
                        LazyVGrid(columns: colunas, spacing: 8) {
                            ForEach(livrosConcluidos) { livro in
                                VStack(spacing: 4) {
                                    if let uiImage = UIImage(data: livro.capa) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity)
                                            .aspectRatio(1, contentMode: .fit)
                                            .cornerRadius(12)
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.sombra)
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay(
                                                Image(systemName: "book.closed.fill")
                                                    .font(.system(size: 38))
                                                    .foregroundColor(.roxoTab.opacity(0.6))
                                            )
                                    }
                                    
                                    Text(livro.titulo)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.roxoLetras)
                                        .lineLimit(1)
                                        .padding(.top, 4)
                                }
                                .padding(8)
                                .background(Color.fundo)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
            .scrollContentBackground(.hidden)
        }
    }
}



struct SelectAvatarView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query var avatares: [Avatar]
    
    var crianca: Crianca // Recebe a instância da criança da tela anterior
    @State private var avatarSelecionado: Avatar?
    
    let colunas = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Área de Rolagem dos Avatares
                ScrollView {
                    LazyVGrid(columns: colunas, spacing: 25) {
                        ForEach(avatares) { avatar in
                            Button(action: {
                                avatarSelecionado = avatar
                            }) {
                                VStack(spacing: 0) {
                                    if let uiImage = UIImage(data: avatar.imagem) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 160, height: 160)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 160, height: 160)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(8)
                            // Alinha os IDs para inteiros caso o banco use formato misto
                            .background(Int("\(avatarSelecionado?.id ?? -1)") == Int("\(avatar.id)") ? Color.roxoTab.opacity(0.2) : Color.clear)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
                
                // 2. Área Fixa do Botão de Confirmação
                VStack {
                    Button(action: {
                        if let novoAvatar = avatarSelecionado {
                            // ATUALIZAÇÃO NO SWIFTDATA: Atribui o novo ID de avatar à criança
                            // Adapte o tipo (ex: String(novoAvatar.id) ou Int(novoAvatar.id)) conforme seu model real exige
                            crianca.idAvatar = novoAvatar.id
                            
                            // Força a gravação imediata no SQLite
                            try? context.save()
                        }
                        dismiss() // Fecha e volta atualizado automaticamente
                    }) {
                        HStack(spacing: 10) {
                            Text("Confirmar")
                                .font(FontesDoApp.x(tamanho: 16))
                        }
                        .foregroundColor(.white)
                        .frame(width: 320, height: 50)
                        .background(Color.roxoTab)
                        .cornerRadius(100)
                        .opacity(avatarSelecionado == nil ? 0.5 : 1.0)
                    }
                    .disabled(avatarSelecionado == nil)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color.fundo)
            }
        }
        .onAppear {
            // Inicializa a seleção visual com o avatar que a criança já usa hoje
            avatarSelecionado = avatares.first(where: { Int("\($0.id)") == Int("\(crianca.idAvatar)") })
        }
    }
}



// MARK: - Preview Oficial Atualizado
#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        PerfilView(idSelecionado: 1)
            .modelContainer(
                // 🚀 Incluído Livro.self também no container do preview
                for: [Crianca.self, Avatar.self, Livro.self],
                inMemory: false,
                sqliteDatabasePath: dbPath
            )
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado", systemImage: "exclamationmark.triangle")
    }
}


