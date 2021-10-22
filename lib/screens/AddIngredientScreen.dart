import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('What\'s for Dinner?'),
      ),
      body: Column(
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
              )
            )
          )
        ],
      ),
    );
  }

  List<Widget> buildForm(bool isPerishable) {
    List<Widget> widgets = [
      Row(
        children: [
          Flexible(
              child: TextEntry(
                  'Ingredient'
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

    if(_isPerishable){
      widgets.add(SizedBox(height: 10.0,));
      widgets.add(TextEntry('Expiration Date', inputType: TextInputType.datetime,));
      // widgets.add()
    }

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
                onPressed: (){ Navigator.of(context).pop(); },
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
}
