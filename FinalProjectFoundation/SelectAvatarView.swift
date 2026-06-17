import SwiftUI
import SwiftData
import SwiftDataSQLite

struct SelectAvatarView: View {
    @Environment(\.dismiss) private var dismiss // Adicionado para fechar a tela
    @Query var avatares: [Avatar]
    @Query var criancas: [Crianca]

    @State private var avatarSelecionado: Avatar?
    
    let colunas = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            // O VStack principal separa o conteúdo rolável do botão fixo
            VStack(spacing: 0) {
                
                // 1. Área de Rolagem (Apenas para os Avatares)
                ScrollView {
                    LazyVGrid(columns: colunas, spacing: 25) {
                        ForEach(avatares) { avatar in
                            Button(action: {
                                avatarSelecionado = avatar
                                print("Avatar selecionado: \(avatar.id)")
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
                            .background(avatarSelecionado?.id == avatar.id ? Color.roxoTab.opacity(0.2) : Color.clear)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
                
                // 2. Área Fixa do Botão (Sempre visível no rodapé)
                VStack {
                    Button(action: {
                        dismiss() // Fecha a tela ao confirmar
                    }) {
                        HStack(spacing: 10) {
                            Text("Confirmar")
                                .font(FontesDoApp.x(tamanho: 16))
                        }
                        .foregroundColor(.white)
                        .frame(width: 320, height: 50)
                        .background(Color.roxoTab)
                        .cornerRadius(100)
                        // Deixa o botão semi-transparente se nada foi selecionado
                        .opacity(avatarSelecionado == nil ? 0.5 : 1.0)
                    }
                    // Desabilita o clique se o usuário não escolheu uma foto
                    .disabled(avatarSelecionado == nil)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color.fundo) // Evita que avatares vazem por baixo do botão
            }
        }
    }
}

#Preview {
    SelectAvatarView()
        .modelContainer(
            for: [Avatar.self],
            inMemory: true,
            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
        )
}
