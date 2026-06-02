//
//  ContentView.swift
//  FinalProjectFoundation
//
//  Created by Beatriz Leonel on 28/05/26.
//

import SwiftUI
//
//struct MainView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    MainView()
//}
//


struct MainView : View {
    var body: some View {
        TabView {
            Group {
                Tab("Livros", systemImage: "square.stack.3d.down.right.fill") {
                    ZStack {
                        Color.fundo.ignoresSafeArea()
                        VStack {
                            BibliotecaView()
                        }
                    }
                }
                Tab("Você", systemImage: "star") {
                    ZStack {
                        Color.fundo.ignoresSafeArea()
                        VStack {
                            Text("Perfil")
                        }
                    }
                }
                Tab("Responsável", systemImage: "person.fill") {
                    ZStack {
                        Color.fundo.ignoresSafeArea()
                        VStack {
                            Text("Acesso Responsável")
                        }
                    }
                }
            }
        }
        .tint(.roxoTab)
    }
}

#Preview {
    MainView(
//        .modelContainer( // ✅
//                    for: [Album.self, Music.self],
//                    inMemory: true,
//                    sqliteDatabasePath: Bundle.main.path(forResource: "database", ofType: "sqlite")!
//                )
    )
}
