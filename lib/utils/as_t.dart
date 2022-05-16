///
/// 将[value]类型转为[T]
///
/// 如果[value]类型不为[T]则返回`null`
///
T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}
