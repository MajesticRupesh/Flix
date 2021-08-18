import 'package:flutter/material.dart';
import 'package:flix/models/movielist.dart';

class MovieListDialog extends StatefulWidget {
  final MovieList? movie;
  final Function(String name, String director, double rating) onClickedDone;

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

  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      final movie = widget.movie!;

      nameController.text = movie.name;
      directorController.text = movie.director;
      ratingController.text = movie.rating.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    directorController.dispose();
    ratingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildDirector(),
              SizedBox(height: 8),
              buildRating(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Movie Name',
        ),
        validator: (name) => name != null && name.isEmpty ? 'Enter Movie Name' : null,
      );

  Widget buildDirector() => TextFormField(
        controller: directorController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Director Name',
        ),
        validator: (name) => name != null && name.isEmpty ? 'Enter Director Name' : null,
      );

  Widget buildRating() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Rating',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) => amount != null && double.tryParse(amount) == null ? 'Enter a valid number' : null,
        controller: ratingController,
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final director = directorController.text;
          final rating = double.tryParse(ratingController.text) ?? 0;

          widget.onClickedDone(name, director, rating);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
