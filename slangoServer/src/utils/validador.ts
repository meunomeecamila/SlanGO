export function emailValido(email: string): boolean {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

export function senhaValida(senha: string): { valida: boolean; erro?: string } {
    if (senha.length < 8) {
        return { valida: false, erro: 'A senha deve ter no mínimo 8 caracteres.' };
    }

    if (!/[A-Z]/.test(senha)) {
        return { valida: false, erro: 'A senha deve conter pelo menos uma letra maiúscula.' };
    }

    if (!/[0-9]/.test(senha)) {
        return { valida: false, erro: 'A senha deve conter pelo menos um número.' };
    }

    if (!/[!@#$%^&*(),.?":{}|<>_\-+=[\]/;'`~\\]/.test(senha)) {
        return { valida: false, erro: 'A senha deve conter pelo menos um caractere especial.' };
    }

    return { valida: true };
}