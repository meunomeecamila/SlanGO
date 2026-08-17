/**
 * Extrai uma mensagem de erro segura pra mandar pro cliente.
 * Cobre o caso de o erro não ser uma instância de Error de verdade
 * (ex: objeto vindo do Supabase sem .message, ou algo lançado como string)
 * — que é o que fazia `res.json({ erro: error })` virar `{}` no cliente.
 */
export function mensagemErro(error: unknown, fallback = 'Erro interno no servidor.'): string {
    if (error instanceof Error && error.message) return error.message;
    if (typeof error === 'string' && error) return error;
    if (error && typeof error === 'object' && 'message' in error && typeof (error as any).message === 'string') {
        return (error as any).message;
    }
    return fallback;
}

/**
 * Loga o erro completo no servidor (aparece no Render/console), com um
 * rótulo pra identificar de onde veio. Sempre chamar isso ANTES de
 * responder com erro genérico pro cliente.
 */
export function logarErro(rotulo: string, error: unknown) {
    console.error(`[${rotulo}]`, error);
}