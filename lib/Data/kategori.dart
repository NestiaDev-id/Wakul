class Kategori {
  String name;
  List<String> imageAsset;
  List<String> imageUrls;

  Kategori({
    required this.name,
    required this.imageAsset,
    required this.imageUrls,
  });
}

var kategoriList = [
  Kategori(
    name: 'Makanan',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?food',
      'https://source.unsplash.com/random/720x300/?banner-food',
    ],
  ),
  Kategori(
    name: 'Minuman',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?drink',
      'https://source.unsplash.com/random/720x300/?banner-drink',
    ],
  ),
  Kategori(
    name: 'Snack',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?snack',
      'https://source.unsplash.com/random/720x300/?banner-snack',
    ],
  ),
  Kategori(
    name: 'FastFood',
    imageAsset: [
      'images/makan1.png',
    ],
    imageUrls: [
      'https://source.unsplash.com/random/400x500/?FastFood',
      'https://source.unsplash.com/random/720x300/?banner-FastFood',
    ],
  ),
];
