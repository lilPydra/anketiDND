// lib/common/widgets/dynamic_form_widget.dart
import 'package:flutter/material.dart';
import 'form_field_widget.dart';
import '../../data/models/form_definition.dart';
import '../services/form_service.dart';

class DynamicFormWidget extends StatefulWidget {
  final String systemName;
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>)? onFormChanged;

  const DynamicFormWidget({
    Key? key,
    required this.systemName,
    this.initialData = const {},
    this.onFormChanged,
  }) : super(key: key);

  @override
  State<DynamicFormWidget> createState() => DynamicFormWidgetState();
}

class DynamicFormWidgetState extends State<DynamicFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final FormService _formService = FormService();
  late Future<FormDefinition> _formDefinitionFuture;
  Map<String, dynamic> _formData = {};
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _formData = {...widget.initialData};
    _formDefinitionFuture = _formService.getFormDefinition(widget.systemName);
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> getFormData() {
    return _formData;
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FormDefinition>(
      future: _formDefinitionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No form definition found'));
        }

        final formDefinition = snapshot.data!;
        return _buildForm(formDefinition);
      },
    );
  }

  Widget _buildForm(FormDefinition formDefinition) {
    // Clear controllers when rebuilding
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();

    return Form(
      key: _formKey,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: formDefinition.sections.length,
        itemBuilder: (context, sectionIndex) {
          final section = formDefinition.sections[sectionIndex];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      section.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ...section.fields.asMap().entries.map((entry) {
                    final field = entry.value;

                    // Create a unique controller for each field
                    final controller = TextEditingController(
                      text: _formData[field.id]?.toString() ?? field.defaultValue?.toString() ?? '',
                    );
                    _controllers.add(controller);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: FormFieldWidget(
                        field: field,
                        controller: controller,
                        onChanged: (value) {
                          _formData[field.id] = value;
                          if (widget.onFormChanged != null) {
                            widget.onFormChanged!(_formData);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}