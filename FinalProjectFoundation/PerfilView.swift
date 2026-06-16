//
//  perfil.swift
//  FinalProjectFoundation
//
//  Created by Found on 16/06/26.
//

import SwiftUI

struct perfil: View {
    var body: some View {
        ZStack{
            Color.fundo.ignoresSafeArea()
            VStack{
                Circle()
                    .fill(Color.sombra)
                    .frame(width: 200, height: 200)
                    .overlay(
                         Button(action: {
                             print("Botão no nordeste pressionado!")
                         }) {
                             Circle()
                                 .fill(Color.orange)
                                 .frame(width: 50, height: 50)
                                 .overlay(
                                     Image(systemName: "plus")
                                         .foregroundColor(.white)
                                 )
                         }
                         // X positivo (direita) e Y negativo (cima)
                         // 100 * 0.707 = ~71 para alinhar perfeitamente na borda
                         .offset(x: 71, y: -71)
                     )
                
                Text("Perfil")
                    .font(FontesDoApp.xBold(tamanho: 32))
                    .foregroundColor(.roxoTab)
                
        
            }
        }
        
    }
}

        


#Preview {
    perfil()
}
