import 'package:material_ui/material_ui.dart';
import '../data/mes_donnees.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  static const Color navy = Color(0xFF14243A);
  static const Color blue = Color(0xFF2563EB);
  static const Color gold = Color(0xFFD6A84F);
  static const Color background = Color(0xFFF3F6FA);
  static const Color textDark = Color(0xFF243247);
  static const Color textGrey = Color(0xFF718096);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _header(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 35),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _section(
                  icon: Icons.person_outline,
                  title: 'À PROPOS DE MOI',
                  child: const Text(
                    profil,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      color: textGrey,
                    ),
                  ),
                ),
                _section(
                  icon: Icons.school_outlined,
                  title: 'FORMATION',
                  child: _timeline(formations),
                ),
                _section(
                  icon: Icons.work_outline,
                  title: 'EXPÉRIENCES PROFESSIONNELLES',
                  child: _timeline(experiences),
                ),
                _section(
                  icon: Icons.stars_outlined,
                  title: 'COMPÉTENCES',
                  child: _chips(competences, blue),
                ),
                _section(
                  icon: Icons.language,
                  title: 'LANGUES',
                  child: _chips(langues, const Color(0xFF159B83)),
                ),
                _section(
                  icon: Icons.favorite_outline,
                  title: 'CENTRES D’INTÉRÊT',
                  child: _chips(loisirs, const Color(0xFFB7791F)),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'CURRICULUM VITAE',
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 11,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // EN-TÊTE PROFESSIONNEL

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 35),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: gold, width: 2.5),
                ),
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.white12,
                  child: ClipOval(
                    child: Image.asset(
                      photoProfil,
                      width: 116,
                      height: 116,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 65,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                nomComplet.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 3,
                width: 48,
                decoration: BoxDecoration(
                  color: gold,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                titreProfessionnel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD8E2F0),
                  fontSize: 15,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'CURRICULUM VITAE',
                style: TextStyle(
                  color: gold,
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CARTES DES SECTIONS

  Widget _section({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: navy.withOpacity(0.045),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: blue.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: blue, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: navy,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 1,
            color: const Color(0xFFEDF0F5),
          ),
          const SizedBox(height: 17),
          child,
        ],
      ),
    );
  }

  // CHRONOLOGIE FORMATION ET EXPERIENCES

  Widget _timeline(List<CvElement> elements) {
    return Column(
      children: elements.asMap().entries.map((entry) {
        final index = entry.key;
        final e = entry.value;
        final isLast = index == elements.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 22,
                child: Column(
                  children: [
                    Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          // ignore: deprecated_member_use
                          color: blue.withOpacity(0.2),
                          width: 3,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: const Color(0xFFDCE6F5),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.titre,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        e.sousTitre,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: textGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FF),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          e.periode,
                          style: const TextStyle(
                            color: blue,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // BADGES DES COMPETENCES, LANGUES ET LOISIRS

  Widget _chips(List<String> items, Color color) {
    return Wrap(
      spacing: 9,
      runSpacing: 10,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.15),
            ),
          ),
          child: Text(
            item,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
