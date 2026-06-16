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
