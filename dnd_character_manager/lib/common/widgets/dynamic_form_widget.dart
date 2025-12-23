// lib/common/widgets/dynamic_form_widget.dart
import 'package:flutter/material.dart';
import 'form_field_widget.dart';
import '../../data/models/form_definition.dart';
import '../services/form_service.dart';

class DynamicFormWidget extends StatefulWidget {
  final String systemName;
  final Map<String, dynamic> initialData;

  const DynamicFormWidget({
    Key? key,
    required this.systemName,
    this.initialData = const {},
  }) : super(key: key);

  @override
  State<DynamicFormWidget> createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final FormService _formService = FormService();
  late Future<FormDefinition> _formDefinitionFuture;
  Map<String, dynamic> _formData = {};

  @override
  void initState() {
    super.initState();
    _formData = {...widget.initialData};
    _formDefinitionFuture = _formService.getFormDefinition(widget.systemName);
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
                  ...section.fields.map((field) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: FormFieldWidget(
                        field: field,
                        controller: TextEditingController(
                          text: _formData[field.id]?.toString() ?? field.defaultValue?.toString() ?? '',
                        ),
                        onChanged: (value) {
                          _formData[field.id] = value;
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