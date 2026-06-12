//
//  DesingSystem.swift
//  FinalProjectFoundation
//
//  Created by Found on 09/06/26.
//

import SwiftUI

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

