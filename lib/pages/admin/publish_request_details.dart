import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guc_swiss_knife/components/app_bar_widget.dart';
import 'package:guc_swiss_knife/components/drawer_widget.dart';
import 'package:guc_swiss_knife/models/publish_request.dart';

class PublishRequestsDetails extends StatelessWidget {
  const PublishRequestsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final PublishRequest publishRequest =
        ModalRoute.of(context)!.settings.arguments as PublishRequest;

    const sizedBoxSpaceV = SizedBox(
      height: 30,
    );
    const sizedBoxSpaceH = SizedBox(
      width: 30,
    );
    return Scaffold(
      appBar: MyAppBar(),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
                title: publishRequest.user == null
                    ? const Text("Anonymous")
                    : Text(publishRequest.user!.firstName),
                subtitle: const Text("Publish Request"),
              ),
            ),
            sizedBoxSpaceV,
            const Text(
              'Message',
              style: TextStyle(fontSize: 18.0),
            ),
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                publishRequest.content,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            sizedBoxSpaceV,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {},
                  ),
                ),
                sizedBoxSpaceH,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {},
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
