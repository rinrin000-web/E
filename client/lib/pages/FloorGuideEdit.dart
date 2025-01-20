import 'package:client/provider/event_provider.dart';
import 'package:client/provider/floor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloorGuideEdit extends ConsumerWidget {
  FloorGuideEdit({Key? key}) : super(key: key);

  final TextEditingController _floor_no = TextEditingController();
  final TextEditingController _contents = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    final floorNotifier = ref.read(floorProvider.notifier);

    void saveFloor() async {
      try {
        // Fetch the current list of floors
        await floorNotifier.fetchFloorcount(eventId!);

        // Kiểm tra sự tồn tại của floor_no trong danh sách
        bool floorExists = ref
            .read(floorProvider)
            .any((floor) => floor.floor_no == _floor_no.text);

        if (floorExists) {
          // Nếu tồn tại, gọi hàm update
          await floorNotifier.updateFloor(
              _floor_no.text, eventId!, _contents.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floor updated successfully!')),
          );
        } else {
          // Nếu không tồn tại, gọi hàm create
          await floorNotifier.createFloor(
              eventId!, _floor_no.text, _contents.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floor created successfully!')),
          );
        }
      } catch (e) {
        print('Error occurred: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving floor: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextField('floor_no', _floor_no),
            buildTextField('contens', _contents),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: saveFloor,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    try {
                      floorNotifier.deleteFloor(_floor_no.text, eventId!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Floor delete successfully!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error delete floor: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
      ),
    );
  }
}
