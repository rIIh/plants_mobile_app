bool isNull<T>(T value) => value == null;

bool isNotNull<T>(T value) => value != null;

bool Function(V element) equals<T, V>({ T to, T Function(V object) byObject }) => (element) => isNull(byObject) ? element == to : byObject(element) == to;
bool Function(V element) notEquals<T, V>({ T to, T Function(V object) byObject }) => (element) => isNull(byObject) ? element != to : byObject(element) != to;

String toString(dynamic object) => object.toString();