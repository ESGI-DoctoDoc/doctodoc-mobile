import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List<String> items;

  const BulletList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(fontSize: 16)),
                    Expanded(child: Text(item)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class TermsScreen extends StatelessWidget {
  static const String routeName = "/terms";

  static void navigateTo(BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conditions Générales d’Utilisation"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dernière mise à jour : 28 juin 2025",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) => RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    const TextSpan(
                      text:
                          "Les présentes Conditions Générales d’Utilisation (ci-après « CGU ») régissent l’accès et "
                          "l’utilisation de la plateforme Docto Doc (ci-après « la Plateforme »), éditée par Docto Doc, "
                          "société DOCTO DOC FRANCE au capital de 120 000 euros, immatriculée au RCS de Paris sous le numéro "
                          "120282839127, dont le siège social est ",
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "18 sur-vingt du Grand Projet, 01820, France",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "1. Objet",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("La Plateforme a pour objet de permettre aux utilisateurs de :"),
            SizedBox(height: 8),
            BulletList(items: [
              "Réserver des créneaux de rendez-vous,",
              "Gérer leurs réservations et consulter leur historique,",
              "Être notifiés et informés par email ou notification.",
            ]),
            SizedBox(height: 24),
            Text(
              "2. Accès au service",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "L’accès à la Plateforme est gratuit pour les utilisateurs. Il nécessite la création d’un compte personnel "
              "sécurisé via un identifiant et un mot de passe.",
            ),
            SizedBox(height: 8),
            Text("L’utilisateur s’engage à fournir des informations exactes et à jour lors de son inscription."),
            SizedBox(height: 24),
            Text(
              "3. Engagements de l’utilisateur",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("L’utilisateur s’engage à :"),
            SizedBox(height: 8),
            BulletList(items: [
              "Utiliser la Plateforme conformément aux lois et règlements en vigueur,",
              "Ne pas usurper l’identité d’un tiers,",
              "Respecter les règles de fonctionnement du service (ex. : libération automatique des créneaux à 11h, réservation selon les rôles, etc.),",
              "Ne pas tenter d’accéder aux données d’autres utilisateurs.",
            ]),
            SizedBox(height: 24),
            Text(
              "4. Responsabilités",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Responsabilité de l’utilisateur : L’utilisateur est responsable de l’usage qu’il fait de la Plateforme et des conséquences de ses actions.",
            ),
            SizedBox(height: 8),
            Text(
              "Responsabilité de l’éditeur : Docto Doc met tout en œuvre pour assurer la disponibilité et la sécurité du service.",
            ),
            SizedBox(height: 24),
            Text(
              "5. Données personnelles",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Les données personnelles sont traitées conformément à notre politique de confidentialité. "
              "L’utilisateur peut y accéder à tout moment pour en savoir plus sur ses droits.",
            ),
            SizedBox(height: 24),
            Text(
              "6. Modification des CGU",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Les présentes CGU peuvent être modifiées à tout moment. L’utilisateur sera informé en cas de changement "
              "important affectant ses droits ou obligations.",
            ),
            SizedBox(height: 24),
            Text(
              "7. Contact",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Pour toute question concernant les CGU, vous pouvez contacter notre support à l’adresse : support@doctodoc.fr.",
            ),
          ],
        ),
      ),
    );
  }
}
