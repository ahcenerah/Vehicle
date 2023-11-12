import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicule/data/settings.dart';
import 'package:vehicule/data/settingsRepository.dart';


class TuneWidget extends StatefulWidget {

  TuneWidget({Key? key}): super(key: key);
  @override
  _TuneWidgetState createState() => _TuneWidgetState();
}

class _TuneWidgetState extends State<TuneWidget> {
  late SettingsRepository settingsRepository;
  late Settings settings;
  late int? selectedtypeOption;
  late int? selectedtiresOption;
  late List<int> selectedextrasOptions;

  final List<String> typeOptions = ["Car", "Motorbike", "Hovercraft"];
  final List<String> tiresOptions = ["Hard tires", "Soft tires"];
  final List<String> extrasOptions = ["Nitro (10 units)", "Spoiler"];

  @override
  void initState() {
    super.initState();
    settingsRepository = GetIt.instance<SettingsRepository>();
    settings = settingsRepository.settings;
    selectedtypeOption = settings.selectedType;
    selectedtiresOption = settings.selectedTires;
    selectedextrasOptions = List.from(settings.selectedExtras);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tune your vehicle"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Type:"),
            Column(
              children: typeOptions.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                return RadioListTile(
                  title: Text(option),
                  value: index,
                  groupValue: selectedtypeOption,
                  onChanged: (value) {
                    setState(() {
                      selectedtypeOption = value;
                      if (selectedtypeOption != 2) {
                        // Désélectionne les pneus "Soft" si le type n'est pas "Hovercraft"
                        selectedtiresOption = null;
                      }
                    });
                  },
                  secondary: Text(index == 2 ? "50 credits" : "0 credits",style:TextStyle(fontSize: 15.0)),
                );
              }).toList(),
            ),
            Text("Tires:"),
            Column(
              children: tiresOptions.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                return RadioListTile(
                  title: Text(option),
                  value: index,
                  groupValue: selectedtiresOption,
                  onChanged: (value) {
                    setState(() {
                      selectedtiresOption = value;
                    });
                  },
                  secondary: Text(index == 1 ? "30 credits" : "0 credits",style:TextStyle(fontSize: 15.0)),
                  activeColor: selectedtypeOption != 2 ? null : Colors.grey,
                );
              }).toList(),
            ),
            Text("Extras:"),
            Column(
              children: extrasOptions.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                bool isChecked = selectedextrasOptions.contains(index);
                return CheckboxListTile(
                  title: Text(option),
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      if (isChecked) {
                        selectedextrasOptions.remove(index);
                      } else {
                        selectedextrasOptions.add(index);
                      }
                    });
                  },
                  secondary: Text(index == 0 ? "100 credits" : (index == 1 ? "200 credits" : "0 credits"),style:TextStyle(fontSize: 15.0)),
                  activeColor: Colors.green,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  tileColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:'),
                Text(
                  '${calculateTotalCredits()} credits',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerRight, // Positionne le texte à droite
                  child: Text(
                    '215 Credits',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: calculateTotalCredits() > 215 ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context,'/purchase',arguments: settings)
                      .then((_) => setState (() {}));
                },
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(fontSize: 20.0),
                  ),
                ),
                child: Text('Purchase'),
              ),
            ),
          ],
        ),
      ),
    );

  }
  int calculateTotalCredits() {
    int typePrice = selectedtypeOption == 2 ? 50 : 0;
    int tiresPrice = selectedtiresOption == 1 ? 30 : 0;
    int extrasPrice = 0;
    for (int index in selectedextrasOptions) {
      extrasPrice += index == 0 ? 100 : (index == 1 ? 200 : 0);
    }
    return typePrice + tiresPrice + extrasPrice;
  }
}
