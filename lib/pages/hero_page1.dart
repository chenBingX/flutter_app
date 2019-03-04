import 'package:flutter/material.dart';
import 'package:flutter_app/datas/photo.dart';

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';
List<Photo> photos = <Photo>[
  Photo(
    assetName: 'places/india_chennai_flower_market.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Chennai',
    caption: 'Flower Market',
  ),
  Photo(
    assetName: 'places/india_tanjore_bronze_works.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Tanjore',
    caption: 'Bronze Works',
  ),
  Photo(
    assetName: 'places/india_tanjore_market_merchant.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Tanjore',
    caption: 'Market',
  ),
  Photo(
    assetName: 'places/india_tanjore_thanjavur_temple.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Tanjore',
    caption: 'Thanjavur Temple',
  ),
  Photo(
    assetName: 'places/india_tanjore_thanjavur_temple_carvings.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Tanjore',
    caption: 'Thanjavur Temple',
  ),
  Photo(
    assetName: 'places/india_pondicherry_salt_farm.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Pondicherry',
    caption: 'Salt Farm',
  ),
  Photo(
    assetName: 'places/india_chennai_highway.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Chennai',
    caption: 'Scooters',
  ),
  Photo(
    assetName: 'places/india_chettinad_silk_maker.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Chettinad',
    caption: 'Silk Maker',
  ),
  Photo(
    assetName: 'places/india_chettinad_produce.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Chettinad',
    caption: 'Lunch Prep',
  ),
  Photo(
    assetName: 'places/india_tanjore_market_technology.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Tanjore',
    caption: 'Market',
  ),
  Photo(
    assetName: 'places/india_pondicherry_beach.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Pondicherry',
    caption: 'Beach',
  ),
  Photo(
    assetName: 'places/india_pondicherry_fisherman.png',
    assetPackage: _kGalleryAssetsPackage,
    title: 'Pondicherry',
    caption: 'Fisherman',
  ),
];

class HeroPageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero PageA'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                childAspectRatio:
                    (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: photos.map<Widget>((Photo photo) {
                  return GridDemoPhotoItem(
                    photo: photo,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridDemoPhotoItem extends StatelessWidget {
  GridDemoPhotoItem({
    Key key,
    @required this.photo,
  })  : assert(photo != null && photo.isValid),
        super(key: key);

  final Photo photo;

  void showPhoto(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Hero PageB')),
        body: SizedBox.expand(
          child: Hero(
            tag: photo.tag,
            child: ClipRect(
              child: Image.asset(
                photo.assetName,
                package: photo.assetPackage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showPhoto(context);
        },
        child: Hero(
            key: Key(photo.assetName),
            tag: photo.tag,
            child: Image.asset(
              photo.assetName,
              package: photo.assetPackage,
              fit: BoxFit.cover,
            )));
  }
}
