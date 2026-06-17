//
//  SwiftUIView.swift
//  FinalProjectFoundation
//
//  Created by Found on 16/06/26.
//
//
//import SwiftUI
//import SwiftData
//import SwiftDataSQLite
//
//@Model
//@SQLiteTable("Livro")
//class Livro {
//    @SQLiteColumn("id_livro")
//    var id: Int
//    var titulo: String
//    var capa: String
//    init(id: Int, titulo: String, capa: String) {
//        self.id = id
//        self.titulo = titulo
//        self.capa = capa
//    }
//}
//
//struct SwiftUIView: View {
//    @Query var livros: [Livro]
//    var body: some View {
//        List {
//            ForEach(livros) { livro in
//                Text(livro.titulo)
//            }
//        }
//    }
//}
//
//#Preview {
//    SwiftUIView()
//        .modelContainer(
//            for: [Livro.self],
//            inMemory: true,
//            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
//        )
//}

import SwiftUI
import SwiftData
import SwiftDataSQLite

struct TesteTituloView: View {
    @Environment(\.modelContext) private var context
    
    // Trocado para ler a tabela corrigida LivroVersaoNivel
    @Query var todasAsVersoes: [LivroVersaoNivel]
    @Query var todosOsLivros: [Livro]
    
    var idVersaoSelecionada: Int
    
    var tituloDoLivro: String {
        // 1. Busca na tabela correta (Livro_Versao_Nivel) usando o ID 101
        guard let versao = todasAsVersoes.first(where: { Int($0.id) == Int(idVersaoSelecionada) }) else {
            return "Versão \(idVersaoSelecionada) não encontrada no banco"
        }
        
        // 2. Pega o idLivro que veio de lá e acha o título
        guard let livro = todosOsLivros.first(where: { Int($0.id) == Int(versao.idLivro) }) else {
            return "Livro com id_livro \(versao.idLivro) não encontrado"
        }
        
        return livro.titulo
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Buscando para a Versão: \(idVersaoSelecionada)")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Text(tituloDoLivro)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview Ajustado
#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        TesteTituloView(idVersaoSelecionada: 101)
            .modelContainer(
                // Atualizado o array para incluir o novo modelo corrigido
                for: [LivroVersaoNivel.self, Livro.self],
                inMemory: true,
                sqliteDatabasePath: dbPath
            )
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado", systemImage: "exclamationmark.triangle")
    }
}
