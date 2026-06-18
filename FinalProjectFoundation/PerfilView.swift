import SwiftUI
import SwiftData
import SwiftDataSQLite

struct PerfilView: View {
    @Environment(\.modelContext) private var context
    @Query var criancas: [Crianca]
    @Query var avatares: [Avatar]
    
    var idSelecionado: Int?
    
    // Inicializador mantém o filtro pelo ID
    init(idSelecionado: Int? = nil) {
        self.idSelecionado = idSelecionado
        
        if let idFiltro = idSelecionado {
            self._criancas = Query(filter: #Predicate<Crianca> { $0.id == idFiltro })
        } else {
            self._criancas = Query()
        }
    }
    
    // Captura a criança encontrada pelo filtro
    var criancaAtual: Crianca? {
        criancas.first
    }
    
    // Busca o avatar correspondente na memória
    var avatarAtual: Avatar? {
        guard let idAvatarDaCrianca = criancaAtual?.idAvatar else { return nil }
        
        // Conversão segura de Int/String caso seu banco SQLite use tipagem mista
        return avatares.first(where: { Int("\($0.id)") == Int("\(idAvatarDaCrianca)") })
    }
    
    let historiasConcluidas = 6

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
                                
                                // Botão de Lápis posicionado por cima com NavigationLink enviando a criança
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
                            VStack(spacing: 8) {
                                Text(crianca.nome)
                                    .font(FontesDoApp.xBold(tamanho: 32))
                                    .foregroundColor(.roxoTab)
                                
                                Text("\(crianca.idade) anos")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
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
                            Text("Histórias Concluídas (\(historiasConcluidas))")
                                .font(FontesDoApp.x(tamanho: 18))
                                .foregroundColor(.roxoLetras.opacity(0.8))
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 15)
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
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        PerfilView(idSelecionado: 1)
            .modelContainer(
                for: [Crianca.self, Avatar.self],
                inMemory: false, // Alterado para ler do banco real do Bundle
                sqliteDatabasePath: dbPath
            )
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado", systemImage: "exclamationmark.triangle")
    }
}
