import SwiftUI
import SwiftData
import SwiftDataSQLite


@Model
@SQLiteTable("Livro")
class Livro: Identifiable {
    @SQLiteColumn("id_livro")
    var id: Int
    var titulo: String
    
    var capa: Data
    
    init(id: Int, titulo: String, capa: Data) {
        self.id = id
        self.titulo = titulo
        self.capa = capa
    }
}


@Model
@SQLiteTable("Responsavel")
class Responsavel: Identifiable {
    @SQLiteColumn("id_responsavel")
    var id: Int
    
    var senha: String

    init(id: Int, senha: String) {
        self.id = id
        self.senha = senha
    }
}

@Model
@SQLiteTable("Crianca")
class Crianca: Identifiable {
    @SQLiteColumn("id_crianca")
    var id: Int
    
    var nome: String
    var idade: Int
    
    @SQLiteColumn("id_responsavel")
    var idResponsavel: Int
    
    // Mapeado perfeitamente para a coluna do seu log
    @SQLiteColumn("avatar")
    var idAvatar: String

    init(id: Int, nome: String, idade: Int, idResponsavel: Int, idAvatar: String) {
        self.id = id
        self.nome = nome
        self.idade = idade
        self.idResponsavel = idResponsavel
        self.idAvatar = idAvatar
    }
}

@Model
@SQLiteTable("Avatar")
class Avatar: Identifiable {
    @SQLiteColumn("id_avatar")
    var id: String
    
    var imagem: Data

    init(id: String, imagem: Data) {
        self.id = id
        self.imagem = imagem
    }
}







// 1. Tipos de atividades disponíveis
enum TipoAtividade {
    case seguirPontilhado
    case multiplaEscolha(pergunta: String, opcoes: [String], respostaCorreta: String)
    case desembaralharLetras(palavraCerta: String, letrasEmbaralhadas: [String])
    case desembaralharFrase(fraseCerta: String, palavrasEmbaralhadas: [String])
}

// 2. Modelo da Atividade
struct AtividadeItem: Identifiable {
    let id = UUID()
    let tipo: TipoAtividade
}

// 3. O elemento que vai na lista de rolagem (Pode ser Texto OU Atividade)
struct ElementoHistoria: Identifiable {
    let id = UUID() // Certifique-se de que está como 'let' e inicializado com UUID()
    let texto: String?
    let atividade: AtividadeItem?
}

// 4. Modelo do Livro
struct Livro2: Identifiable {
    let id: Int
    let titulo: String
    let imagemCapa: String
    let conteudoPorIdade: [String: [ElementoHistoria]] // Idade -> Lista misturada de textos e atividades
}

// 5. Dados manuais com as estrofes e suas respectivas atividades
enum DadosManuais {
    static let listaLivros: [Livro2] = [
        Livro2(
            id: 1,
            titulo: "Se Essa Rua Fosse Minha",
            imagemCapa: "capa_rua",
            conteudoPorIdade: [
                "4 a 5": [
                    ElementoHistoria(texto: "Se essa rua, se essa rua fosse minha... Eu mandava, eu mandava ladrilhar.", atividade: nil),
                    
                    // Atividade 1: Seguir o pontilhado (coordenação motora)
                    ElementoHistoria(texto: nil, atividade: AtividadeItem(tipo: .seguirPontilhado)),
                    
                    ElementoHistoria(texto: "Com pedrinhas, com pedrinhas de brilhantes... Para o meu, para o meu amor passar.", atividade: nil),
                    
                    // Atividade 2: Desembaralhar letras simples
                    ElementoHistoria(texto: nil, atividade: AtividadeItem(tipo: .desembaralharLetras(palavraCerta: "AMOR", letrasEmbaralhadas: ["M", "R", "A", "O"])))
                ],
                
                "6 a 7": [
                    ElementoHistoria(texto: "Nesta rua, nesta rua tem um bosque, que se chama, que se chama solidão.", atividade: nil),
                    
                    // Atividade 3: Múltipla Escolha
                    ElementoHistoria(texto: nil, atividade: AtividadeItem(tipo: .multiplaEscolha(
                        pergunta: "Qual é o nome do bosque que fica na rua?",
                        opcoes: ["Felicidade", "Solidão", "Brilhante", "Amor"],
                        respostaCorreta: "Solidão"
                    ))),
                    
                    ElementoHistoria(texto: "Dentro dele, dentro dele mora um anjo, que roubou, que roubou meu coração.", atividade: nil),
                    
                    // Atividade 4: Desembaralhar Frase
                    ElementoHistoria(texto: nil, atividade: AtividadeItem(tipo: .desembaralharFrase(
                        fraseCerta: "O anjo mora no bosque",
                        palavrasEmbaralhadas: ["no", "mora", "O", "bosque", "anjo"]
                    )))
                ],
                
                "8 a 10": [
                    ElementoHistoria(texto: "Se essa rua, se essa rua fosse minha, eu mandava, eu mandava ladrilhar. Com pedrinhas, com pedrinhas de brilhantes, para o meu, para o meu amor passar.", atividade: nil),
                    
                    ElementoHistoria(texto: nil, atividade: AtividadeItem(tipo: .multiplaEscolha(
                        pergunta: "O que o eu lírico mandaria fazer com a rua?",
                        opcoes: ["Pintar de azul", "Ladrilhar com brilhantes", "Plantar árvores", "Fechar para carros"],
                        respostaCorreta: "Ladrilhar com brilhantes"
                    )))
                ]
            ]
        )
    ]
}
