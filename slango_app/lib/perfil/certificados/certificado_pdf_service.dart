import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'certificado_mundo_data.dart';

/// ============================================================
/// SERVIÇO DE PDFs DO CERTIFICADO
/// ============================================================
/// Duas operações independentes:
///   1) [baixarPdfOficialDoMundo]  -> abre/baixa o PDF ESTÁTICO do mundo.
///   2) [baixarPdfDaMensagem]      -> gera um PDF com a mensagem do ETzinho.
///
/// Se um dia você quiser manter apenas UMA das opções, basta remover o botão
/// correspondente em `painel_certificado.dart` (veja os TODOs de lá) e, se
/// quiser faxina completa, apagar também o método equivalente aqui.
class CertificadoPdfService {
  const CertificadoPdfService._();

  /// (1) PDF OFICIAL — arquivo estático que vem junto do app.
  ///
  /// TODO: o caminho vem de `CertificadoMundo.pdfAsset`
  /// (edite em `certificado_mundo_data.dart`).
  /// TODO: para servir de uma URL remota em vez de asset local, troque o
  /// bloco abaixo por algo como:
  ///   final resposta = await http.get(Uri.parse(certificado.pdfAsset));
  ///   final bytes = resposta.bodyBytes;
  static Future<void> baixarPdfOficialDoMundo(
    CertificadoMundo certificado,
  ) async {
    final dados = await rootBundle.load(certificado.pdfAsset);
    final bytes = dados.buffer.asUint8List();

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'certificado_${certificado.slug}.pdf',
    );
  }

  /// (2) PDF DA MENSAGEM — gerado na hora a partir do texto do ETzinho.
  static Future<void> baixarPdfDaMensagem(
    CertificadoMundo certificado,
  ) async {
    final bytes = await _gerarPdfDaMensagem(certificado);

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'mensagem_${certificado.slug}.pdf',
    );
  }

  static Future<Uint8List> _gerarPdfDaMensagem(
    CertificadoMundo certificado,
  ) async {
    final documento = pw.Document();
    final corPrimaria = PdfColor.fromInt(certificado.corPrimaria.value);

    documento.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(32),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: corPrimaria, width: 3),
              borderRadius: pw.BorderRadius.circular(16),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Recadinho do ETzinho',
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: corPrimaria,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  certificado.nome,
                  style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  certificado.mensagem,
                  style: const pw.TextStyle(fontSize: 14, lineSpacing: 4),
                ),
                pw.SizedBox(height: 28),
                pw.Text(
                  'Girias deste planeta: ${certificado.girias.join(' - ')}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: corPrimaria,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Spacer(),
                pw.Center(
                  child: pw.Text(
                    'Slango - explorando girias pela galaxia',
                    style: pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return documento.save();
  }
}
