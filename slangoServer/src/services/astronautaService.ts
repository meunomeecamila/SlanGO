import { supabase } from '../dbConnection';
import { Astronauta } from '../types/Jogo';

/** Lista todos os astronautas disponíveis. Todos são livres, sem desbloqueio. */
export async function listarAstronautas(): Promise<Astronauta[]> {
  const { data, error } = await supabase
    .from('Astronauta')
    .select('id, nome, url_astronauta')
    .order('id', { ascending: true });

  if (error) throw new Error(error.message);
  return data ?? [];
}

/**
 * Atualiza o astronauta escolhido pelo usuário. Não há restrição de
 * progresso — qualquer usuário pode trocar para qualquer astronauta
 * a qualquer momento.
 * Lança 'ASTRONAUTA_INVALIDO' se o id não existir.
 */
export async function atualizarAvatarUsuario(
  idUser: number,
  idAstronauta: number
): Promise<void> {
  const { data: astronauta, error: erroBusca } = await supabase
    .from('Astronauta')
    .select('id')
    .eq('id', idAstronauta)
    .maybeSingle();

  if (erroBusca) throw new Error(erroBusca.message);
  if (!astronauta) throw new Error('ASTRONAUTA_INVALIDO');

  const { error } = await supabase
    .from('User')
    .update({ id_Astronauta: idAstronauta })
    .eq('id', idUser);

  if (error) throw new Error(error.message);
}