import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

class CategoryLoadingPlaceholder extends StatelessWidget {
  const CategoryLoadingPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: true,
      child: Container(
        height: 32,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class PostCardLoadingPlaceholder extends StatelessWidget {
  const PostCardLoadingPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ShimmerLoading(
        isLoading: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured image placeholder
            Container(
              height: 200,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories placeholder
                  Row(
                    children: List.generate(
                      2,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        height: 32,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title placeholder
                  Container(
                    height: 24,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Excerpt placeholder
                  Column(
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Metadata placeholder
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 36,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
