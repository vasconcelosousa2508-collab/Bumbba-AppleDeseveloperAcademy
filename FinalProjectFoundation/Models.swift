//
//  SwiftUIView.swift
//  FinalProjectFoundation
//
//  Created by Found on 13/06/26.
//
import Foundation

// Modelo do Livro preparado para múltiplos níveis de texto manuais
struct Livro: Identifiable {
    let id: Int
    let titulo: String
    let imagemCapa: String
    
    // Dicionário onde a chave é a idade (ex: "4 a 5") e o valor é um array de parágrafos
    let textosPorIdade: [String: [String]]
}

// Dados mockados para alimentar o design das suas telas
enum DadosManuais {
    static let listaLivros: [Livro] = [
        Livro(
            id: 1,
            titulo: "Se Essa Rua Fosse Minha",
            imagemCapa: "capa_rua",
            textosPorIdade: [
                "4 a 5": [
                    "Se essa rua fosse minha, eu mandava ela ser bem bonita.",
                    "Eu jogava brilhantes no chão para o meu amor passar."
                ],
                "6 a 7": [
                    "Se essa rua fosse minha, eu mandava ela ser ladrilhada.",
                    "Com pedrinhas de brilhantes, apenas para o meu amor passar e sorrir."
                ],
                "8 a 10": [
                    "Se essa rua, se essa rua fosse minha, eu mandava, eu mandava ladrilhar. Com pedrinhas, com pedrinhas de brilhantes, para o meu, para o meu amor passar.",
                    "Nesta rua, nesta rua tem um bosque, que se chama, que se chama solidão. Dentro dele, dentro dele mora um anjo, que roubou, que roubou meu coração."
                ]
            ]
        ),
        Livro(
            id: 2,
            titulo: "O Cravo e a Rosa",
            imagemCapa: "capa_cravo",
            textosPorIdade: [
                "4 a 5": [
                    "O cravo brigou com a rosa perto da janela.",
                    "O cravo ficou machucado e a rosa chorou."
                ],
                "6 a 7": [
                    "O cravo brigou com a rosa debaixo de uma sacada.",
                    "O cravo saiu ferido e a rosa ficou despedaçada."
                ],
                "8 a 10": [
                    "O cravo brigou com a rosa debaixo de uma sacada. O cravo saiu ferido e a rosa despedaçada.",
                    "O cravo ficou doente e a rosa foi visitar. O cravo teve um desmaio e a rosa pôs-se a chorar."
                ]
            ]
        )
    ]
}
