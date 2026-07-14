import os
import json

# Define o caminho da pasta onde estão os arquivos JSON
pasta_arquivos = '.'

# Lista de todos os atributos obrigatórios que devem existir em cada gíria
atributos_obrigatorios = {
    "nome", "variacoes", "classe_gramatical", "significado", "tags", 
    "permissao", "impacto", "exemplo_correto", "exemplos_incorretos", 
    "significados_incorretos"
}

print("--- Relatório Detalhado de Validação dos JSONs ---\n")

for nome_arquivo in os.listdir(pasta_arquivos):
    if nome_arquivo.endswith('.json'):
        caminho_completo = os.path.join(pasta_arquivos, nome_arquivo)
        nome_limpo = os.path.splitext(nome_arquivo)[0]
        
        try:
            with open(caminho_completo, 'r', encoding='utf-8') as arquivo:
                dados = json.load(arquivo)
                
                lista_girias = []
                # Detecta a lista de dados no JSON
                if isinstance(dados, list):
                    lista_girias = dados
                elif isinstance(dados, dict):
                    for valor in dados.values():
                        if isinstance(valor, list):
                            lista_girias = valor
                            break
                
                total_girias = len(lista_girias)
                
                # Validação de estrutura (atributos faltantes)
                erros_estrutura = []
                for indice, giria in enumerate(lista_girias):
                    if not isinstance(giria, dict):
                        erros_estrutura.append(f"Item na posição {indice} não é um objeto válido.")
                        continue
                    
                    # Identifica quais atributos obrigatórios estão faltando neste item
                    chaves_presentes = set(giria.keys())
                    faltantes = atributos_obrigatorios - chaves_presentes
                    if faltantes:
                        # Tenta pegar o nome da gíria para facilitar a identificação do erro
                        nome_giria = giria.get("nome", f"Item {indice}")
                        erros_estrutura.append(f"Na gíria '{nome_giria}', faltam os atributos: {list(faltantes)}")

                # Define o status do intervalo de quantidade (30 a 50)
                intervalo_ok = 30 <= total_girias <= 50
                status_quantidade = "OK" if intervalo_ok else "FORA DO INTERVALO (30-50)"
                
                # Exibe o resultado do arquivo
                if intervalo_ok and not erros_estrutura:
                    print(f"🟢 {nome_limpo}: OK | Quantidade: {total_girias} | Estrutura: Perfeita")
                else:
                    print(f"🔴 {nome_limpo}: ERRO")
                    print(f"   -> Quantidade de gírias: {total_girias} ({status_quantidade})")
                    if erros_estrutura:
                        print("   -> Problemas de estrutura encontrados:")
                        for erro in erros_estrutura[:5]:  # Limita a exibir os primeiros 5 erros para não lotar o terminal
                            print(f"      - {erro}")
                        if len(erros_estrutura) > 5:
                            print(f"      - ... e mais {len(erros_estrutura) - 5} erro(s) de estrutura.")
                    else:
                        print("   -> Estrutura: Perfeita (todos os atributos estão presentes)")
                print("-" * 50)
                
        except Exception as e:
            print(f"⚠️ Erro crítico ao ler o arquivo {nome_arquivo}: {e}")
            print("-" * 50)