class GetUserModel {
  final String phone;
final String password;
final String login;
final String? a;
final String? b;
final String? c;
final String? d;
final String? e;
final String? f;
final String? g;
final String? h;
final String? i;
final String? j;
final String? k;
final String? l;
final String? m;
final String? n;
final String? o;
final String? p;
final String? q;
final String? r;
final String? s;
final String? t;
final String? u;
final String? v;
final String? w;
final String? x;
final String? y;
final String? z;


  GetUserModel({
     required this.phone,
  required this.password,
  required this.login,
  this.a, this.b, this.c, this.d, this.e, this.f, this.g, this.h,
  this.i, this.j, this.k, this.l, this.m, this.n, this.o, this.p,
  this.q, this.r, this.s, this.t, this.u, this.v, this.w, this.x,
  this.y, this.z,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
  return GetUserModel(
    phone: json["phone"] ?? "",
    password: json["password"] ?? "",
    login: json["login"] ?? "",
    a: json["a"],
    b: json["b"],
    c: json["c"],
    d: json["d"],
    e: json["e"],
    f: json["f"],
    g: json["g"],
    h: json["h"],
    i: json["i"],
    j: json["j"],
    k: json["k"],
    l: json["l"],
    m: json["m"],
    n: json["n"],
    o: json["o"],
    p: json["p"],
    q: json["q"],
    r: json["r"],
    s: json["s"],
    t: json["t"],
    u: json["u"],
    v: json["v"],
    w: json["w"],
    x: json["x"],
    y: json["y"],
    z: json["z"],
  );
}

}
