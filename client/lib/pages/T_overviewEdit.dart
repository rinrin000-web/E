import 'package:client/provider/overview_provider.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TOverviewEdit extends ConsumerWidget {
  TOverviewEdit({Key? key}) : super(key: key);

  final TextEditingController _slogan = TextEditingController();
  final TextEditingController _overallplanning = TextEditingController();
  final TextEditingController _techused = TextEditingController();
  final TextEditingController _tools = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamNo = ref.watch(selectedTeamProvider);
    print('Selected TeamOver: $teamNo');

    void saveOverView() async {
      try {
        if (teamNo == null || teamNo.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team number is required')),
          );
          return;
        }

        final overviewNotifier = ref.read(overviewProvider.notifier);

        // Giả định: Fetch overview để kiểm tra nếu team đã tồn tại
        final overviewList = await overviewNotifier.fetchOverview(teamNo);
        if (overviewList.isNotEmpty) {
          // Update nếu đã tồn tại
          await overviewNotifier.updateOverview(
            teamNo,
            _slogan.text,
            _overallplanning.text,
            _techused.text,
            _tools.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Overview updated successfully')),
          );
        } else {
          // Create nếu chưa có
          await overviewNotifier.createOverview(
            teamNo,
            _slogan.text,
            _overallplanning.text,
            _techused.text,
            _tools.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Overview created successfully')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving overview: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTextField('Slogan', _slogan),
            buildTextField('Overall Planning', _overallplanning),
            buildTextField('Tech Used', _techused),
            buildTextField('Tools', _tools),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: saveOverView,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/myhome/home/profifeIma');
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
        label: Text('profifeIma'),
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
