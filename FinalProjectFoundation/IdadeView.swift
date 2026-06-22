//
//  IdadeView.swift
//  FinalProjectFoundation
//
//  Created by Found on 21/06/26.
//

import SwiftUI
import SwiftData
import SwiftDataSQLite

struct IdadeView: View {
    // Estado monitorando qual idade está no centro absoluto da tela
    @State private var idadeSelecionada: Int = 4
    
    let idades = Array(4...10)
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack {
                // 1. Área superior: Imagem isolada no topo
                Image("bolo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 80)
                
                
                // 2. Área central: Texto e o Seletor Horizontal com Setas
                VStack(spacing: 35) {
                    Text("Qual a idade da sua criança?")
                        .font(FontesDoApp.xBold(tamanho: 32))
                        .foregroundColor(.roxoTab)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Alinhamento das setas com o seletor central
                    HStack(spacing: 15) {
                        
                        // Seta Esquerda
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                            .opacity(idadeSelecionada > idades.first! ? 0.5 : 0.1) // Apaga se for a primeira idade
                            .onTapGesture {
                                if idadeSelecionada > idades.first! {
                                    idadeSelecionada -= 1
                                }
                            }
                        
                        // Container do Seletor
                        ZStack {
                            TabView(selection: $idadeSelecionada) {
                                ForEach(idades, id: \.self) { idade in
                                    Text("\(idade)")
                                        .font(FontesDoApp.xBold(tamanho: idadeSelecionada == idade ? 32 : 20))
                                        .foregroundColor(idadeSelecionada == idade ? .roxoTab : .primary.opacity(0.3))
                                        .frame(width: 60, height: 70)
                                        .scaleEffect(idadeSelecionada == idade ? 1.2 : 1.0)
                                        .tag(idade)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(width: 160, height: 80)
                        }
                        .frame(width: 180, height: 80) // Janela interna levemente reduzida para encaixar as setas nas pontas
                        .mask(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .black, location: 0.25),
                                    .init(color: .black, location: 0.75),
                                    .init(color: .clear, location: 1.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        
                        // Seta Direita
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                            .opacity(idadeSelecionada < idades.last! ? 0.5 : 0.1) // Apaga se for a última idade
                            .onTapGesture {
                                if idadeSelecionada < idades.last! {
                                    idadeSelecionada += 1
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // 3. Área inferior: Botão fixado embaixo
                Button {
                    print("Idade confirmada: \(idadeSelecionada)")
                } label: {
                    Text("Confirmar")
                        .font(FontesDoApp.x(tamanho: 16))
                        .foregroundColor(.white)
                        .frame(width: 320, height: 50)
                        .background(
                            Color.roxoTab
                                .cornerRadius(100)
                        )
                }
                .padding(.bottom, 20)
            }
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.75), value: idadeSelecionada)
    }
}

#Preview {
    IdadeView()
}
