import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/widgets/components/FormComponents.dart';

class EditQuantityDialog extends StatefulWidget {
  String name;
  bool isPerishable, isAddOperation;
  var refresh;

  EditQuantityDialog(this.name, this.isPerishable, this.refresh, [this.isAddOperation = false]);

  @override
  State<EditQuantityDialog> createState() => _EditQuantityDialogState();
}

class _EditQuantityDialogState extends State<EditQuantityDialog> {
  final formKey = GlobalKey<FormState>();
  DateTime? expiry;
  double? quantity;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: generateTitle(),
      content: Form(
        key: formKey,
        child: Column(
          children: createFormFields(),
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No')
        ),
        TextButton(
            onPressed: () {
              if(formKey.currentState!.validate()){
                formKey.currentState!.save();
                print(quantity);
                if(widget.isAddOperation){
                  if(!widget.isPerishable){
                    PantryManager().addItem(widget.name, quantity!);
                  } else {
                    PantryManager().addItem(widget.name, quantity!, expiry);
                  }
                } else {
                  PantryManager().removeItem(widget.name, quantity!);
                }
                Navigator.of(context).pop();
                widget.refresh();
              }
            },
            child: Text('Yes')
        )
      ],
    );
  }

  Text generateTitle(){
    String text = '';
    if(widget.isAddOperation) {
      text += 'Add ';
    } else {
      text += 'Remove ';
    }
    text += '${widget.name}?';

    return Text(text);
  }

  List<Widget> createFormFields() {
    List<Widget> fields = [
      TextEntry(
        'Quantity',
        inputType: TextInputType.number,
        validator: quantityValidator,
        saveFunction: (value) {
          print('Save qty called.');
          quantity = double.tryParse(value.toString());
        },
      )
    ];

    if(widget.isPerishable && widget.isAddOperation) {
      fields.add(SizedBox(height: 5.0,));
      fields.add(
        TextEntry(
          'Expiration Date',
          inputType: TextInputType.datetime,
          validator: dateValidator,
          saveFunction: (value) {
            expiry = DateTime.parse(value!);
          },
        )
      );
    }

    return fields;
  }

  String? isNotEmpty(String? value){
    if(value == null || value.isEmpty){
      return 'This fields is required';
    }

    return null;
  }

  String? dateValidator(String? value){
    var empty = isNotEmpty(value);
    if(empty != null) {
      return empty;
    }

    try {
      DateTime.parse(value!);
    } on FormatException {
      return 'This is not a valid date format it must be YYYY-MM-DD'; // todo: change date format on user end.
    }

    return null;
  }

  String? quantityValidator(String? value){
    var empty = isNotEmpty(value);
    if(empty != null) {
      return empty;
    }


    var result = double.tryParse(value!);
    if (result == null) {
      return 'This must contain a valid numeric value.';
    }

    return null;
  }
}
