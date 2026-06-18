import SwiftUI
import SwiftData
import SwiftDataSQLite

struct BibliotecaView: View {
    @Query var livros: [Livro]
    @Query var todasAsVersoes: [LivroVersaoNivel]

    let colunas = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var idadeSelecionada = "4 - 5"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fundo.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        
                        // MARK: - Cabeçalho
                        HStack(alignment: .firstTextBaseline) {
                            Text("Biblioteca")
                                .font(FontesDoApp.xBold(tamanho: 32))
                                .foregroundColor(.roxoTab)
                            
                            Spacer()
                            
                            NavigationLink(destination: BiblioAgeView(idadeSelecionada: $idadeSelecionada)) {
                                HStack(spacing: 10) {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .font(.system(size: 12, weight: .bold))
                                    Text(idadeSelecionada + " anos")
                                        .font(FontesDoApp.x(tamanho: 16))
                                }
                                .foregroundColor(.white)
                                .frame(width: 130, height: 35)
                                .background(Color.roxoEscuroBnt)
                                .cornerRadius(100)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 45)
                        
                        // MARK: - Grade de Livros
                        LazyVGrid(columns: colunas, spacing: 20) {
                            ForEach(livros) { livro in
                                // LÓGICA DINÂMICA: Procura a versão deste livro no banco de dados.
                                // Se não encontrar nenhuma versão válida, ele usa o 101 como fallback de segurança.
                                let idDaVersaoDinamica: Int = {
                                    if let versaoEncontrada = todasAsVersoes.first(where: { "\($0.idLivro)" == "\(livro.id)" }) {
                                        return Int(versaoEncontrada.id) ?? 101
                                    }
                                    return 101
                                }()
                                
                                // MODIFICADO: Agora passa o ID correto e dinâmico descoberto acima
                                NavigationLink(destination: LeituraView(idVersaoSelecionada: idDaVersaoDinamica)) {
                                    VStack(spacing: 12) {
                                        
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.sombra)
                                            .frame(width: 170, height: 170)
                                            .overlay(
                                                ZStack {
                                                    Image(systemName: "book.closed.fill")
                                                        .font(.system(size: 38))
                                                        .foregroundColor(.roxoTab.opacity(0.6))
                                                    
                                                    if let uiImage = UIImage(data: livro.capa) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 170, height: 170)
                                                            .cornerRadius(12)
                                                            .clipped()
                                                    } else {
                                                        Image(systemName: "book.closed.fill")
                                                            .font(.system(size: 38))
                                                            .foregroundColor(.roxoTab.opacity(0.6))
                                                    }
                                                }
                                            )
                                        
                                        Text(livro.titulo)
                                            .font(FontesDoApp.x(tamanho: 16))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .frame(height: 40)
                                    }
                                    .padding(10)
                                    .background(Color.fundo)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - Preview Corrigido
#Preview {
    let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite")!
    
    return BibliotecaView()
        .modelContainer(
            for: [ConteudoLinha.self, Trecho.self, Atividade.self, LivroVersaoNivel.self, Livro.self],
            inMemory: false, // Alterado para false para conseguir ler os dados reais do seu arquivo .sqlite
            sqliteDatabasePath: dbPath
        )
}
