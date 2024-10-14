import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // Method to send OTP email using SMTP with username and password
  static Future<void> sendOTP(String recipientEmail, String otp) async {
    String username = 'lyash031@rku.ac.in'; // Your email
    String password = 'L4950807';   // Your email password

    // Create an SMTP server
    final smtpServer = SmtpServer('smtp.gmail.com',
        port: 587,
        username: username,
        password: password,
        ignoreBadCertificate: true,
        ssl: false);

    // Create the email message
    final message = Message()
  ..from = Address(username, 'PayWise')
  ..recipients.add(recipientEmail)
  ..subject = 'Your OTP Code'
  ..html = '''
    <html>
      <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
          .container {
            background-color: #ffffff;
            border-radius: 8px;
            max-width: 600px;
            margin: auto;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
          }
          .header {
            background-color: #7f3dff;
            color: white;
            padding: 40px 0 30px;
            border-radius: 8px 8px 0 0;
            text-align: center;
          }
          .logo {
            width: 100px;
            height: auto;
          }
          .otp {
            font-size: 36px;
            color: #7f3dff;
            font-weight: bold;
          }
          .content {
            padding: 20px 40px;
          }
          .content h2 {
            text-align: center;
            color: #333333;
          }
          .content p {
            color: #666666;
            font-size: 18px;
          }
          .footer {
            background-color: #7f3dff;
            padding: 20px;
            text-align: center;
            color: white;
            font-size: 14px;
            border-radius: 0 0 8px 8px;
          }
          .footer p {
            margin: 10px 0;
          }
          .gmail-btn {
            margin-top: 10px;
            display: inline-block;
            margin-right: 10px;
          }
          .gmail-btn img {
            width: 20px;
            vertical-align: middle;
            margin-right: 8px;
          }
        </style>
      </head>
      <body style="font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4;">
        <div class="container">
          <div class="header">
            <img src="https://raw.githubusercontent.com/sarthak-dhaduk/PayWise/master/assets/img/logo2.png" alt="PayWise Logo" class="logo"/>
            <h1>PayWise</h1>
          </div>
          <div class="content">
            <h2>Your OTP Code</h2>
            <p>Use the following OTP to complete your password recovery process:</p>
            <div class="text-center my-4">
              <center><span class="otp">$otp</span></center>
            </div>
            <p>If you didn't request this, please ignore this email.</p>
          </div>
          <div class="footer">
            <p>PayWise &copy; 2024</p>
          </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
      </body>
    </html>
  ''';


    try {
      // Send the message
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n${e.toString()}');
    }
  }
}