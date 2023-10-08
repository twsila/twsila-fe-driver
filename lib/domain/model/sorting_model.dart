enum SortCriterion {
  REQUEST_DATE,
  NEAREST_TO_ME,
  LIGHT_WEIGHT,
  SHORT_DISTANCE,
  HIGH_PRICE,
  TOP_RATED_CLIENT
}

class SortingModel {
  SortCriterion id;
  String title;

  SortingModel(this.id, this.title);
}
