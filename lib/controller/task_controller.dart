import 'package:get/get.dart';
import '../models/task_model.dart';
import '../database/db_helper.dart';

class TaskController extends GetxController {
  var taskList = <TaskModel>[].obs;

  final DBHelper _dbHelper = DBHelper();

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await _dbHelper.getTasks();

    taskList.assignAll(tasks);
  }

  Future<void> addTask(String title) async {
    if (title.isEmpty) return;

    var newTask = TaskModel(title: title, isDone: 0);

    await _dbHelper.insertTask(newTask);
    loadTasks();
  }

  Future<void> editTitleTasK(TaskModel task, String newTitle) async {
    if (newTitle.isEmpty) return;

    task.title = newTitle;

    await _dbHelper.updateTask(task);
    loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    task.isDone = task.isDone == 0 ? 1 : 0;

    await _dbHelper.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    loadTasks();
  }
}
