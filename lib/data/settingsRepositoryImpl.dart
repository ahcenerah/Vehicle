import 'package:vehicule/data/settings.dart';
import 'package:vehicule/data/settingsRepository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  Settings _settings = Settings(1, 1, List.empty());

  @override
  get settings {
    return _settings;
  }

  @override
  void saveSelectedType(int type) {
    _settings.selectedType = type;
  }

  @override
  void saveSelectedTires(int tires) {
    _settings.selectedTires = tires;
  }

  @override
  void toggleSelectedExtra(int index) {
    // Toggle the state of the selected extra.
    if (_settings.selectedExtras.contains(index)) {
      _settings.selectedExtras.remove(index);
    } else {
      _settings.selectedExtras.add(index);
    }
  }
}
