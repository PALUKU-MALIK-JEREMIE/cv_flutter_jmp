// ============================================================
// MES DONNÉES PERSONNELLES
// Application CV - Jérémie Malik Paluku
// ============================================================

// ---------- 1. CONNEXION ----------

const String identifiantConnexion = 'jmp';
const String motDePasseConnexion = 'jmp121299';

// ---------- 2. IDENTITÉ PROFESSIONNELLE ----------

const String nomComplet = 'Jérémie Malik Paluku';

const String titreProfessionnel =
    'Licencien en réseaux informatiques et télécommunications';

const String photoProfil = 'assets/images/moi.webp';

const String profil =
    'Licencien en réseaux informatiques et télécommunications, '
    'passionné par les nouvelles technologies et spécialisé dans '
    'les systèmes de communication. Je possède des compétences '
    'en administration des réseaux, maintenance informatique, '
    'vidéosurveillance et développement d’applications mobiles. '
    'Dynamique, motivé et déterminé à développer mes compétences '
    'techniques, je souhaite mettre mes connaissances au service '
    'des projets innovants et des organisations professionnelles.';

// ---------- 3. FORMATION ACADÉMIQUE ----------

const List<CvElement> formations = [
  CvElement(
    'Licence en systèmes informatiques',
    'ISIG - Goma',
    '2025',
  ),
  CvElement(
    'Diplôme d’État',
    'SC M. TANZI - Watsa',
    '2019',
  ),
];

// ---------- 4. EXPÉRIENCES PROFESSIONNELLES ----------

const List<CvElement> experiences = [
  CvElement(
    'Stage professionnel',
    'Global Technology',
    '2025',
  ),
  CvElement(
    'Stage professionnel',
    'HAYATCOM',
    '2024',
  ),
  CvElement(
    'Formation professionnelle',
    'MRPS',
    '2019',
  ),
  CvElement(
    'Formation professionnelle',
    'GRADI SECURITY',
    '2020',
  ),
];

// ---------- 5. COMPÉTENCES PROFESSIONNELLES ----------

const List<String> competences = [
  'Flutter',
  'Développement mobile',
  'Réseaux informatiques',
  'Télécommunications',
  'Caméras de surveillance',
  'Design graphique',
  'Maintenance informatique',
  'Installation et configuration réseau',
];

// ---------- 6. LANGUES ----------

const List<String> langues = [
  'Français (courant)',
  'Lingala (courant)',
  'Anglais (intermédiaire)',
  'Swahili (intermédiaire)',
];

// ---------- 7. CENTRES D’INTÉRÊT ----------

const List<String> loisirs = [
  'Football',
  'Lecture',
  'Musique',
];

// ---------- 8. FAMILLE ----------

const List<Membre> famille = [
  Membre(
    'Hussein ARAMA',
    'Père',
    'Architecte',
    'assets/images/pere.png',
  ),
  Membre(
    'Solange KADIDJA',
    'Mère',
    'Styliste',
    'assets/images/mere.png',
  ),
  Membre(
    'Onesime TIRADA',
    'Frère',
    'Ingénieur en bâtiment',
    'assets/images/frere.jpg',
  ),
  Membre(
    'Angel KASIGWA',
    'Sœur',
    'Ingénieure en télécommunications',
    'assets/images/soeur.png',
  ),
];

// ---------- 9. COORDONNÉES ----------

const String telephone = '+243817117792';

const String email = 'malikjeremie010@gmail.com';

const String adresse = 'C. Karisimbi, Q. Mabanga Sud, '
    'Av. Industrielle, N°132, Goma, RDC';

const String linkedin =
    'https://www.linkedin.com/in/j%C3%A9r%C3%A9mie-malik-paluku-659ba32b0/';

const String github = 'https://github.com/PALUKU-MALIK-JEREMIE';

// ============================================================
// 10. DÉFINITION DES CLASSES
// ============================================================

class CvElement {
  final String titre;
  final String sousTitre;
  final String periode;

  const CvElement(
    this.titre,
    this.sousTitre,
    this.periode,
  );
}

class Membre {
  final String nom;
  final String lien;
  final String profession;
  final String photo;

  const Membre(
    this.nom,
    this.lien,
    this.profession,
    this.photo,
  );
}
