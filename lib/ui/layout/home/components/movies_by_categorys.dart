import 'package:movie_app/library.dart';
import 'package:shimmer/shimmer.dart';

class MoviesByCategorys extends StatelessWidget {
  const MoviesByCategorys({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
        create: (_) => HomeProvider(),
        builder: (context, child) {
          return SizedBox(
              height: context.height * 0.4,
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
                      "Movies",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppBrand.mainColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: SizedBox(
                      height: 70,
                      child: FutureBuilder(
                        future: context.read<HomeProvider>().fetchCategorys(),
                        builder: (context, dataSnapshot) {
                          {
                            if (dataSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListView.builder(
                                  itemCount: 5,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (_, index) =>
                                      shimmeCategorysLoading(context));
                            }
                            return Consumer<HomeProvider>(
                              builder: (context, list, child) =>
                                  ListView.builder(
                                      itemCount: list.getCategorysList.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: false,
                                      primary: false,
                                      itemBuilder: (_, index) => CategorysCard(
                                            id: list.getCategorysList[index].id,
                                            name: list
                                                .getCategorysList[index].name
                                                .toString(),
                                          )),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.21,
                    child: FutureBuilder(
                      future: context
                          .read<HomeProvider>()
                          .fetchMoviesBycategorysList(id: 28),
                      builder: (context, dataSnapshot) {
                        {
                          if (dataSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListView.builder(
                                itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (_, index) =>
                                    shimmerMoviesByCategorysLoading(context));
                          }
                          return Consumer<HomeProvider>(
                            builder: (context, list, child) {
                              List<MoviesDetailsModel> myList =
                                  list.getMoviesBycategorysList;
                              return ListView.builder(
                                  itemCount: myList.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (_, index) => SizedBox(
                                      child: MoviesByCategorysCard(
                                          movie: myList[index])));
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ));
        });
  }
}

class MoviesByCategorysCard extends StatelessWidget {
  final MoviesDetailsModel movie;

  const MoviesByCategorysCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
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
                height: context.height * 0.2,
                width: context.width * 0.31,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                ),
              ),
              imageUrl: "https://image.tmdb.org/t/p/w500${movie.posterPath!}",
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

class CategorysCard extends StatelessWidget {
  final String? name;
  final int? id;

  const CategorysCard({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: context.read<HomeProvider>().getCategoryId == id
              ? AppBrand.secondColor
              : AppBrand.whiteColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      height: 60,
      width: 85,
      child: Stack(
        children: [
          Center(
              child: Text(
            name!,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              canRequestFocus: false,
              onTap: () {
                context.read<HomeProvider>().setCatagoryId(id!);
                context.read<HomeProvider>().fetchMoviesBycategorysList(id: id);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Shimmer shimmerMoviesByCategorysLoading(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              alignment: AlignmentDirectional.center,
              height: context.height * 0.2,
              width: context.width * 0.31,
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

Shimmer shimmeCategorysLoading(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppBrand.blackColor.withOpacity(0.4),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        height: 60,
        width: 85,
      ),
    ),
  );
}
