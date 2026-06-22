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
    
    var concluido: Int
    
    init(id: Int, titulo: String, capa: Data, concluido: Int) {
        self.id = id
        self.titulo = titulo
        self.capa = capa
        self.concluido = concluido
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
    
    init(id: Int, idLivro: Int, faixaEtaria: String) {
        self.id = id
        self.idLivro = idLivro
        self.faixaEtaria = faixaEtaria
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

extension Trecho {
    var textoFormatado: Text {
        // Padrão que procura por "[imagem:QUALQUER_COISA]"
        // [imagem:(.*?)] captura o que estiver dentro dos parênteses
        let tagInicial = "[imagem:"
        let tagFinal = "]"
        
        // Verifica se o texto possui o padrão básico de imagem
        if texto.contains(tagInicial) && texto.contains(tagFinal) {
            let componentesIniciais = texto.components(separatedBy: tagInicial)
            
            // A primeira parte é tudo antes do primeiro '[imagem:'
            var resultadoFinal = Text(componentesIniciais.first ?? "")
            
            // Percorre o resto dos blocos quebrados pela tag
            for bloco in componentesIniciais.dropFirst() {
                let partesDoBloco = bloco.components(separatedBy: tagFinal)
                
                if partesDoBloco.count >= 2 {
                    let nomeImagem = partesDoBloco[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let textoRestante = partesDoBloco[1]
                    
                    // Concatena a imagem encontrada + o texto que veio depois dela
                    resultadoFinal = resultadoFinal + Text(Image(nomeImagem)) + Text(textoRestante)
                } else {
                    // Caso falte fechar o ']', reinsere o texto original do bloco truncado
                    resultadoFinal = resultadoFinal + Text(tagInicial + bloco)
                }
            }
            
            return resultadoFinal
        }
        
        // Se não tiver nenhuma tag de imagem, renderiza o texto puro
        return Text(texto)
    }
}



@Model
@SQLiteTable("Atividade")
class Atividade: Identifiable {
    @SQLiteColumn("id_atividade")
    var id: Int
    
    var categoria: String
    var instrucao: String // ➡️ A instrução subiu para a tabela mãe

    init(id: Int, categoria: String, instrucao: String) {
        self.id = id
        self.categoria = categoria
        self.instrucao = instrucao
    }
}

// MARK: - MODELO MULTIPLA ESCOLHA (Tabela Filha)
@Model
@SQLiteTable("Atividade_Multipla_Escolha")
class AtividadeMultiplaEscolha: Identifiable {
    @SQLiteColumn("id_atv_me")
    var id: Int
    
    @SQLiteColumn("id_atividade")
    var idAtividade: Int // Chave Estrangeira (FK)
    
    var opcoes: String
    
    @SQLiteColumn("resposta_correta")
    var respostaCorreta: Int // Índice numérico (0, 1, 2...)
    
    // ➡️ A propriedade 'instrucao' foi removida daqui!

    init(id: Int, idAtividade: Int, opcoes: String, respostaCorreta: Int) {
        self.id = id
        self.idAtividade = idAtividade
        self.opcoes = opcoes
        self.respostaCorreta = respostaCorreta
    }
}

extension AtividadeMultiplaEscolha {
    var listaDeOpcoes: [String] {
        let componentes = opcoes.components(separatedBy: ",")
        return componentes.map { item in
            item.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\"", with: "")
        }
    }
}


@Model
@SQLiteTable("Atividade_Desembaralhar")
class AtividadeDesembaralhar: Identifiable {
    @SQLiteColumn("id_atv_dsmb")
    var id: Int
    
    @SQLiteColumn("id_atividade")
    var idAtividade: Int // Chave Estrangeira (FK) conectando com a tabela Atividade
    
    /// Recebe os elementos misturados separados por vírgula.
    /// Exemplo: "mora, no, o anjo, bosque" ou "Q, U, E, B, O, S"
    var elementos: String
    
    /// Guarda a ordem correta baseada no texto exato ou nos índices esperados.
    /// Para facilitar a validação, podemos salvar a frase inteira certinha aqui.
    /// Exemplo: "o anjo mora no bosque" ou "BOSQUE"
    @SQLiteColumn("resposta_correta")
    var respostaCorreta: String

    init(id: Int, idAtividade: Int, elementos: String, respostaCorreta: String) {
        self.id = id
        self.idAtividade = idAtividade
        self.elementos = elementos
        self.respostaCorreta = respostaCorreta
    }
}

// MARK: - Extensão de Suporte (Helpers)
extension AtividadeDesembaralhar {
    
    /// Transforma a String do banco de dados em uma lista de strings limpa para os blocos da tela
    var listaDeElementos: [String] {
        let componentes = elementos.components(separatedBy: ",")
        return componentes.map { item in
            item.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\"", with: "")
        }
    }
}
