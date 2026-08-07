import { supabase } from '../dbConnection';
import { Item, ItemComStatus } from '../types/Jogo';

const LIMIAR_DESBLOQUEIO = 0.5; // 50% de progresso no mundo

/**
 * Verifica o progresso do usuário num mundo e desbloqueia
 * automaticamente os itens vinculados a esse mundo quando o
 * limiar é atingido. É seguro chamar isso toda vez que o
 * progresso é salvo — se o item já estiver desbloqueado, o
 * upsert simplesmente não faz nada (ignoreDuplicates).
 *
 * Chame esta função logo depois de fazer o upsert em user_mundo.
 */
export async function verificarEDesbloquearItens(
  idUser: number,
  idMundo: number,
  progresso: number
): Promise<void> {
  if (progresso < LIMIAR_DESBLOQUEIO) return;

  const { data: itensDoMundo, error: erroItens } = await supabase
    .from('Item')
    .select('id')
    .eq('id_Mundo', idMundo);

  if (erroItens) throw new Error(erroItens.message);
  if (!itensDoMundo || itensDoMundo.length === 0) return;

  const linhas = itensDoMundo.map((item) => ({
    id_item: item.id,
    id_user: idUser,
  }));

  const { error: erroInsercao } = await supabase
    .from('user_item')
    .upsert(linhas, { onConflict: 'id_item,id_user', ignoreDuplicates: true });

  if (erroInsercao) throw new Error(erroInsercao.message);
}

/**
 * Lista todos os itens do jogo, marcando quais o usuário já
 * desbloqueou e qual está equipado no momento. Usado na tela
 * de perfil para renderizar o grid com itens bloqueados/desbloqueados.
 */
export async function listarItensDoUsuario(idUser: number): Promise<ItemComStatus[]> {
  const { data: todosItens, error: erroItens } = await supabase
    .from('Item')
    .select('id, nome, url_item, id_Mundo')
    .order('id', { ascending: true });

  if (erroItens) throw new Error(erroItens.message);

  const { data: itensDoUsuario, error: erroUserItem } = await supabase
    .from('user_item')
    .select('id_item, equipado')
    .eq('id_user', idUser);

  if (erroUserItem) throw new Error(erroUserItem.message);

  const mapaPosse = new Map<number, boolean>();
  (itensDoUsuario ?? []).forEach((ui) => mapaPosse.set(ui.id_item, ui.equipado));

  return (todosItens ?? []).map((item: Item) => ({
    ...item,
    desbloqueado: mapaPosse.has(item.id),
    equipado: mapaPosse.get(item.id) ?? false,
  }));
}

/**
 * Equipa um item para o usuário. Garante que só exista um item
 * equipado por vez, desmarcando o anterior antes de marcar o novo.
 * Lança 'ITEM_NAO_DESBLOQUEADO' se o usuário ainda não tiver o item.
 */
export async function equiparItem(idUser: number, idItem: number): Promise<void> {
  const { data: posse, error: erroPosse } = await supabase
    .from('user_item')
    .select('id_item')
    .eq('id_user', idUser)
    .eq('id_item', idItem)
    .maybeSingle();

  if (erroPosse) throw new Error(erroPosse.message);
  if (!posse) throw new Error('ITEM_NAO_DESBLOQUEADO');

  const { error: erroDesmarcar } = await supabase
    .from('user_item')
    .update({ equipado: false })
    .eq('id_user', idUser);

  if (erroDesmarcar) throw new Error(erroDesmarcar.message);

  const { error: erroMarcar } = await supabase
    .from('user_item')
    .update({ equipado: true })
    .eq('id_user', idUser)
    .eq('id_item', idItem);

  if (erroMarcar) throw new Error(erroMarcar.message);
}