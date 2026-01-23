import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDialog {
  static void show({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows dialog to move up with keyboard
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom + 24, // Keyboard padding
          left: 24,
          right: 24,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The "Handle" from your screenshot
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // DialogTitle
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // DialogContent
            child,
          ],
        ),
      ),
    );
  }
}

class AddAssignmentDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddAssignmentDialog({super.key, required this.onSave});

  @override
  State<AddAssignmentDialog> createState() => _AddAssignmentDialogState();
}

class _AddAssignmentDialogState extends State<AddAssignmentDialog> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedPriority = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212), // Deep dark background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Spacer
                  const Text(
                    "Add New Assignment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildLabel("Title"),
              _buildTextField(_titleController, "e.g., Math Homework"),

              _buildLabel("Subject"),
              _buildTextField(_subjectController, "e.g., Mathematics"),

              _buildLabel("Due Date"),
              _buildDatePicker(),

              _buildLabel("Description (Optional)"),
              _buildTextField(
                _descController,
                "Add details about this assignment...",
                maxLines: 3,
              ),

              _buildLabel("Priority"),
              _buildPrioritySelector(),

              const SizedBox(height: 32),

              // Add Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave({
                      'title': _titleController.text,
                      'subject': _subjectController.text,
                      'dueDate': _selectedDate,
                      'description': _descController.text,
                      'priority': _selectedPriority,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFC5D1EB,
                    ), // Light lavender/blue button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Add Assignment",
                    style: TextStyle(
                      color: Color(0xFF121212),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI Helpers
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 12),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  );

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white10),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? "mm/dd/yyyy"
                  : DateFormat('MM/dd/yyyy').format(_selectedDate!),
              style: TextStyle(
                color: _selectedDate == null ? Colors.white24 : Colors.white,
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: Colors.white54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    final priorities = ['High', 'Medium', 'Low'];
    return Row(
      children: priorities.map((p) {
        bool isSelected = _selectedPriority == p;
        Color accent = p == 'High'
            ? Colors.redAccent
            : (p == 'Medium' ? Colors.orangeAccent : Colors.blueAccent);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPriority = p),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D35),
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(color: accent, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    p,
                    style: TextStyle(
                      color: isSelected ? accent : Colors.white38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
