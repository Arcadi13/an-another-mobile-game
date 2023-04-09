enum DeveloperType {
  fullstack,
  artist,
  uiDesigner,
  gameArtist,
  animator,
  programmer,
  gameDesigner,
  soundEngineer,
  creativeDirector,
  marketing,
  systemDesigner,
  toolDesigner,
  vfxArtist,
  levelDesigner
}

class Developer {
  Developer(
      this.type, this.productivity, this.cost, this.title, this.description);

  final DeveloperType type;
  final int productivity;
  final int cost;
  final String title;
  final String description;
}
