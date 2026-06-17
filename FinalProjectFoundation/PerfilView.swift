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
        return avatares.first(where: { $0.id == idAvatarDaCrianca })
    }
    
        let historiasConcluidas = 6

    
    var body: some View {
                let colunas = [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ]
        
        // REGRA 1: O NavigationStack fica do lado de fora de tudo
        NavigationStack {
            // REGRA 2: O ZStack fica dentro do Navigation para pintar o fundo real da tela
            ZStack {
                Color.fundo
                    .ignoresSafeArea()
                
                // REGRA 3: O ScrollView fica aqui dentro para rolar o conteúdo sem sumir com a cor
                ScrollView {
                    VStack(spacing: 24) {
                        if let crianca = criancaAtual {
                            // MARK: - Foto de Perfil
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
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
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
                            // Caso o ID passado não exista no banco
                            ContentUnavailableView("Criança não encontrada", systemImage: "person.fill.questionmark")
                                .padding(.top, 100)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                    .overlay(
                        NavigationLink(destination: SelectAvatarView().modelContainer(
                            for: [Avatar.self],
                            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
                        )) {
                            Circle()
                                .fill(Color.azulClaro)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "pencil.circle")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.fundo)
                                )
                        }
                            .offset(x: 71, y: -71)
                    )
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
                inMemory: true,
                sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
            )
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado", systemImage: "exclamationmark.triangle")
    }
}






//import SwiftUI
//import SwiftData
//import SwiftDataSQLite
//
//struct PerfilView: View {
//    @Query var criancas: [Crianca]
//    @Query var avatares: [Avatar]
//    
//    let historiasConcluidas = 6
//    
//    var criancaAtual: Crianca? {
//        criancas.first
//    }
//    
//    var imagemAvatarAtual: UIImage? {
//        guard let idAvatarDaCrianca = criancaAtual?.idAvatar else { return nil }
//        let avatarEncontrado = avatares.first(where: { $0.id == idAvatarDaCrianca })
//        
//        if let data = avatarEncontrado?.imagem {
//            return UIImage(data: data)
//        }
//        return nil
//    }
//    
//    var body: some View {
//        let colunas = [
//            GridItem(.flexible(), spacing: 8),
//            GridItem(.flexible(), spacing: 8)
//        ]
//        
//        ZStack {
//            Color.fundo.ignoresSafeArea()
//            
//            ScrollView {
//                VStack(spacing: 0) {
//                    
//                    ZStack {
//                        if let uiImage = imagemAvatarAtual {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 200, height: 200)
//                                .clipShape(Circle())
//                        } else {
//                            Circle()
//                                .fill(Color.sombra)
//                                .frame(width: 200, height: 200)
//                        }
//                    }
//                    .overlay(
//                        // LÓGICA INSERIDA: modelContainer injetado diretamente no destino do link
//                        NavigationLink(destination: SelectAvatarView().modelContainer(
//                            for: [Avatar.self],
//                            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
//                        )) {
//                            Circle()
//                                .fill(Color.azulClaro)
//                                .frame(width: 60, height: 60)
//                                .opacity(0.8)
//                                .overlay(
//                                    Image(systemName: "pencil.circle")
//                                        .resizable()
//                                        .frame(width: 60, height: 60)
//                                        .foregroundColor(.white)
//                                )
//                        }
//                        .offset(x: 71, y: -71)
//                    )
//                    
//                    Text(criancaAtual?.nome ?? "Sem Nome")
//                        .font(FontesDoApp.xBold(tamanho: 32))
//                        .foregroundColor(.roxoTab)
//                        .padding(.top, 25)
//                    
//                    VStack(spacing: 8) {
//                        Divider()
//                            .background(Color.roxoTab.opacity(0.2))
//                        
//                        HStack {
//                            Text("Histórias Concluídas (\(historiasConcluidas))")
//                                .font(FontesDoApp.x(tamanho: 18))
//                                .foregroundColor(.roxoLetras.opacity(0.8))
//                            Spacer()
//                        }
//                        .padding(.top, 10)
//                    }
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 25)
//                    .padding(.top, 40)
//
//                    // GRID DE LIVROS
//                    LazyVGrid(columns: colunas, spacing: 8) {
//                        ForEach(1...6, id: \.self) { livro in
//                            VStack(spacing: 0) {
//                                RoundedRectangle(cornerRadius: 12)
//                                    .fill(Color.sombra)
//                                    .aspectRatio(1, contentMode: .fit)
//                                    .overlay(
//                                        Image(systemName: "book.closed.fill")
//                                            .font(.system(size: 38))
//                                            .foregroundColor(.roxoTab.opacity(0.6))
//                                    )
//                            }
//                            .padding(8)
//                            .background(Color.fundo)
//                            .cornerRadius(12)
//                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
//                        }
//                    }
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 40)
//            }
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        PerfilView()
//            .modelContainer(
//                for: [Crianca.self, Avatar.self],
//                inMemory: false, // Alterado para false para renderizar os dados do SQLite no Preview pai também
//                sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
//            )
//    }
//}
