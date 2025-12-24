// lib/common/widgets/form_field_widget.dart
import 'package:flutter/material.dart';
import '../../data/models/form_definition.dart' as FormDef;

class FormFieldWidget extends StatelessWidget {
  final FormDef.FormField field;
  final TextEditingController? controller;
  final Function(dynamic)? onChanged;

  const FormFieldWidget({
    Key? key,
    required this.field,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case FormDef.FormFieldType.text:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder,
          ),
          initialValue: controller == null ? field.defaultValue?.toString() : null,
          validator: field.required
              ? (value) => value?.isEmpty == true ? 'This field is required' : null
              : null,
          onChanged: onChanged,
        );
      case FormDef.FormFieldType.number:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder,
          ),
          initialValue: controller == null ? field.defaultValue?.toString() : null,
          keyboardType: TextInputType.number,
          validator: field.required
              ? (value) {
                  if (value?.isEmpty == true) {
                    return 'This field is required';
                  }
                  final number = double.tryParse(value!);
                  if (number == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                }
              : null,
          onChanged: (value) {
            if (onChanged != null) {
              final number = double.tryParse(value);
              onChanged!(number);
            }
          },
        );
      case FormDef.FormFieldType.dropdown:
        // For simplicity, using a simple dropdown
        return DropdownButtonFormField<String>(
          initialValue: field.defaultValue?.toString(),
          decoration: InputDecoration(
            labelText: field.label,
          ),
          items: field.options?.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          validator: field.required
              ? (value) => value == null ? 'This field is required' : null
              : null,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
        );
      case FormDef.FormFieldType.checkbox:
        // Note: This is a simplified implementation
        // A proper implementation would need a different approach
        return SwitchListTile(
          title: Text(field.label),
          value: field.defaultValue == true,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
        );
      case FormDef.FormFieldType.textarea:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder,
          ),
          initialValue: controller == null ? field.defaultValue?.toString() : null,
          maxLines: 5,
          validator: field.required
              ? (value) => value?.isEmpty == true ? 'This field is required' : null
              : null,
          onChanged: onChanged,
        );
      default:
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field.label,
          ),
          validator: field.required
              ? (value) => value?.isEmpty == true ? 'This field is required' : null
              : null,
          onChanged: onChanged,
        );
    }
  }
}