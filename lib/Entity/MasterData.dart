class MasterData{
  String TopSlider_Id="";
  String TopSlider_Content="";
  String  Description="";
  String Video_ID="";
  String imagespath="";

  MasterData(this.TopSlider_Id, this.TopSlider_Content, this.Description,
      this.Video_ID, this.imagespath);

  factory MasterData.fromMap(Map<String, dynamic> data) {

    return MasterData(
      data['TopSlider_Id'],
      data['TopSlider_Content'],
      data['Description'],
      data['Video_ID'],
      data['imagespath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TopSlider_Id':TopSlider_Id,
      'TopSlider_Content':TopSlider_Content,
      'Description':Description,
      'Video_ID':Video_ID,
      'imagespath':imagespath,
    };
  }
}
