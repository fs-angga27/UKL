import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukl_revisi/model/Addsong.dart';
import 'package:ukl_revisi/service/addsong.dart';

class AddSongPage extends StatefulWidget {
  @override
  _AddSongPageState createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sourceController = TextEditingController();
  File? _imageFile;
  final _service = AddSongService();

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final size = await file.length();
      if (size <= 2 * 1024 * 1024) {
        setState(() => _imageFile = file);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File too large. Max size is 2MB.')),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tambahkan thumbnail nya')),
      );
      return;
    }

    final song = AddSong(
      title: _titleController.text,
      artist: _artistController.text,
      description: _descriptionController.text,
      source: _sourceController.text.isEmpty ? 'www.youtube.com' : _sourceController.text,
    );

    final success = await _service.uploadSong(song, _imageFile);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song saved!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload song')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new song')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _artistController,
                decoration: InputDecoration(labelText: 'Artist'),
                validator: (v) => v!.isEmpty ? 'Please enter artist name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Please enter description' : null,
              ),
              TextFormField(
                controller: _sourceController,
                decoration: InputDecoration(labelText: 'Source'),
                validator: (v) => v!.isEmpty ? 'Please enter source' : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickThumbnail,
                child: Text(_imageFile == null ? 'Choose Thumbnail' : 'Change Thumbnail'),
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(
                    _imageFile!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Save Song'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}