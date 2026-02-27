import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';

class HomePage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  final TextEditingController textController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      body: Obx(() {
        if (taskController.taskList.isEmpty) {
          return const Center(
            child: Text('Nenhuma tarefa ainda. Adicione uma!'),
          );
        }

        return ListView.builder(
          itemCount: taskController.taskList.length,
          itemBuilder: (context, index) {
            var task = taskController.taskList[index];

            return ListTile(
              leading: Checkbox(
                value: task.isDone == 1,
                onChanged: (value) {
                  taskController.updateTask(task);
                },
              ),

              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isDone == 1
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      textController.text = task.title;

                      Get.defaultDialog(
                        title: 'Editar Tarefa',
                        content: TextField(
                          controller: textController,
                          decoration: const InputDecoration(
                            hintText: "Novo título...",
                          ),
                        ),
                        textConfirm: 'Atualizar',
                        textCancel: 'Cancelar',
                        confirmTextColor: Colors.white,
                        onConfirm: () async {
                          if (textController.text.isNotEmpty) {
                            await taskController.editTitleTasK(
                              task,
                              textController.text,
                            );
                            Get.back();
                          }
                        },
                      );
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Atenção",
                        middleText:
                            "Tem certeza que deseja apagar esta tarefa?",
                        textConfirm: "Sim",
                        textCancel: "Não",
                        confirmTextColor: Colors.white,
                        onConfirm: () async {
                          await taskController.deleteTask(task.id!);
                          Get.back();
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          textController.clear();

          Get.defaultDialog(
            title: "Adicionar Tarefa",
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Descreva a tarefa"),
            ),
            textConfirm: "Adicionar",
            textCancel: "Cancelar",
            onConfirm: () {
              if (textController.text.isNotEmpty) {
                taskController.addTask(textController.text);
                Get.back();
              }
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
