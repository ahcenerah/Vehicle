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
  final List<String> typeOptions = ["Car", "Motorbike", "Hovercraft"];
  final List<String> tiresOptions = ["Hard tires", "Soft tires"];
  final List<String> extrasOptions = ["Nitro (10 units)", "Spoiler"];

  @override
  void initState() {
    super.initState();
    settingsRepository = GetIt.instance<SettingsRepository>();
    settings = settingsRepository.settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tune your vehicle",style: TextStyle(fontSize: 25.0)),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: ListView(
          children: [
            Text("Type:",style: TextStyle(fontSize: 30.0)),
            Column(
              children: typeOptions.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                return RadioListTile(
                  title: Text(option),
                  value: index,
                  groupValue: settings.selectedType,
                  onChanged: (value) {
                    setState(() {
                      settings.selectedType = value ?? 0;
                      if (settings.selectedType != 2) {
                        settings.selectedTires = null;
                      }
                    });
                  },
                  secondary: Text(index == 2 ? "50 credits" : "0 credits", style: TextStyle(fontSize: 15.0)),
                );
              }).toList(),
            ),
            Text("Tires:",style: TextStyle(fontSize: 30.0)),
            Column(
              children: tiresOptions.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                return RadioListTile(
                  title: Text(option),
                  value: index,
                  groupValue: settings.selectedTires,
                  onChanged: (value) {
                    setState(() {
                      settings.selectedTires = value ?? 0;
                    });
                  },
                  secondary: Text(index == 1 ? "30 credits" : "0 credits", style: TextStyle(fontSize: 15.0)),
                  activeColor: settings.selectedType != 2 ? null : Colors.grey,
                );
              }).toList(),
            ),
            Text(
              "Extras:",
              style: TextStyle(fontSize: 30.0),
            ),

            Column(
              children: extrasOptions.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                bool isChecked = settings.selectedExtras.contains(index);

                return CheckboxListTile(
                  title: Text(option),
                  value: isChecked,
                  onChanged: (bool? value){
                    setState(() {
                      if (isChecked) {
                        settings.selectedExtras.remove(index);
                      } else {
                        settings.selectedExtras.add(index);
                      }
                    });
                  },
                  secondary: Text(index == 0 ? "100 credits" : (index == 1 ? "200 credits" : "0 credits"), style: TextStyle(fontSize: 15.0)),
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



            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:'),
                Text(
                  '${calculateTotalCredits(settings.selectedType ?? 0, settings.selectedTires ?? 0, List.from(settings.selectedExtras ?? []))} credits',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '215 Credits',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: calculateTotalCredits(settings.selectedType ?? 0, settings.selectedTires ?? 0, List.from(settings.selectedExtras ?? [])) > 215 ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/purchase', arguments: settings)
                      .then((_) => setState(() {}));
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
  int calculateTotalCredits(int selectedtypeOption, int selectedtiresOption, List<int> selectedextrasOptions) {
    int typePrice = selectedtypeOption == 2 ? 50 : 0;
    int tiresPrice = selectedtiresOption == 1 ? 30 : 0;
    int extrasPrice = 0;
    for (int index in selectedextrasOptions) {
      extrasPrice += index == 0 ? 100 : (index == 1 ? 200 : 0);
    }
    if (selectedtypeOption == 2){
      return typePrice + extrasPrice;
    } else {
      return typePrice + tiresPrice + extrasPrice;
    }
  }
}
