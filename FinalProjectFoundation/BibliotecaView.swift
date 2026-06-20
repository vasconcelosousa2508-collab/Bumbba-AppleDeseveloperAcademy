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
    
    // FILTRO DE IDADE: Pega apenas as versões do banco que batem com a idade selecionada
    var versoesDaIdadeAtual: [LivroVersaoNivel] {
        todasAsVersoes.filter {
            $0.faixaEtaria.trimmingCharacters(in: .whitespacesAndNewlines) == idadeSelecionada.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
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
                        
                        // MARK: - Grade de Livros Dinâmica
                        if versoesDaIdadeAtual.isEmpty {
                            ContentUnavailableView(
                                "Nenhum livro disponível",
                                systemImage: "book.closed",
                                description: Text("Não há livros adaptados para a idade de \(idadeSelecionada) anos.")
                            )
                            .padding(.top, 40)
                        } else {
                            LazyVGrid(columns: colunas, spacing: 20) {
                                ForEach(versoesDaIdadeAtual) { versao in
                                    if let livro = livros.first(where: { "\($0.id)" == "\(versao.idLivro)" }) {
                                        
                                        let idVersaoInt = Int(versao.id)
                                        
                                        // 💡 SUBSTUIÇÃO AQUI: Trocado LeituraView por FluxoHistoriaEAtividadeView
                                        NavigationLink(destination: FluxoHistoriaEAtividadeView(idVersaoSelecionada: idVersaoInt)) {
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
                            }
                            .padding(.horizontal, 20)
                        }
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
            for: [
                ConteudoLinha.self,
                Trecho.self,
                Atividade.self,
                AtividadeMultiplaEscolha.self, // 💡 Adicionado para o preview do fluxo de atividades funcionar
                LivroVersaoNivel.self,
                Livro.self
            ],
            inMemory: false,
            sqliteDatabasePath: dbPath
        )
}
