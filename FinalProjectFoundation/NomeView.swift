//
//  SelectPerfilView.swift
//  FinalProjectFoundation
//
//  Created by Found on 16/06/26.
//

import SwiftUI
import SwiftData
import SwiftDataSQLite

struct NomeView: View {
    @State private var texto: String = ""
    
    // Propriedade para checar se o input está vazio (ignora espaços em branco)
    private var estaVazio: Bool {
        texto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fundo.ignoresSafeArea()
                
                VStack {
                    // 1. Área superior: Imagem isolada no topo
                    Image("rostoBoi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230, height: 230)
                        .padding(20)
                        .padding(.top, 30)
                    
                    VStack(spacing: 25) {
                        Text("Qual o nome da sua criança?")
                            .font(FontesDoApp.xBold(tamanho: 32))
                            .foregroundColor(.roxoTab)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding()
                        
                        TextField("Digite um nome...", text: $texto)
                            .font(FontesDoApp.x(tamanho: 20))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 23)
                                    .stroke(Color.primary, lineWidth: 1)
                                    .background(Color.fundo.cornerRadius(15))
                            )
                            .padding(.horizontal, 40)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer() // Empurra o bloco central para cima e o botão para o rodapé
                    
                    // 2. NavigationLink básico com validação de estado
                    NavigationLink(destination: IdadeView()) {
                        Text("Confirmar")
                            .font(FontesDoApp.x(tamanho: 16))
                            .foregroundColor(.white)
                            .frame(width: 320, height: 50)
                            .background(
                                Color.roxoTab
                                    .cornerRadius(100)
                            )
                    }
                    .disabled(estaVazio) // Desativa o clique se estiver vazio
                    .opacity(estaVazio ? 0.4 : 1.0) // Fica mais claro se estiver vazio
                    .padding(.bottom, 20)
                }
            }
        }
        // Transição de opacidade suave ao digitar
        .animation(.easeInOut(duration: 0.2), value: texto)
    }
}

#Preview {
    NomeView()
}
