import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../data/mes_donnees.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // COULEURS PROFESSIONNELLES
  static const Color navy = Color(0xFF14243A);
  static const Color blue = Color(0xFF2563EB);
  static const Color gold = Color(0xFFD6A84F);
  static const Color background = Color(0xFFF3F6FA);
  static const Color grey = Color(0xFF718096);

  // OUVRIR LES LIENS
  Future<void> _ouvrir(BuildContext context, Uri uri) async {
    try {
      final bool ok = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!ok && context.mounted) {
        _message(context, 'Impossible d’ouvrir ce lien.');
      }
    } catch (_) {
      if (context.mounted) {
        _message(context, 'Une erreur est survenue.');
      }
    }
  }

  // COPIER UNE COORDONNÉE
  Future<void> _copier(
    BuildContext context,
    String valeur,
  ) async {
    await Clipboard.setData(ClipboardData(text: valeur));

    if (context.mounted) {
      _message(context, 'Coordonnée copiée avec succès !');
    }
  }

  // MESSAGE DE NOTIFICATION
  void _message(BuildContext context, String texte) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(texte),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final tel = telephone.replaceAll(RegExp(r'\s+'), '');
    final mail = email.trim();

    final carte = Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': adresse,
      },
    );

    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          // EN-TÊTE
          SliverToBoxAdapter(
            child: _header(),
          ),

          // CONTENU
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 25, 18, 35),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'RESTONS EN CONTACT',
                  style: TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Vous pouvez me contacter directement '
                  'à travers les moyens suivants.',
                  style: TextStyle(
                    color: grey,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 22),

                // TELEPHONE
                _contactCard(
                  context: context,
                  icon: Icons.phone_in_talk_rounded,
                  title: 'Téléphone',
                  value: telephone,
                  description: 'Appeler directement',
                  color: const Color(0xFF2563EB),
                  action: Icons.call_rounded,
                  onTap: () => _ouvrir(
                    context,
                    Uri(scheme: 'tel', path: tel),
                  ),
                  onCopy: () => _copier(context, telephone),
                ),

                // SMS
                _contactCard(
                  context: context,
                  icon: Icons.sms_rounded,
                  title: 'Message SMS',
                  value: telephone,
                  description: 'Envoyer un message',
                  color: const Color(0xFF159B83),
                  action: Icons.send_rounded,
                  onTap: () => _ouvrir(
                    context,
                    Uri(scheme: 'sms', path: tel),
                  ),
                  onCopy: () => _copier(context, telephone),
                ),

                // EMAIL
                _contactCard(
                  context: context,
                  icon: Icons.email_rounded,
                  title: 'Adresse e-mail',
                  value: email,
                  description: 'Envoyer un courrier électronique',
                  color: const Color(0xFFDC7650),
                  action: Icons.mail_outline_rounded,
                  onTap: () => _ouvrir(
                    context,
                    Uri(
                      scheme: 'mailto',
                      path: mail,
                    ),
                  ),
                  onCopy: () => _copier(context, email),
                ),

                // ADRESSE
                _contactCard(
                  context: context,
                  icon: Icons.location_on_rounded,
                  title: 'Localisation',
                  value: adresse,
                  description: 'Consulter mon adresse sur Google Maps',
                  color: const Color(0xFFCA8B24),
                  action: Icons.map_outlined,
                  onTap: () => _ouvrir(context, carte),
                  onCopy: () => _copier(context, adresse),
                ),

                const SizedBox(height: 12),

                // RÉSEAUX PROFESSIONNELS
                const Text(
                  'MES RÉSEAUX PROFESSIONNELS',
                  style: TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),

                const SizedBox(height: 15),

                // LINKEDIN
                _contactCard(
                  context: context,
                  icon: Icons.business_center_rounded,
                  title: 'LinkedIn',
                  value: 'jeremie-malik-paluku-0659ba32b0',
                  description: 'Découvrir mon parcours professionnel',
                  color: const Color(0xFF0A66C2),
                  action: Icons.open_in_new_rounded,
                  onTap: () => _ouvrir(
                    context,
                    Uri.parse(linkedin),
                  ),
                  onCopy: () => _copier(context, linkedin),
                ),

                // GITHUB
                _contactCard(
                  context: context,
                  icon: Icons.code_rounded,
                  title: 'GitHub',
                  value: 'PALUKU-MALIK-JEREMIE',
                  description: 'Découvrir mes projets informatiques',
                  color: const Color(0xFF24292F),
                  action: Icons.open_in_new_rounded,
                  onTap: () => _ouvrir(
                    context,
                    Uri.parse(github),
                  ),
                  onCopy: () => _copier(context, github),
                ),

                const SizedBox(height: 20),

                // SIGNATURE
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.handshake_rounded,
                        color: gold,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        nomComplet,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        titreProfessionnel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFD8E2F0),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 2,
                        width: 40,
                        color: gold,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Merci pour votre intérêt et votre confiance.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // EN-TÊTE
  Widget _header() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 32),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: gold,
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.contact_page_rounded,
                  color: gold,
                  size: 38,
                ),
              ),
              const SizedBox(height: 17),
              const Text(
                'MES COORDONNÉES',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 9),
              Container(
                width: 45,
                height: 3,
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Contact professionnel',
                style: TextStyle(
                  color: Color(0xFFD8E2F0),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CARTE DE CONTACT RÉUTILISABLE
  Widget _contactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String description,
    required Color color,
    required IconData action,
    required VoidCallback onTap,
    required VoidCallback onCopy,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        child: Row(
          children: [
            // ICÔNE
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),

            const SizedBox(width: 13),

            // INFORMATIONS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      color: grey,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // BOUTONS
            Column(
              children: [
                IconButton(
                  tooltip: 'Copier',
                  onPressed: onCopy,
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: grey,
                    size: 19,
                  ),
                ),
                IconButton(
                  tooltip: 'Ouvrir',
                  onPressed: onTap,
                  icon: Icon(
                    action,
                    color: color,
                    size: 21,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
