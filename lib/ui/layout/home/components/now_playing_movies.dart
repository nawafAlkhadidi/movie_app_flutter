import 'package:movie_app/library.dart';
import 'package:shimmer/shimmer.dart';

class NewPlayingMovies extends StatelessWidget {
  const NewPlayingMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(),
        builder: (context, child) {
          return SizedBox(
              height: context.height * 0.22,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Text(
                      "Now Playing",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppBrand.mainColor),
                    ),
                  ),

                  SizedBox(
                    height: context.height * 0.16,
                    child: FutureBuilder(
                      future: context.read<HomeProvider>().fetchNewPlaying(),
                      builder: (context, dataSnapshot) {
                        if (dataSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (_, index) =>
                                  getShimmerLoading(context));
                        }
                        return Consumer<HomeProvider>(
                          builder: (context, list, child) => ListView.builder(
                              itemCount: list.getNewPlayingMoviesList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (_, index) => SizedBox(
                                      child: NewPlayingCard(
                                    movie: list.getNewPlayingMoviesList[index],
                                  ))),
                        );
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: context.height * 0.16,

                  //  NewPlayingPoster()
                ],
              ));
        });
  }
}

class NewPlayingCard extends StatelessWidget {
  final MoviesDetailsModel movie;
  const NewPlayingCard({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          InkWell(
            onTap: () {
              Get.to(() => MovieDetailsScreen(
                    movie: movie,
                  ));
            },
            child: CachedNetworkImage(
              imageBuilder: (
                context,
                imageProvider,
              ) =>
                  Container(
                alignment: AlignmentDirectional.center,
                height: context.height * 0.15,
                width: context.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              ),
              imageUrl: "https://image.tmdb.org/t/p/w400${movie.backdropPath!}",
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          FavoritesIcon(
            movie: movie,
          )
        ],
      ),
    );
  }
}

Shimmer getShimmerLoading(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              alignment: AlignmentDirectional.center,
              height: context.height * 0.15,
              width: context.width * 0.6,
              decoration: BoxDecoration(
                color: AppBrand.blackColor.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.favorite,
                    size: 30, color: AppBrand.blackColor.withOpacity(0.4)),
                onPressed: () {},
              ),
            )
          ],
        ),
      ));
}
