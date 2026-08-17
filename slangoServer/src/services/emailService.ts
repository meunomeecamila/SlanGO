import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);
const URL_APP = process.env.URL_APP as string; // ex: https://slango.app

export async function enviarEmailConfirmacao(email: string, token: string): Promise<void> {
    const link = `${URL_APP}/confirmar-email?token=${token}`;

    const { error } = await resend.emails.send({
        from: 'SlanGO <noreply@slango.app>',
        to: email,
        subject: 'Confirme seu cadastro no SlanGO',
        html: `
            <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto; background-color: #1F1035; color: #ffffff; padding: 32px; border-radius: 18px;">
                <h2 style="color: #57E6D8; margin-top: 0;">Bem-vindo(a) ao SlanGO!</h2>
                <p style="color: #E6E1F5;">Clique no botão abaixo para confirmar seu cadastro e começar sua aventura no universo das gírias:</p>
                <div style="text-align: center; margin: 32px 0;">
                    <a href="${link}" style="display: inline-block; background: #7C5CFF; color: #fff; padding: 14px 28px; border-radius: 30px; text-decoration: none; font-weight: bold;">
                        Confirmar email
                    </a>
                </div>
                <p style="color: #A599C7; font-size: 12px;">
                    Este link expira em 1 hora. Se você não criou essa conta, ignore este email.
                </p>
            </div>
        `
    });

    if (error) throw new Error('ERRO_ENVIO_EMAIL');
}
