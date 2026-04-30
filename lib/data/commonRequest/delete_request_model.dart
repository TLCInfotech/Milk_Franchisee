class DeleteIRequestModel {
  String id;
  String modifier;
  String modifierMachine;

  DeleteIRequestModel({
    required this.id,
    required this.modifier,
    required this.modifierMachine,
  });

  factory DeleteIRequestModel.fromJson(Map<String, dynamic> json) {
    return DeleteIRequestModel(
      id: json['Code'],
      modifier: json['Modifier'],
      modifierMachine: json['Modifier_Machine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': id,
      'Modifier': modifier,
      'Modifier_Machine': modifierMachine,
    };
  }
  
}
