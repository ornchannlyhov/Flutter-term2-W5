import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/song_provider.dart';
import 'song_form_dialog.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key});

  Future<bool> _showDeleteConfirmation(BuildContext context, Song song) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
                'Are you sure you want to delete "${song.title}" by ${song.artist}?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                child: const Text('Delete'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = context.watch<SongProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Awesome Songs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh List',
            onPressed: () => context.read<SongProvider>().fetchSongs(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Song',
            onPressed: () => SongFormDialog.show(context),
          ),
        ],
      ),
      body: songProvider.songsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error) => _buildErrorState(context, error),
        success: (songs) => songs.isEmpty
            ? _buildEmptyState(context)
            : _buildSongList(context, songs),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error loading songs:',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              onPressed: () => context.read<SongProvider>().fetchSongs(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.music_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text("No songs yet!",
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text("Tap the '+' button to add your first song."),
        ],
      ),
    );
  }

  Widget _buildSongList(BuildContext context, List<Song> songs) {
    return ListView.separated(
      itemCount: songs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(
                song.artist.isNotEmpty ? song.artist[0].toUpperCase() : '?'),
          ),
          title: Text(song.title,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(song.artist),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                tooltip: 'Edit Song',
                onPressed: () => SongFormDialog.show(context, song: song),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: 'Delete Song',
                onPressed: () => _deleteSong(context, song),
              ),
            ],
          ),
          onTap: () {
            // ignore: avoid_print
            print("Tapped on ${song.title}");
          },
        );
      },
    );
  }

  Future<void> _deleteSong(BuildContext context, Song song) async {
    final confirmed = await _showDeleteConfirmation(context, song);
    if (confirmed && context.mounted) {
      try {
        await context.read<SongProvider>().removeSong(song);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${song.title}" deleted.'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting song: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
