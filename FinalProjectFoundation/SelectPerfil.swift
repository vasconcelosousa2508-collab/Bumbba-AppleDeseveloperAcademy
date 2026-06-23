import SwiftUI
import SwiftData
import SwiftDataSQLite

struct SeletorPerfilView: View {
    @Environment(\.modelContext) private var context
    @Query var criancas: [Crianca]
    @Query var avatares: [Avatar]
    
    // 🔗 Vinculação que controla qual tela a MainView vai renderizar
    @Binding var perfilSelecionado: Crianca?
    
    private let colunas = [
        GridItem(.adaptive(minimum: 130, maximum: 160), spacing: 24)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fundo.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    
                    VStack(spacing: 8) {
                        Text("Quem está lendo?")
                            .font(FontesDoApp.xBold(tamanho: 28))
                            .foregroundColor(.roxoTab)
                        
                        Text("Escolha um perfil para começar")
                            .font(FontesDoApp.x(tamanho: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    if criancas.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 60))
                                .foregroundColor(.roxoTab)
                            
                            Text("Nenhum perfil criado")
                                .font(FontesDoApp.xBold(tamanho: 18))
                            
                            NavigationLink(destination: InserirSenhaView()) {
                                Text("Gerenciar Perfis")
                                    .font(FontesDoApp.xBold(tamanho: 16))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.roxoTab.cornerRadius(100))
                            }
                        }
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: colunas, spacing: 32) {
                                ForEach(criancas) { crianca in
                                    
                                    Button(action: {
                                        // 🚀 O CLIQUE DO STREAMING:
                                        // Modifica o estado do pai com animação, alternando para a MainView
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            perfilSelecionado = crianca
                                        }
                                    }) {
                                        VStack(spacing: 12) {
                                            let avatarDaCrianca = avatares.first(where: { $0.id == crianca.idAvatar })
                                            
                                            Group {
                                                if let dadosDaImagem = avatarDaCrianca?.imagem,
                                                   let imagemConvertida = UIImage(data: dadosDaImagem) {
                                                    Image(uiImage: imagemConvertida)
                                                        .resizable()
                                                } else {
                                                    Image(systemName: "person.fill")
                                                        .resizable()
                                                        .padding(25)
                                                        .background(Color.roxoTab.opacity(0.2))
                                                        .foregroundColor(.roxoTab)
                                                }
                                            }
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(40)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 40)
                                                    .stroke(Color.roxoTab.opacity(0.6), lineWidth: 2)
                                            )
                                            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 8)
                                            
                                            Text(crianca.nome)
                                                .font(FontesDoApp.xBold(tamanho: 16))
                                                .foregroundColor(.primary)
                                                .lineLimit(1)
                                        }
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: InserirSenhaView()) {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                            Text("Área do Responsável")
                        }
                        .font(FontesDoApp.x(tamanho: 14))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Capsule().stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// Eleva a experiência do usuário criando um efeito de "clique" animado igual ao de TVs/Streamings
// ... FIM DA SUA SELETORPERFILVIEW ...
// Certifique-se de fechar todas as chaves } da SeletorPerfilView aqui.

// 🟢 COLOQUE O STYLE AQUI (FORA DE TUDO, NO ESCOPO GLOBAL DO ARQUIVO)
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}


#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        SeletorPerfilView(perfilSelecionado: .constant(nil))
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
