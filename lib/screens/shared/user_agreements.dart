import 'package:flutter/material.dart';
import 'package:kaamsay/components/buttons.dart';
import 'package:velocity_x/velocity_x.dart';

Future openAgreeDialog(context) async {
  bool termsAccepted = false;
  var result = await Navigator.pushNamed(
    context,
    CreateAgreement.routeName,
  );

  if (result != null) {
    termsAccepted = true;
  } else {
    termsAccepted = false;
  }
  return termsAccepted;
}

class CreateAgreement extends StatelessWidget {
  static const String routeName = '/agreement';
  final String pdfText = """
By taking services from the KaamSay application, you seldom confirm your association and agreement with the terms of service provided in the Terms and Conditions highlighted below. These terms apply to all users obtaining services from our application as well as any secondary communication link binding them with the application bieng Electronic-mails or Phone-numbers
Under no circumstance, should our application be accountable for any special, incidental, direct or indirect damages which wholeheartedly includes any loss of data or profit due to any type of misuse or inability to use the application. 
Our team will not be liable for any consequence that may occur during the period of your usage of the applications provided resources. We also reserve the full rights of changing our prices, authorizations and the availability of services provided in the near future. 

License:
This application grants you a complete, non-refundable access to use and benefit from the services and information provided on the system with respect to the posed Terms and Conditions. Furthermore, by agreeing to the given Terms and Conditions, you are signing a virtual contract between the application and yourself. This contract therefore grants you exclusive, non-refundable authorized services enabling you to effectively henceforth access and download the information and services provided on the platform with strict vigilance towards the agreements heighted terms. 

Payment:
KaamSay Application does make use of online payments. All the payments are either collected by any one of the Pakistan’s used online payment services (JazzCash or EasyPaisa) which will be integrated with the app. The company is also not liable to providing services once payments for such service have been delayed. Furthermore, all payment must be complete and on-time and by no means is the team in support of negotiations and late payments.

Misuse of Services:
The services provided through the application are to be used within the proposed line of conduct displayed through the Terms and Conditions of the application. Misuse of services provided can result into serious counter actions and banning of provided information and resources. Furthermore, if a user continues to misuse the access given to them, effective termination will occur. 
Additional terms

Professional information: 
The application in no context provides users with professional information, it seldom locates them and finds corresponding services and information which may help in their situation. The application is merely a platform used for pinpointing services and jobs.

Communications:
The application makes use of third parties after which a user has selected and payed for a given service, the communication between the user and the third party will be strictly confidential from the likeness the company. Therefore, the company is in no way answerable to any damages that may occur in that communication.

Passwords and content
The users of this application are compelled to manage their passwords as well as their content. Irrelevant content will be monitored and warnings will be given. 

Definitions and Key terms

Company: This refers to the application i.e. the Labor app. 
Users: Those users who have registered and paid to acquire the resources of the application. 
Country: The application is applied to users living in Pakistan and all services and information provided is related to the chosen country.
Device: Any device connected to a stable internet connection can make use of the application.
IP address: Each devices IP address helps to pinpoint their location which allows the application to effectively display the relevant services and information. 
Personal data: Data which is taken from users having both a direct and indirect link to the user.
""";

  const CreateAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        title: const Text('KaamSay PK'),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop('User Agreed');
              },
              child: const Icon(
                Icons.check,
                color: Colors.white,
              )),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            'Terms and Conditions '.text.xl2.bold.make(),
            'Revised and updated on 24-11-2021'
                .text
                .color(Colors.grey)
                .sm
                .make(),
            16.heightBox,
            const BuildHeading(heading: 'General Terms'),
            Text(pdfText),
            SizedBox(
              width: double.infinity,
              child: GlowingElevatedButton(
                buttonText: 'I Accept the T&Cs',
                onPressed: () {
                  Navigator.of(context).pop('User Agreed');
                },
              ),
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ).p(16),
      ),
    );
  }
}

class BuildHeading extends StatelessWidget {
  const BuildHeading({Key? key, required this.heading}) : super(key: key);
  final String heading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            heading,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
