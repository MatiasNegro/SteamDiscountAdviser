import 'package:flutter/material.dart';

class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample({Key? key}) : super(key: key);

  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}


/*
  TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: "Search game",
                  filled: true,
                  fillColor: Colors.grey[400],
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              )
*/ 