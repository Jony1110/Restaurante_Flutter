import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
// Jonathan Frias;

class EmailService {
  final String username = 'jonathanjosefriasmartinez11@gmail.com'; 
  
  Future<void> sendReservationEmail({
    required String recipientEmail,
    required String nombreCliente,
    required String restaurante,
    required String sucursal,
    required String hora,
    required int cantidadPersonas,
  }) async {
    
    final smtpServer = gmail(username, 'czmmbngzqdoqlywl');

    
    final message = Message()
      ..from = Address(username, 'Sistema de Reservaciones')
      ..recipients.add(recipientEmail) 
      ..subject = 'Confirmación de Reservación para $nombreCliente'
      ..text = '''
      ¡Hola $nombreCliente!

      Gracias por tu reservación en $restaurante.

      Detalles de tu reservación:
      - Sucursal: $sucursal
      - Hora: $hora
      - Número de personas: $cantidadPersonas

      Te esperamos en nuestra sucursal.

      ¡Saludos!
      ''';

    try {
      
      final sendReport = await send(message, smtpServer);
      print('Correo enviado: ${sendReport.toString()}');
    } on MailerException catch (e) {
      
      print('Error al enviar correo: ${e.toString()}');
      for (var p in e.problems) {
        print('Problema: ${p.code}: ${p.msg}');
      }
    } catch (e) {
      
      print('Error inesperado: ${e.toString()}');
    }
  }
}
