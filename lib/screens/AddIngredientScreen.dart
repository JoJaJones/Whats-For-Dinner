import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/widgets/components/FormComponents.dart';
import 'package:whats_for_dinner/widgets/components/SimpleComponents.dart';

class AddIngredientScreen extends StatefulWidget {
  static const routeName = 'AddIngredient';

  @override
  State<AddIngredientScreen> createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends State<AddIngredientScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isPerishable = false;
  var data = Map<String, dynamic>();
  static const quantityKey = 'qty';
  static const nameKey = 'name';
  static const perishableKey = "expires";
  static const expiryKey = 'expiry';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('What\'s for Dinner?'),
      ),
      body: 
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText('Add an Ingredient to Pantry', fontSize: 25,)
              ],
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child:Form(
                key: formKey,
                child: Column(
                  children: buildForm(_isPerishable),
                ),

              )
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildForm(bool isPerishable) {
    List<Widget> widgets = [
      Row(
        children: [
          Flexible(
              child: TextEntry(
                'Ingredient',
                validator: nameValidator,
                saveFunction: (value) {
                  data[nameKey] = value.toString();
                },
              )
          )
        ],
      ),
      SizedBox(height:10.0),
      Padding(padding: EdgeInsets.only(right:20),
          child: Row(
            children: [
              Flexible(
                child:TextEntry(
                  'Quantity',
                  inputType: TextInputType.number,
                  validator: quantityValidator,
                  saveFunction: (value) {
                    data[quantityKey] = double.tryParse(value.toString());
                  },
                ),
                flex: 4,
              ),
              Flexible(
                  child: Column(
                    children: [
                      ContentText('perishable', fontSize: 12.0,),
                      Checkbox(
                        value: _isPerishable,
                        onChanged: (bool? val) {
                          setState(() {
                            _isPerishable = val!;
                          });
                        },
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  flex: 1
              ),
            ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
      )
    ];

    // todo: implement date picker object for this widget.
    if(_isPerishable){
      widgets.add(SizedBox(height: 10.0,));
      widgets.add(
        TextEntry(
          'Expiration Date',
          inputType: TextInputType.datetime,
          validator: dateValidator,
          saveFunction: (value) {
            data[expiryKey] = DateTime.parse(value!);
          },
        )
      );
      // widgets.add()
    }

    widgets.add(SizedBox(height: 5.0,));
    widgets.add(
      Row(
        children: [
          Flexible(
            child: Padding(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                ),
                child: Text('Cancel'),
                onPressed: (){ Navigator.of(context).pop(); },
              ),
              padding: EdgeInsets.only(right: 5.0)
            ),
            flex: 1,
            fit: FlexFit.tight,
          ),
          Flexible(
            child: Padding(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                ),
                child: Text('Add Ingredient'),
                onPressed: addIngredient,
              ),
              padding: EdgeInsets.only(left: 5.0),
            ),
            flex: 1,
            fit: FlexFit.tight,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      )
    );
    return widgets;
  }

  String? nameValidator(String? value){
    var empty = isNotEmpty(value);

    if(empty != null) {
      return empty;
    }

    // todo: check pantry then firebase, then spoonacular for the ingredient to validate the name

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

  String? isNotEmpty(String? value){
    if(value == null || value.isEmpty){
      return 'This fields is required';
    }

    return null;
  }

  void addIngredient() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      var pantry = PantryManager();
      if (_isPerishable) {
        pantry.addItem(data[nameKey], data[quantityKey], data[expiryKey]);
      } else {
        pantry.addItem(data[nameKey], data[quantityKey]);
      }
      Navigator.of(context).pop();
    }
  }
}
