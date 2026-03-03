import 'package:flutter_test/flutter_test.dart';
import 'package:doma_app/main.dart';

void main() {
  testWidgets('Teste inicial do Doma App', (WidgetTester tester) async {
    // Constrói o nosso novo app e aciona a tela
    await tester.pumpWidget(const DomaApp());

    // Verifica se o texto 'DOMA APP' está na tela
    expect(find.text('DOMA APP'), findsOneWidget);
  });
}
