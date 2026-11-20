import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_jmp/main.dart';

void main() {
  testWidgets('La page de connexion s’affiche', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
