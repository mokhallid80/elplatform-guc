import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/auth/form_input_field.dart';
import 'package:guc_swiss_knife/models/location.dart';
import 'package:guc_swiss_knife/services/location_service.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  LocationService locationService = LocationService();

  late final GlobalKey<FormState> _formKey;
  late final Map<String, dynamic> fields;

  Location location = Location();

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    fields = {
      "name": FormInputField(
        name: "name",
        controller: TextEditingController(),
        icon: Icons.abc_rounded,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Title is required';
          }
          return null;
        },
      ),
      "sized_box1": const SizedBox(height: 20),
      "description": FormInputField(
        name: "description",
        controller: TextEditingController(),
        icon: Icons.info,
        validator: (value) {
          if (value!.isEmpty) {
            return 'description is required';
          }
          return null;
        },
      ),
      "sized_box2": const SizedBox(height: 20),
      "latitude": FormInputField(
        keyboardType: TextInputType.number,
        name: "latitude",
        controller: TextEditingController(),
        icon: Icons.location_on,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Latitude is required';
          }
          return null;
        },
      ),
      "sized_box3": const SizedBox(height: 20),
      "longitude": FormInputField(
        keyboardType: TextInputType.number,
        name: "longitude",
        controller: TextEditingController(),
        icon: Icons.location_on,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Longitude is required';
          }
          return null;
        },
      ),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Location'),
      ),
      body: Center(
        child: Card(
          elevation: 2.0,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ...fields.values.map((field) => field),
                  ElevatedButton(
                    onPressed: addLocation,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addLocation() {
    if (_formKey.currentState!.validate()) {
      location.name = fields['name']!.controller.text;
      location.description = fields['description']!.controller.text;
      location.latitude = double.parse(fields['latitude']!.controller.text);
      location.longitude = double.parse(fields['longitude']!.controller.text);
      locationService.addLocation(location);
      Navigator.pop(context);
    }
  }
}
