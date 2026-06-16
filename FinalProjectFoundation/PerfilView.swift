//
//  perfil.swift
//  FinalProjectFoundation
//
//  Created by Found on 16/06/26.
//



import SwiftUI

struct PerfilView: View {
    let historiasConcluidas = 6
    
    var body: some View {
        let colunas = [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ]
        
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            ScrollView {
                // Criado este VStack interno para gerenciar os espaçamentos de toda a página
                VStack(spacing: 0) {
                    
                    // FOTO DE PERFIL
                    Circle()
                        .fill(Color.sombra)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Button(action: {
                                print("Botão no nordeste pressionado!")
                            }) {
                                Circle()
                                    .fill(Color.azulClaro)
                                    .frame(width: 60, height: 60)
                                    .opacity(0.8)
                                    .overlay(
                                        Text("\(Image(systemName: "pencil.circle"))")
                                            .font(.system(size: 60))
                                            .bold()
                                            .foregroundColor(.fundo)
                                    )
                            }
                            .offset(x: 71, y: -71)
                        )
                    
                    // NOME DO PERFIL
                    Text("Nome da criança")
                        .font(FontesDoApp.xBold(tamanho: 32))
                        .foregroundColor(.roxoTab)
                        .padding(.top, 10) // Ajustado de bottom para top para organizar o fluxo
                    
                    // LINHA DIVISÓRIA E CONTADOR
                    VStack(spacing: 8) {
                        Divider()
                            .background(Color.roxoTab.opacity(0.2))
                        
                        HStack {
                            Text("Histórias Concluídas (\(historiasConcluidas))")
                                .font(FontesDoApp.x(tamanho: 18))
                                .foregroundColor(.roxoLetras.opacity(0.8))
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 25)
                    .padding(.top, 40)

                    
                    // GRID DE LIVROS
                    LazyVGrid(columns: colunas, spacing: 8) {
                        ForEach(1...6, id: \.self) { livro in
                            VStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.sombra)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        Image(systemName: "book.closed.fill")
                                            .font(.system(size: 38))
                                            .foregroundColor(.roxoTab.opacity(0.6))
                                    )
                            }
                            .padding(8)
                            .background(Color.fundo)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
        }
    }
}

#Preview {
    PerfilView()
}
