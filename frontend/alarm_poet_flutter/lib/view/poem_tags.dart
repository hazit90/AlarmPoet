import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/poem_gen_vm.dart';

class PoemTags extends StatefulWidget {
  const PoemTags({super.key});

  @override
  State<PoemTags> createState() => _PoemTagsState();
}

class _PoemTagsState extends State<PoemTags> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTag(PoemGenVm poemVm) {
    final value = _controller.text.trim();
    if (value.isNotEmpty) {
      poemVm.addString(value);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final poemVm = Provider.of<PoemGenVm>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'set tags for poem generation. e.g. sunrise, morning',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Wrap(
                spacing: 8,
                children: poemVm.tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.white,
                          labelStyle: const TextStyle(color: Colors.black87),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          onDeleted: () => poemVm.removeString(tag),
                        ))
                    .toList(),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Add tag...',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28)),
                        ),
                      ),
                      onSubmitted: (_) => _addTag(poemVm),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _addTag(poemVm),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
