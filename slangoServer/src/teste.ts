import readline from "readline";
import { prepararRodadaAleatoria } from "./services/mundoService";

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

function perguntar(texto: string): Promise<string> {
    return new Promise((resolve) => {
        rl.question(texto, resolve);
    });
}

async function iniciar() {
    console.clear();
    console.log("===================================");
    console.log("        TESTE DO SLANGO");
    console.log("===================================\n");

    const mundo = await perguntar(
        "Digite o mundo (redessociais, geek, jogos, kpop, etc): "
    );

    try {
        const rodada = await prepararRodadaAleatoria(mundo);

        console.log(`\n${rodada.nome}`);
        console.log(`${rodada.descricao}\n`);

        let pontos = 0;

        for (let i = 0; i < rodada.todasAsPerguntas.length; i++) {
            const pergunta = rodada.todasAsPerguntas[i];

            console.log("--------------------------------");
            console.log(`Pergunta ${i + 1}`);
            console.log(pergunta.pergunta);
            console.log("");

            pergunta.alternativas.forEach((alt, index) => {
                console.log(`${index + 1}) ${alt.texto}`);
            });

            const resposta = Number(
                await perguntar("\nResposta: ")
            );

            if (pergunta.alternativas[resposta - 1]?.correta) {
                console.log("✅ Correto!\n");
                pontos++;
            } else {
                console.log("❌ Errado!");

                const correta = pergunta.alternativas.find(a => a.correta);

                console.log(`Resposta correta: ${correta?.texto}\n`);
            }
        }

        console.log("===================================");
        console.log(`Pontuação: ${pontos}/9`);

        if (pontos === 9) {
            console.log("🏆 Item customizável desbloqueado!");
        } else {
            console.log("Tente novamente.");
        }

    } catch (e: any) {
        console.log("\nErro:");
        console.log(e.message);
    }

    rl.close();
}

iniciar();