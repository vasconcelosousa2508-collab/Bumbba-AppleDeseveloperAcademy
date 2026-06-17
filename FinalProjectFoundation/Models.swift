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
@SQLiteTable("Livro_Versao_Linha")
class LivroVersaoLinha: Identifiable {
    // Como o SwiftData exige uma Primary Key conceitual, mapeamos o id_versao como a propriedade id principal
    @SQLiteColumn("id_versao")
    var id: Int
    
    @SQLiteColumn("id_livro")
    var idLivro: Int
    
    @SQLiteColumn("faixa_etaria")
    var faixaEtaria: String // Se no seu banco for número (ex: 4, 6), mude para Int
    
    var concluido: Int // Bancos SQLite costumam salvar booleanos como 0 (falso) ou 1 (verdadeiro)

    init(id: Int, idLivro: Int, faixaEtaria: String, concluido: Int) {
        self.id = id
        self.idLivro = idLivro
        self.faixaEtaria = faixaEtaria
        self.concluido = concluido
    }
}

@Model
@SQLiteTable("Conteudo_Linha")
class ConteudoLinha: Identifiable {
    @SQLiteColumn("id_linha")
    var id: Int
    
    @SQLiteColumn("id_versao")
    var idVersao: Int
    
    @SQLiteColumn("ordem_posicao")
    var ordemPosicao: Int
    
    @SQLiteColumn("id_trecho")
    var idTrecho: Int? // Opcional, pois uma linha pode ser uma atividade em vez de texto
    
    @SQLiteColumn("id_atividade")
    var idAtividade: Int? // Opcional, pois uma linha pode ser um trecho de texto em vez de atividade

    init(id: Int, idVersao: Int, ordemPosicao: Int, idTrecho: Int? = nil, idAtividade: Int? = nil) {
        self.id = id
        self.idVersao = idVersao
        self.ordemPosicao = ordemPosicao
        self.idTrecho = idTrecho
        self.idAtividade = idAtividade
    }
}

// MARK: - Modelo Trecho
@Model
@SQLiteTable("Trecho")
class Trecho: Identifiable {
    @SQLiteColumn("id_trecho")
    var id: Int
    
    var texto: String

    init(id: Int, texto: String) {
        self.id = id
        self.texto = texto
    }
}

// MARK: - Modelo Atividade
@Model
@SQLiteTable("Atividade")
class Atividade: Identifiable {
    @SQLiteColumn("id_atividade")
    var id: Int
    
    var categoria: String
    var instrucao: String
    
    init(id: Int, categoria: String, instrucao: String) {
        self.id = id
        self.categoria = categoria
        self.instrucao = instrucao
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
    
    // CORREÇÃO: Corrigido o nome da coluna de "avatar" para "id_avatar"
    // CORREÇÃO: Alterado de String para Int conforme o retorno do seu banco
    @SQLiteColumn("id_avatar")
    var idAvatar: Int

    init(id: Int, nome: String, idade: Int, idResponsavel: Int, idAvatar: Int) {
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
    // CORREÇÃO: Alterado de String para Int para bater com a chave estrangeira da Crianca
    @SQLiteColumn("id_avatar")
    var id: Int
    
    var imagem: Data

    init(id: Int, imagem: Data) {
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
