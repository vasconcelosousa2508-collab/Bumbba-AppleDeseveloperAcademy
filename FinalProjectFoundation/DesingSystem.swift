//
//  DesingSystem.swift
//  FinalProjectFoundation
//
//  Created by Found on 09/06/26.
//

import SwiftUI

// MARK: - Fontes Globais do App
enum FontesDoApp {
    static let fonteX = "Fredoka"
    
    static func x(tamanho: CGFloat) -> Font {
        return .custom(fonteX, size: tamanho)
    }
    
    static func xBold(tamanho: CGFloat) -> Font {
        return .custom(fonteX, size: tamanho).bold()
    }
    
    static func uiFontX(tamanho: CGFloat) -> UIFont {
        return UIFont(name: fonteX, size: tamanho) ?? UIFont.systemFont(ofSize: tamanho)
    }
    
    static func uiFontXBold(tamanho: CGFloat) -> UIFont {
        if let fonte = UIFont(name: fonteX, size: tamanho),
           let descritorBold = fonte.fontDescriptor.withSymbolicTraits(.traitBold) {
            return UIFont(descriptor: descritorBold, size: tamanho)
        }
        return UIFont.systemFont(ofSize: tamanho, weight: .bold)
    }
}

// MARK: - Cores Globais do App
// Estender a Color nativa garante sintaxe limpa: ex: Color.appFundo
extension Color {
    static let appFundo = Color("fundo")
    static let appRoxoTab = Color("roxoTab")
    static let appRoxoEscuroBtn = Color("roxoEscuroBnt")
    static let appSombra = Color("sombra")
}

// Extensão complementar para UIColor (usada no sistema ou tint da TabView se necessário)
//extension UIColor {
//    static let appRoxoTab = UIColor(named: "roxoTab") ?? .purple
//}
