import 'package:flutter/material.dart';
import 'package:flix/models/movielist.dart';

class MovieListDialog extends StatefulWidget {
  final MovieList? movie;
  final Function(String name, String director, double rating, String image) onClickedDone;

  const MovieListDialog({
    Key? key,
    this.movie,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _MovieListDialogState createState() => _MovieListDialogState();
}

class _MovieListDialogState extends State<MovieListDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final directorController = TextEditingController();
  final ratingController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      final movie = widget.movie!;

      nameController.text = movie.name;
      directorController.text = movie.director;
      ratingController.text = movie.rating.toString();
      imageController.text = movie.image;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    directorController.dispose();
    ratingController.dispose();
    imageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';

    return Material(
      color: Colors.black,
      child: Container(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 16),
                      buildName(),
                      SizedBox(height: 8),
                      buildDirector(),
                      SizedBox(height: 8),
                      buildRating(),
                      SizedBox(height: 8),
                      buildImage(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildCancelButton(context),
                          buildAddButton(context, isEditing: isEditing),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName() => TextFormField(
        style: TextStyle(color: Color.fromRGBO(69, 252, 165, 1), fontWeight: FontWeight.bold, fontSize: 18),
        controller: nameController,
        decoration: InputDecoration(
          fillColor: Colors.pink,
          prefixIcon: Icon(Icons.movie),
          border: OutlineInputBorder(),
          hintText: 'Enter Movie Name',
        ),
        validator: (name) => name != null && name.isEmpty ? 'Enter Movie Name' : null,
      );

  Widget buildDirector() => TextFormField(
        style: TextStyle(color: Color.fromRGBO(69, 252, 165, 1), fontWeight: FontWeight.bold, fontSize: 18),
        controller: directorController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
          hintText: 'Enter Director Name',
        ),
        validator: (name) => name != null && name.isEmpty ? 'Enter Director Name' : null,
      );

  Widget buildRating() => TextFormField(
        style: TextStyle(color: Color.fromRGBO(69, 252, 165, 1), fontWeight: FontWeight.bold, fontSize: 18),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.rate_review),
          border: OutlineInputBorder(),
          hintText: 'Enter Rating',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null ? 'Enter a valid number' : null,
        controller: ratingController,
      );

  Widget buildImage() => TextFormField(
        style: TextStyle(color: Color.fromRGBO(69, 252, 165, 1), fontWeight: FontWeight.w700, fontSize: 18),
        controller: imageController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.image),
          border: OutlineInputBorder(),
          hintText: 'Enter Image Link',
        ),
        validator: (image) => image != null && image.isEmpty ? 'Enter Image Link' : null,
      );

  Widget buildCancelButton(BuildContext context) => Container(
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: Color.fromRGBO(255, 23, 85, 1)),
          child: Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return Container(
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Color.fromRGBO(2, 117, 216, 1)),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        onPressed: () async {
          final isValid = formKey.currentState!.validate();

          if (isValid) {
            final name = nameController.text;
            final director = directorController.text;
            final rating = double.tryParse(ratingController.text) ?? 0;
            final image = imageController.text;

            widget.onClickedDone(name, director, rating, image);

            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
