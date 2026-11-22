import 'package:flutter/material.dart';
import 'cv_page.dart';
import 'famille_page.dart';
import 'contact_page.dart';
import 'login_page.dart';
import '../services/auth_service.dart';

/// Description d'une section de l'application.
class _Section {
  final String titre;
  final String sousTitre;
  final String label;
  final IconData icone;
  final IconData iconeActive;
  final Widget page;

  const _Section({
    required this.titre,
    required this.sousTitre,
    required this.label,
    required this.icone,
    required this.iconeActive,
    required this.page,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  static const _sections = [
    _Section(
      titre: 'Mon CV',
      sousTitre: 'Parcours, formations et compétences',
      label: 'CV',
      icone: Icons.description_outlined,
      iconeActive: Icons.description,
      page: CvPage(),
    ),
    _Section(
      titre: 'Ma famille',
      sousTitre: 'Les personnes qui comptent pour moi',
      label: 'Famille',
      icone: Icons.family_restroom_outlined,
      iconeActive: Icons.family_restroom,
      page: FamillePage(),
    ),
    _Section(
      titre: 'Appelez-moi, écrivez-moi',
      sousTitre: '',
      label: 'Contact',
      icone: Icons.contact_phone_outlined,
      iconeActive: Icons.contact_phone,
      page: ContactPage(),
    ),
  ];

  Future<void> _deconnexion() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.logout_rounded, size: 36),
        title: const Text('Se déconnecter ?'),
        content: const Text(
          'Vous devrez saisir à nouveau votre identifiant et votre mot de passe.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );

    if (confirme != true || !mounted) return;
    await AuthService.logout(); // efface l'utilisateur mémorisé
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final section = _sections[_index];

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      extendBody: true,
      body: Column(
        children: [
          _EnTete(section: section, onDeconnexion: _deconnexion),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(_index),
                child: Padding(
                  // Laisse de la place pour la barre flottante.
                  padding: const EdgeInsets.only(bottom: 90),
                  child: section.page,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withAlpha(45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: NavigationBar(
                height: 68,
                elevation: 0,
                backgroundColor: scheme.surface,
                indicatorColor: scheme.primaryContainer,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                destinations: [
                  for (final s in _sections)
                    NavigationDestination(
                      icon: Icon(s.icone),
                      selectedIcon: Icon(s.iconeActive, color: scheme.primary),
                      label: s.label,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bandeau supérieur en dégradé, avec coins arrondis en bas.
class _EnTete extends StatelessWidget {
  final _Section section;
  final VoidCallback onDeconnexion;

  const _EnTete({required this.section, required this.onDeconnexion});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final texte = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.tertiary],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Cercles décoratifs
          Positioned(
            right: -40,
            top: -30,
            child:
                _Cercle(taille: 150, couleur: scheme.onPrimary.withAlpha(25)),
          ),
          Positioned(
            right: 60,
            bottom: -50,
            child:
                _Cercle(taille: 100, couleur: scheme.onPrimary.withAlpha(18)),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Bienvenue sur mon CV !',
                        style: texte.bodyMedium?.copyWith(
                          color: scheme.onPrimary.withAlpha(220),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Déconnexion',
                        onPressed: onDeconnexion,
                        style: IconButton.styleFrom(
                          backgroundColor: scheme.onPrimary.withAlpha(40),
                        ),
                        icon:
                            Icon(Icons.logout_rounded, color: scheme.onPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Row(
                      key: ValueKey(section.titre),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: scheme.onPrimary.withAlpha(40),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(section.iconeActive,
                              color: scheme.onPrimary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.titre,
                                style: texte.headlineSmall?.copyWith(
                                  color: scheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                section.sousTitre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: texte.bodySmall?.copyWith(
                                  color: scheme.onPrimary.withAlpha(210),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cercle extends StatelessWidget {
  final double taille;
  final Color couleur;
  const _Cercle({required this.taille, required this.couleur});

  @override
  Widget build(BuildContext context) => Container(
        width: taille,
        height: taille,
        decoration: BoxDecoration(shape: BoxShape.circle, color: couleur),
      );
}
