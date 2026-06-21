//
//  FinalProjectFoundationApp.swift
//  FinalProjectFoundation
//
//  Created by Beatriz Leonel on 28/05/26.
//
import SwiftUI
import SwiftData
import SwiftDataSQLite

@main
struct FinalProjectFoundationApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(
                    for: [
                        Crianca.self, Responsavel.self, Avatar.self,
                        Livro.self, LivroVersaoNivel.self, ConteudoLinha.self,
                        Trecho.self, Atividade.self, AtividadeMultiplaEscolha.self, AtividadeDesembaralhar.self
                    ],
                    // 💡 IMPORTANTE: Mude de 'true' para 'false'.
                    // Se deixar 'true' (inMemory), ele ignora o seu arquivo SQLite e cria um banco limpo toda vez.
                    inMemory: false,
                    sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
                )
        }
    }
}
