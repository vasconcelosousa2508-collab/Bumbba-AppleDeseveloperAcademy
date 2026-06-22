//
//  AreaResponsavel.swift
//  FinalProjectFoundation
//
//  Created by Found on 22/06/26.
//

import SwiftUI
import SwiftData
import SwiftDataSQLite

struct InserirSenhaView: View {
    @Environment(\.modelContext) private var context
    @Query var responsaveis: [Responsavel]
    
    var responsavel: Responsavel? {
        responsaveis.first
    }
    
    private var senha_correta: String {
        responsavel?.senha ?? ""
    }
    
    @State private var texto: String = ""
    @State private var senhaIncorreta: Bool = false // ⚠️ Controla a mensagem de erro
    @State private var irParaAreaResponsavel: Bool = false // 🚀 Controla o acesso à tela
    
    private var estaVazio: Bool {
        texto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.fundo.ignoresSafeArea()
                
                VStack {
                    Image("senha")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding(.top, 50)
                    
                    VStack(spacing: 20) {
                        Text("Insira senha de responsável")
                            .font(FontesDoApp.xBold(tamanho: 32))
                            .foregroundColor(.roxoTab)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding()
                        
                        // Considerar usar SecureField aqui para ocultar os caracteres
                        TextField("Digite sua senha...", text: $texto)
                            .font(FontesDoApp.x(tamanho: 20))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 23)
                                    .stroke(senhaIncorreta ? Color.red : Color.primary, lineWidth: 1) // Borda vermelha se errar
                                    .background(Color.fundo.cornerRadius(15))
                            )
                            .padding(.horizontal, 40)
                            .foregroundColor(.primary)
                            .onChange(of: texto) { _, _ in
                                senhaIncorreta = false // Limpa o erro se o usuário voltar a digitar
                            }
                        
                        // 🛑 Mensagem de aviso abaixo do input
                        if senhaIncorreta {
                            Text("Senha incorreta")
                                .font(FontesDoApp.x(tamanho: 16)) // Ajuste para usar sua fonte padrão
                                .foregroundColor(.red)
                                .padding(.horizontal, 40)
                        }
                    }
                    
                    Spacer()
                    
                    // 🚀 Botão que valida e ativa a navegação apenas se estiver correto
                    Button(action: {
                        if texto == senha_correta {
                            senhaIncorreta = false
                            irParaAreaResponsavel = true
                        } else {
                            senhaIncorreta = true
                        }
                    }) {
                        Text("Confirmar")
                            .font(FontesDoApp.x(tamanho: 16))
                            .foregroundColor(.white)
                            .frame(width: 320, height: 50)
                            .background(Color.roxoTab.cornerRadius(100))
                    }
                    .disabled(estaVazio)
                    .opacity(estaVazio ? 0.4 : 1.0)
                    .padding(.bottom, 20)
                }
            }
            // Destino seguro gerenciado pela variável de estado
            .navigationDestination(isPresented: $irParaAreaResponsavel) {
                AreaResponsavelView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: texto)
        .animation(.easeInOut(duration: 0.2), value: senhaIncorreta)
    }
}



struct AreaResponsavelView: View {
    @Environment(\.modelContext) private var context
    @Query var criancas: [Crianca]
    @Query var todosOsLivros: [Livro]
    @Query var avatares: [Avatar]
    
