class TaskModel {
  int? id;
  String title;
  int isDone;

  TaskModel({this.id, required this.title, this.isDone = 0});

  // transforma em map (chave valor) para pode salvar no banco - map é um tipo de json que o sqflite usa para salvar os dados
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isDone': isDone};
  }

  // pega o map que vem do banco e transforma em TaskModel(objeto)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'],
    );
  }
}
