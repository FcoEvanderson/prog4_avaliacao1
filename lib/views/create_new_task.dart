import 'package:avaliacao1/providers/task_provider.dart';
import 'package:avaliacao1/widgets/Button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/TextFormField.dart';
import '../models/Task.dart';
import 'package:flutter/material.dart';

class CreateNewTask extends StatefulWidget {
  final Task? existingTask;

  const CreateNewTask({this.existingTask, super.key});

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? date;
  String? _errorMessage;
  String? _selectedType;

  final List<String> taskTypes = ['Pessoal', 'Estudo', 'Trabalho', 'Outro'];

  @override
  void initState() {
    super.initState();

    if (widget.existingTask != null) {
      _titleController.text = widget.existingTask?.title ?? '';
      _descriptionController.text = widget.existingTask?.description ?? '';
      date = widget.existingTask?.dueDate;
      _selectedType = widget.existingTask!.type;
    }
  }

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty ||
        description.isEmpty ||
        date == null ||
        _selectedType == null) {
      setState(() {
        _errorMessage = 'Todos os campos devem ser preenchidos.';
      });
      return;
    }

    const uuid = Uuid();
    String taskId = widget.existingTask?.id ?? uuid.v4();

    final newTask = Task(
      id: taskId,
      title: title.toUpperCase(),
      description: description,
      dueDate: date!,
      type: _selectedType!,
      isCompleted: false,
      isPending: false,
    );

    if (widget.existingTask == null) {
      Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
    } else {
      Provider.of<TaskProvider>(context, listen: false).updateTask(
          Provider.of<TaskProvider>(context, listen: false)
              .tasksList
              .indexWhere((task) => task.id == newTask.id),
          newTask);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 233, 233, 233),
        appBar: AppBar(
          title: Text(
              widget.existingTask != null ? 'Editar Tarefa' : 'Nova Tarefa'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Que tal tornar o seu dia mais produtivo?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Image(
                  image: AssetImage('images/newtask_image.png'),
                  width: 400,
                ),
                InputFormField(
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  labelText: 'Digite o nome da tarefa...',
                  icon: Icons.event_note,
                  controller: _titleController,
                ),
                InputFormField(
                  margin: const EdgeInsets.only(bottom: 20),
                  labelText: 'Digite a descrição da tarefa...',
                  icon: Icons.description,
                  controller: _descriptionController,
                ),
                DropdownButtonFormField(
                  value: _selectedType,
                  items: taskTypes.map((type) {
                    return DropdownMenuItem<String>(
                        value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tipo de Tarefa',
                      hintText: 'Selecione o tipo de tarefa'),
                ),
                Row(
                  children: [
                    const Text(
                      'Data Prazo:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => _selectedDate(context),
                      child: Text(
                        date == null
                            ? 'Nenhuma data selecionada'
                            : '${date!.day}/${date!.month}/${date!.year}',
                        style: TextStyle(
                            fontSize: 16,
                            color: date == null ? Colors.red : Colors.green),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PersonalizedButton(
                        textButton: false,
                        buttonText: 'Cancelar',
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      const SizedBox(width: 30),
                      PersonalizedButton(
                        textButton: false,
                        buttonText:
                            widget.existingTask == null ? 'Salvar' : 'Editar',
                        onPressed: _saveTask,
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      )
                    ],
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
