import 'package:vehicule/data/settings.dart';

abstract class SettingsRepository {
  // Abstract getter for retrieving settings.
  get settings;

  // Abstract method for saving the selected type.
  void saveSelectedType(int type);

  // Abstract method for saving the selected tires.
  void saveSelectedTires(int tires);

  // Abstract method for toggling the selected extra based on an index.
  void toggleSelectedExtra(int index);


}
