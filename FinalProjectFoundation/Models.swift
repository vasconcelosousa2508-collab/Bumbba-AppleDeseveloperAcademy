import SwiftUI
import SwiftData
import SwiftDataSQLite

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
@SQLiteTable("Livro_Versao_Nivel") // CORRIGIDO PARA O NOME REAL DO BANCO
class LivroVersaoNivel: Identifiable {
    @SQLiteColumn("id_versao")
    var id: Int
    
    @SQLiteColumn("id_livro")
    var idLivro: Int
    
    @SQLiteColumn("faixa_etaria")
    var faixaEtaria: String
    
    var concluido: Int

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





@Model
@SQLiteTable("Atividade")
class Atividade: Identifiable {
    @SQLiteColumn("id_atividade")
    var id: Int
    
    var categoria: String
    var instrucao: String // O enunciado da questão
    
    init(id: Int, categoria: String, instrucao: String) {
        self.id = id
        self.categoria = categoria
        self.instrucao = instrucao
    }
}


@Model
@SQLiteTable("Atividade_Multipla_Escolha")
class AtividadeMultiplaEscolha: Identifiable {
    
    @SQLiteColumn("id_atv_me")
    var id: Int
    
    @SQLiteColumn("id_atividade")
    var idAtividade: Int
    
    // Texto puro do DB Browser (Ex: "Opção A;Opção B;Opção C")
    // O gerador vai mapear isso aqui perfeitamente e sem erros
    @SQLiteColumn("opcoes")
    var opcoes: String
    
    @SQLiteColumn("resposta_correta")
    var respostaCorreta: Int
    
    // MARK: - Propriedade Computada para o SwiftUI
    // Como NÃO tem @SQLiteColumn, o gerador de código vai ignorar essa propriedade!
    var listaOpcoes: [String] {
        get {
            if opcoes.isEmpty { return [] }
            return opcoes.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        }
        set {
            self.opcoes = newValue.joined(separator: ";")
        }
    }
    
    // MARK: - Inicializador
    init(id: Int, idAtividade: Int, opcoes: String, respostaCorreta: Int) {
        self.id = id
        self.idAtividade = idAtividade
        self.opcoes = opcoes
        self.respostaCorreta = respostaCorreta
    }
}
