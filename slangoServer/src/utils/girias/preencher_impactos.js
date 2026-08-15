const fs = require('fs');
const path = require('path');

// Altere para './girias' se estiver executando o script fora da pasta girias
const pastaGirias = '.';

fs.readdirSync(pastaGirias).forEach(file => {
  // Ignora arquivos que não sejam .json
  if (!file.endsWith('.json')) return;

  const filePath = path.join(pastaGirias, file);

  try {
    const rawData = fs.readFileSync(filePath, 'utf8');
    const data = JSON.parse(rawData);

    // Identifica onde está o Array de gírias
    let giriasArray = null;
    if (Array.isArray(data)) {
      giriasArray = data;
    } else if (typeof data === 'object' && data !== null) {
      const chaveArray = Object.keys(data).find(key => Array.isArray(data[key]));
      if (chaveArray) {
        giriasArray = data[chaveArray];
      }
    }

    if (!giriasArray) {
      console.log(`⚠️ Nenhum array de gírias encontrado em: ${file}`);
      return;
    }

    let alterado = false;

    giriasArray.forEach(giria => {
      if (giria && typeof giria === 'object') {
        
        // 1. Se tem a justificativa da sua amiga (em antigo, cotidiano, jogos):
        if (giria.justificativa) {
          giria.impacto_motivo = giria.justificativa;
          delete giria.justificativa; // Mantém o texto e ajusta a chave
          alterado = true;
        } 
        // 2. Se não tem justificativa (ou se tinha o texto gerado anteriormente):
        else if (!giria.impacto_motivo || giria.impacto_motivo.startsWith('Esta gíria possui conotação')) {
          giria.impacto_motivo = "vazio";
          alterado = true;
        }

      }
    });

    if (alterado) {
      fs.writeFileSync(filePath, JSON.stringify(data, null, 2), 'utf8');
      console.log(`✅ Atualizado: ${file}`);
    } else {
      console.log(`ℹ️ Sem alterações necessárias em: ${file}`);
    }
  } catch (err) {
    console.error(`❌ Erro ao processar ${file}:`, err.message);
  }
});

console.log("\n✨ Processamento concluído! Os JSONs foram marcados com 'vazio' onde faltava justificativa.");