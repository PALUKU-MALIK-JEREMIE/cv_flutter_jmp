import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cv_flutter_jmp/main.dart';

void main() {
  testWidgets('Sans session, la page de connexion s’affiche', (tester) async {
    SharedPreferences.setMockInitialValues({}); // personne n'est connecté
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