    var body: some View {
        NavigationStack { // 🚀 Adicionado para gerenciar a ida para a edição
            ZStack {
                Color.fundo.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Título Principal
                    Text("Área do Responsável")
                        .font(FontesDoApp.xBold(tamanho: 28))
                        .foregroundColor(.roxoTab)
                        .padding(.horizontal)
                        .padding(30)
                    
                    if criancas.isEmpty {
                        VStack {
                            Spacer()
                            ContentUnavailableView(
                                "Nenhuma criança encontrada",
                                systemImage: "person.2.slash",
                                description: Text("Cadastre uma nova criança para começar.")
                            )
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(criancas) { crianca in
                                    
                                    // 🚀 Transforma o card inteiro em um botão de navegação
                                    NavigationLink(destination: EditarCriancaView(crianca: crianca)) {
                                        HStack(spacing: 16) {
                                            
                                            let avatarDaCrianca = avatares.first(where: { $0.id == crianca.idAvatar })
                                            
                                            if let dadosDaImagem = avatarDaCrianca?.imagem,
                                               let imagemConvertida = UIImage(data: dadosDaImagem) {
                                                Image(uiImage: imagemConvertida)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 70, height: 70)
                                                    .clipShape(Circle())
                                                    .background(Circle().stroke(Color.roxoTab, lineWidth: 2))
                                            } else {
                                                Image(systemName: "person.circle.fill")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 70, height: 70)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(crianca.nome)
                                                    .font(FontesDoApp.xBold(tamanho: 20))
                                                    .foregroundColor(.primary)
                                                
                                                Text("\(crianca.idade) anos")
                                                    .font(FontesDoApp.x(tamanho: 16))
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.roxoTab)
                                                .font(.system(size: 14, weight: .bold))
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color(.retanguloAR).opacity(0.4))
                                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                                        )
                                        .padding(.horizontal)
                                    }
                                    .buttonStyle(PlainButtonStyle()) // Mantém o visual do card sem o azul padrão de link
                                }
                            }
                            .padding(.top, 10)
                        }
                    }
                }
                .padding(20)
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}


struct EditarCriancaView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var crianca: Crianca
    
    // ⚠️ Computada para validar se o nome não contém apenas espaços ou está vazio
    private var nomeEstaVazio: Bool {
        crianca.nome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.fundo.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Editar Perfil")
                    .font(FontesDoApp.xBold(tamanho: 28))
                    .foregroundColor(.roxoTab)
                    .padding(.top, 20)
                
                // Campos de Entrada
                VStack(alignment: .leading, spacing: 12) {
                    Text("Nome")
                        .font(FontesDoApp.xBold(tamanho: 16))
                        .foregroundColor(.primary)
                    
                    TextField("Nome da criança", text: $crianca.nome)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.sombra)))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.roxoTab.opacity(0.3), lineWidth: 1))
                    
                    Text("Idade")
                        .font(FontesDoApp.xBold(tamanho: 16))
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                    
                    // 🚀 Limita o intervalo estritamente entre 4 e 10 anos
                    Stepper("\(crianca.idade) anos", value: $crianca.idade, in: 4...10)
                        .font(FontesDoApp.x(tamanho: 18))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.sombra)))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.roxoTab.opacity(0.3), lineWidth: 1))
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Botão de Excluir
                Button(action: excluirCrianca) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Excluir Criança")
                    }
                    .font(FontesDoApp.xBold(tamanho: 16))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 100).stroke(Color.red, lineWidth: 2))
                }
                .padding(.horizontal, 24)
                
                // Botão de Salvar
                Button(action: { dismiss() }) {
                    Text("Salvar Alterações")
                        .font(FontesDoApp.xBold(tamanho: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.roxoTab.cornerRadius(100))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                .disabled(nomeEstaVazio) // 🛑 Desabilita o botão se o nome for inválido
                .opacity(nomeEstaVazio ? 0.4 : 1.0) // 👁️ Feedback visual translúcido
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func excluirCrianca() {
        context.delete(crianca)
        try? context.save()
        dismiss()
    }
}





#Preview {
    if let dbPath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
        InserirSenhaView()
            .modelContainer(
                for: [
                    Crianca.self, Responsavel.self, Avatar.self,
                    Livro.self, LivroVersaoNivel.self, ConteudoLinha.self,
                    Trecho.self, Atividade.self,
                    AtividadeMultiplaEscolha.self,
                    AtividadeDesembaralhar.self
                ],
                inMemory: false,
                sqliteDatabasePath: dbPath
            )
    } else {
        ContentUnavailableView("Banco db.sqlite não encontrado no Bundle", systemImage: "exclamationmark.triangle")
    }
}


