import 'dart:math' as math;
import 'dart:ui';
import 'package:material_ui/material_ui.dart';
import '../data/mes_donnees.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _identifiantCtrl = TextEditingController();
  final _motDePasseCtrl = TextEditingController();
  bool _masque = true;
  bool _chargement = false;
  String? _erreur;

  // Animation de secousse en cas d'erreur
  late final AnimationController _secousse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void dispose() {
    _identifiantCtrl.dispose();
    _motDePasseCtrl.dispose();
    _secousse.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _chargement = true;
      _erreur = null;
    });
    await Future.delayed(
        const Duration(milliseconds: 700)); // petit effet de chargement
    if (!mounted) return;

    final ok = _identifiantCtrl.text.trim() == identifiantConnexion &&
        _motDePasseCtrl.text == motDePasseConnexion;

    if (ok) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    } else {
      setState(() {
        _chargement = false;
        _erreur = 'Identifiant ou mot de passe incorrect';
      });
      _secousse.forward(from: 0);
    }
  }

  InputDecoration _decoration(String label, IconData icone, ColorScheme c,
      {Widget? suffixe}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, color: c.primary),
      suffixIcon: suffixe,
      filled: true,
      fillColor: c.surfaceContainerHighest.withAlpha(120),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Fond en dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.primary, c.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // 2. Cercles décoratifs
          Positioned(
              top: -80,
              right: -60,
              child: _Bulle(220, c.onPrimary.withAlpha(30))),
          Positioned(
              bottom: -100,
              left: -70,
              child: _Bulle(260, c.onPrimary.withAlpha(25))),
          Positioned(
              top: 140,
              left: -40,
              child: _Bulle(100, c.onPrimary.withAlpha(20))),

          // 3. Contenu
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, child) => Opacity(
                    opacity: v,
                    child: Transform.translate(
                        offset: Offset(0, 40 * (1 - v)), child: child),
                  ),
                  child: Column(
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: c.onPrimary.withAlpha(150), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: c.onPrimary,
                          child: Icon(Icons.badge_rounded,
                              size: 48, color: c.primary),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text('Bienvenue',
                          style: TextStyle(
                              color: c.onPrimary,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      Text('Connectez-vous pour découvrir mon CV',
                          style: TextStyle(
                              color: c.onPrimary.withAlpha(210), fontSize: 15)),
                      const SizedBox(height: 32),

                      // Carte « verre dépoli » qui tremble en cas d'erreur
                      AnimatedBuilder(
                        animation: _secousse,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(
                              math.sin(_secousse.value * math.pi * 6) *
                                  12 *
                                  (1 - _secousse.value),
                              0),
                          child: child,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 420),
                              padding:
                                  const EdgeInsets.fromLTRB(22, 28, 22, 24),
                              decoration: BoxDecoration(
                                color: c.surface.withAlpha(235),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: c.shadow.withAlpha(50),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Connexion',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: c.onSurface)),
                                    const SizedBox(height: 4),
                                    Text('Entrez vos identifiants',
                                        style: TextStyle(
                                            color: c.onSurfaceVariant)),
                                    const SizedBox(height: 24),
                                    TextFormField(
                                      controller: _identifiantCtrl,
                                      textInputAction: TextInputAction.next,
                                      decoration: _decoration('Identifiant',
                                          Icons.person_outline_rounded, c),
                                      validator: (v) =>
                                          (v == null || v.trim().isEmpty)
                                              ? 'Entrez votre identifiant'
                                              : null,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _motDePasseCtrl,
                                      obscureText: _masque,
                                      decoration: _decoration(
                                        'Mot de passe',
                                        Icons.lock_outline_rounded,
                                        c,
                                        suffixe: IconButton(
                                          icon: Icon(_masque
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined),
                                          onPressed: () => setState(
                                              () => _masque = !_masque),
                                        ),
                                      ),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'Entrez votre mot de passe'
                                          : null,
                                      onFieldSubmitted: (_) => _seConnecter(),
                                    ),

                                    // Message d'erreur animé
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: _erreur == null
                                          ? const SizedBox(height: 24)
                                          : Container(
                                              key: ValueKey(_erreur),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: c.errorContainer,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.error_outline,
                                                      color:
                                                          c.onErrorContainer),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(_erreur!,
                                                        style: TextStyle(
                                                            color: c
                                                                .onErrorContainer,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),

                                    // Bouton en dégradé
                                    _BoutonDegrade(
                                      chargement: _chargement,
                                      onPressed: _seConnecter,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('© ${DateTime.now().year} • Mon CV',
                          style: TextStyle(color: c.onPrimary.withAlpha(180))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cercle décoratif du fond
class _Bulle extends StatelessWidget {
  final double taille;
  final Color couleur;
  const _Bulle(this.taille, this.couleur);

  @override
  Widget build(BuildContext context) => Container(
        width: taille,
        height: taille,
        decoration: BoxDecoration(shape: BoxShape.circle, color: couleur),
      );
}

/// Bouton « Se connecter » en dégradé avec indicateur de chargement
class _BoutonDegrade extends StatelessWidget {
  final bool chargement;
  final VoidCallback onPressed;
  const _BoutonDegrade({required this.chargement, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [c.primary, c.tertiary]),
        boxShadow: [
          BoxShadow(
            color: c.primary.withAlpha(90),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: chargement ? null : onPressed,
          child: Center(
            child: chargement
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: c.onPrimary),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Se connecter',
                          style: TextStyle(
                              color: c.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5)),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: c.onPrimary),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
