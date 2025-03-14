import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpifit/config/colors.dart';

class AllWorkoutPage extends ConsumerStatefulWidget {
  const AllWorkoutPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllWorkoutPageState();
}

class _AllWorkoutPageState extends ConsumerState<AllWorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        width: double.infinity,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.5, color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.sports_football,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Basket Ball',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '7 Maret 2025 07:45',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '20  Menit 15 detik',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.navigate_next_rounded,
                    size: 30,
                    color: Colors.grey,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
