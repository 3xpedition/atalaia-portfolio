/**
 * Quebras naturais de Jenks: as faixas de cor do mapa do concurso.
 *
 * Por que não faixas iguais nem quartis:
 * - faixas iguais do máximo: um estado muito acima dos outros empurra o
 *   primeiro corte para cima e o resto do país inteiro cai na mesma cor;
 * - quartis: numa lista curta, valores muito distantes acabam na mesma faixa.
 * Jenks escolhe os cortes que minimizam a variância dentro de cada faixa,
 * então a cor separa grupos que são de fato diferentes.
 *
 * Os valores do teste são fictícios.
 */
(function (raiz) {
    'use strict';

    /**
     * Calcula os limites das faixas.
     *
     * @param {number[]} valores Valores a classificar; não numéricos são ignorados.
     * @param {number} classes Quantidade de faixas desejada.
     * @returns {number[]} classes + 1 limites, do menor ao maior valor.
     */
    function quebrasNaturais(valores, classes) {
        const dados = valores.filter(Number.isFinite).slice().sort((a, b) => a - b);
        const n = dados.length;
        if (n === 0) {
            return [];
        }

        // Não há como ter mais faixas do que valores distintos.
        const k = Math.min(classes, new Set(dados).size);
        if (k <= 1) {
            return [dados[0], dados[n - 1]];
        }

        // inicio[i][j]: onde começa a última faixa quando os i primeiros valores
        // são divididos em j faixas. custo[i][j]: variância total dessa divisão.
        const inicio = [];
        const custo = [];
        for (let i = 0; i <= n; i++) {
            inicio.push(new Array(k + 1).fill(0));
            custo.push(new Array(k + 1).fill(i < 2 ? 0 : Infinity));
        }
        for (let j = 1; j <= k; j++) {
            inicio[1][j] = 1;
        }

        for (let i = 2; i <= n; i++) {
            let soma = 0;
            let somaQuadrados = 0;
            let variancia = 0;

            // Testa cada ponto de início possível para a última faixa.
            for (let m = 1; m <= i; m++) {
                const primeiro = i - m + 1;
                const valor = dados[primeiro - 1];
                soma += valor;
                somaQuadrados += valor * valor;
                variancia = somaQuadrados - (soma * soma) / m;

                const anterior = primeiro - 1;
                if (anterior !== 0) {
                    for (let j = 2; j <= k; j++) {
                        const candidato = variancia + custo[anterior][j - 1];
                        if (custo[i][j] >= candidato) {
                            inicio[i][j] = primeiro;
                            custo[i][j] = candidato;
                        }
                    }
                }
            }

            inicio[i][1] = 1;
            custo[i][1] = variancia;
        }

        const limites = new Array(k + 1);
        limites[0] = dados[0];
        limites[k] = dados[n - 1];

        let fim = n;
        for (let j = k; j >= 2; j--) {
            const primeiroDaFaixa = inicio[fim][j];
            limites[j - 1] = dados[primeiroDaFaixa - 2];
            fim = primeiroDaFaixa - 1;
        }

        return limites;
    }

    /**
     * Índice da faixa de um valor (0 = mais baixa).
     *
     * @param {number} valor
     * @param {number[]} limites Retorno de quebrasNaturais.
     * @returns {number}
     */
    function faixaDoValor(valor, limites) {
        for (let i = 1; i < limites.length - 1; i++) {
            if (valor <= limites[i]) {
                return i - 1;
            }
        }
        return Math.max(0, limites.length - 2);
    }

    const api = { quebrasNaturais, faixaDoValor };

    if (typeof module === 'object' && module.exports) {
        module.exports = api;
    } else {
        raiz.QuebrasNaturais = api;
    }
})(typeof window !== 'undefined' ? window : globalThis);
