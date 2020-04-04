abstract class BaseModel<T> {
  BaseModel();
  update(T item);
  toMap();
  String getUid();
  setUid(String uId);
}