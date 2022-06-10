import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartech_appinbox/smartech_appinbox.dart';

void main() {
  const MethodChannel channel = MethodChannel('smartech_appinbox');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(SmartechAppinbox().getPlatformVersion, '42');
  });
}
