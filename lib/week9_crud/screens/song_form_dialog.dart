import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/song_provider.dart';

class SongFormDialog extends StatefulWidget {
  final Song? song;

  const SongFormDialog({this.song, super.key});

  static Future<void> show(BuildContext context, {Song? song}) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return ChangeNotifierProvider.value(
          value: context.read<SongProvider>(),
          child: SongFormDialog(song: song),
        );
      },
    );
  }

  @override
  State<SongFormDialog> createState() => _SongFormDialogState();
}

class _SongFormDialogState extends State<SongFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _artistController;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.song?.title ?? '');
    _artistController = TextEditingController(text: widget.song?.artist ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final title = _titleController.text.trim();
    final artist = _artistController.text.trim();
    final provider = context.read<SongProvider>();

    try {
      if (widget.song == null) {
        await provider.addSong(title, artist);
      } else {
        await provider
            .updateSong(widget.song!.copyWith(title: title, artist: artist));
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = "Error: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.song == null ? 'Add New Song' : 'Edit Song'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_titleController, 'Title', 'Enter song title',
                Icons.music_note),
            const SizedBox(height: 8),
            _buildTextField(
                _artistController, 'Artist', 'Enter artist name', Icons.person),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(_errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: _isSaving ? null : _submitForm,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                )
              : Text(widget.song == null ? 'Add' : 'Save Changes'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, hintText: hint, icon: Icon(icon)),
      validator: (value) =>
          value?.trim().isEmpty ?? true ? 'Please enter a $label' : null,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => _isSaving ? null : _submitForm(),
      enabled: !_isSaving,
    );
  }
}
