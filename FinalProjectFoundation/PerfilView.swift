import SwiftUI
import SwiftData
import SwiftDataSQLite

struct PerfilView: View {
    @Query var criancas: [Crianca]
    @Query var avatares: [Avatar]
    
    @State private var avatarSelecionado: Avatar?
    
    let historiasConcluidas = 6
    
    var criancaAtual: Crianca? {
        criancas.first
    }
    
    var imagemAvatarAtual: UIImage? {
        guard let idAvatarDaCrianca = criancaAtual?.idAvatar else { return nil }
        let avatarEncontrado = avatares.first(where: { $0.id == idAvatarDaCrianca })
        
        if let data = avatarEncontrado?.imagem {
            return UIImage(data: data)
        }
        return nil
    }
    
    var body: some View {
        let colunas = [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ]
        
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    ZStack {
                        if let uiImage = imagemAvatarAtual {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.sombra)
                                .frame(width: 200, height: 200)
                        }
                    }
                    .overlay(
                        NavigationLink(destination: SelectAvatarView()) {
                            Circle()
                                .fill(Color.azulClaro)
                                .frame(width: 60, height: 60)
                                .opacity(0.8)
                                .overlay(
                                    Image(systemName: "pencil.circle")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                )
                        }
                            .offset(x: 71, y: -71)
                    )
                    
                    Text(criancaAtual?.nome ?? "Sem Nome")
                        .font(FontesDoApp.xBold(tamanho: 32))
                        .foregroundColor(.roxoTab)
                        .padding(.top, 25)
                    
                    VStack(spacing: 8) {
                        Divider()
                            .background(Color.roxoTab.opacity(0.2))
                        
                        HStack {
                            Text("Histórias Concluídas (\(historiasConcluidas))")
                                .font(FontesDoApp.x(tamanho: 18))
                                .foregroundColor(.roxoLetras.opacity(0.8))
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 25)
                    .padding(.top, 40)

                    // GRID DE LIVROS
                    LazyVGrid(columns: colunas, spacing: 8) {
                        ForEach(1...6, id: \.self) { livro in
                            VStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.sombra)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        Image(systemName: "book.closed.fill")
                                            .font(.system(size: 38))
                                            .foregroundColor(.roxoTab.opacity(0.6))
                                    )
                            }
                            .padding(8)
                            .background(Color.fundo)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PerfilView()
            .modelContainer(
                for: [Crianca.self, Avatar.self],
                inMemory: true,
                sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
            )
    }
}
