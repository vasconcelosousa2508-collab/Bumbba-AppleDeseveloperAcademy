////
////  ListaCriancasView.swift
////  FinalProjectFoundation
////
////  Created by Found on 17/06/26.
////
//
////
////  ListaCriancasView.swift
////  FinalProjectFoundation
////
////  Created by Found on 17/06/26.
////
//
////
////  ListaCriancasView.swift
////  FinalProjectFoundation
////
////  Created by Found on 17/06/26.
////
////
////  ListaCriancasView.swift
////  FinalProjectFoundation
////
////  Created by Found on 17/06/26.
////
//
//import SwiftUI
//import SwiftData
//import SwiftDataSQLite
//
//struct PerfilView: View {
//    @Environment(\.modelContext) private var context
//    @Query var criancas: [Crianca]
//    @Query var avatares: [Avatar]
//    
//    var idSelecionado: Int?
//    
//    // Inicializador mantém o filtro pelo ID
//    init(idSelecionado: Int? = nil) {
//        self.idSelecionado = idSelecionado
//        
//        if let idFiltro = idSelecionado {
//            self._criancas = Query(filter: #Predicate<Crianca> { $0.id == idFiltro })
//        } else {
//            self._criancas = Query()
//        }
//    }
//    
//    // Captura a criança encontrada pelo filtro
//    var criancaAtual: Crianca? {
//        criancas.first
//    }
//    
//    // Busca o avatar correspondente na memória
//    var avatarAtual: Avatar? {
//        guard let idAvatarDaCrianca = criancaAtual?.idAvatar else { return nil }
//        return avatares.first(where: { $0.id == idAvatarDaCrianca })
//    }
//    
//    var body: some View {
//        ZStack{
//            Color.fundo.ignoresSafeArea()
//            NavigationStack {
//                VStack(spacing: 24) {
//                    if let crianca = criancaAtual {
//                        // MARK: - Foto de Perfil
//                        if let avatarDados = avatarAtual?.imagem, let uiImage = UIImage(data: avatarDados) {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 160, height: 160)
//                                .clipShape(Circle())
//                                .shadow(radius: 4)
//                        } else {
//                            Image(systemName: "person.circle.fill")
//                                .resizable()
//                                .frame(width: 120, height: 120)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        // MARK: - Informações da Criança
//                        VStack(spacing: 8) {
//                            Text(crianca.nome)
//                                .font(.largeTitle)
//                                .bold()
//                            
//                            Text("\(crianca.idade) anos")
//                                .font(.title3)
//                                .foregroundColor(.secondary)
//                        }
//                        
//                        Spacer()
//                    } else {
//                        // Caso o ID passado não exista no banco
//                        ContentUnavailableView("Criança não encontrada", systemImage: "person.fill.questionmark")
//                    }
//                }
//                .padding(.top, 40)
//            }
//        }
//    }
//}
//
//#Preview {
//    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
//        // Altere o ID aqui para testar com diferentes crianças do seu banco de dados
//        PerfilView(idSelecionado: 1)
//            .modelContainer(
//                for: [Crianca.self, Avatar.self],
//                inMemory: true,
//                sqliteDatabasePath: dbPath
//            )
//    } else {
//        ContentUnavailableView("Banco db.sqlite não encontrado", systemImage: "exclamationmark.triangle")
//    }
//}
