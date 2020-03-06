
import 'package:example_app/model/api.dart';
import 'package:example_app/model/todo.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => Api('todo'));
  locator.registerLazySingleton(() => TodoModel()) ;
}