import 'package:get_it/get_it.dart';
import 'package:smartech_app/utils.dart';

GetIt locator = new GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}
