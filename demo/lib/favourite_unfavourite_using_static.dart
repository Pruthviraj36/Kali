
import 'package:flutter/material.dart';

class FavouriteUnfavouriteUsingStatic extends StatefulWidget {
  const FavouriteUnfavouriteUsingStatic({super.key});

  @override
  State<FavouriteUnfavouriteUsingStatic> createState() =>
      _FavouriteUnfavouriteUsingStaticState();
}

class _FavouriteUnfavouriteUsingStaticState
    extends State<FavouriteUnfavouriteUsingStatic> {
  List<String> list = [
    'Mango',
    'Banana',
    'Orange',
    'Watermalon',
    'Apple',
    'Graps'
  ];

  List<bool> isFavourite = [true, true, false, true, false, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(color: Colors.grey[400]),
          "Simple Favourite and Unfavourite Using Static",
        ),
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(list[index]),
              trailing: IconButton(
                icon: Icon( isFavourite[index] ? Icons.favorite : Icons.favorite_border,
                color: isFavourite[index] ? Colors.redAccent : Colors.blueGrey,),
                onPressed: (){
                  setState(() {
                    isFavourite[index] = !isFavourite[index];
                  });
                },
              ),
            );
          }),
    );
  }
}
