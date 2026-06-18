import SwiftUI
import SwiftData
import SwiftDataSQLite

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

#Preview {
    // Apenas criando um mockup rápido para rodar o preview
    let mockCrianca = Crianca(id: 1, nome: "Gabi", idade: 5, idResponsavel: 1 , idAvatar: 1 )
    
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        SelectAvatarView(crianca: mockCrianca)
            .modelContainer(
                for: [Avatar.self, Crianca.self],
                inMemory: false,
                sqliteDatabasePath: dbPath
            )
    } else {
        ContentUnavailableView("Banco não encontrado", systemImage: "xmark")
    }
}
