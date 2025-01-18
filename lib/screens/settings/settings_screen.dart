import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_upload, color: Colors.blue),
            title: const Text('Backup Data'),
            subtitle: const Text('Backup your data to the cloud.'),
            onTap: () {
              // Add logic for cloud backup
              _showSnackbar(context, 'Backup started...');
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download, color: Colors.green),
            title: const Text('Restore Data'),
            subtitle: const Text('Restore your data from the cloud.'),
            onTap: () {
              // Add logic for restoring data
              _showSnackbar(context, 'Restore initiated...');
            },
          ),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.orange),
            title: const Text('Export Data'),
            subtitle: const Text('Export your data as a file.'),
            onTap: () {
              // Add logic for exporting data
              _showSnackbar(context, 'Exporting data...');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Clear All Data'),
            subtitle: const Text('Permanently delete all data from the app.'),
            onTap: () {
              _showConfirmationDialog(
                context,
                'Clear All Data',
                'Are you sure you want to delete all data? This action cannot be undone.',
                (){
                  // Add logic for clearing data
                  _showSnackbar(context, 'All data cleared.');
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Perform the action
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
