
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wecare/core/services/auth_service.dart';

void showReviewDialog(BuildContext context, int doctorId, int patientId) {
  double currentRating = 3.0; 
  TextEditingController commentController = TextEditingController();
  bool isLoading = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), 
            title: Text('تقييم الطبيب', textAlign: TextAlign.center, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)), // 🔴 خط متجاوب
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ما رأيك في تجربتك مع الطبيب؟', style: TextStyle(fontSize: 14.sp)), 
                SizedBox(height: 15.h), 
                RatingBar.builder(
                  initialRating: currentRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 32.sp, 
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.w), 
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    currentRating = rating;
                  },
                ),
                SizedBox(height: 15.h), 
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  style: TextStyle(fontSize: 15.sp), 
                  decoration: InputDecoration(
                    hintText: 'اكتب تعليقك هنا (اختياري)...',
                    hintStyle: TextStyle(fontSize: 14.sp), 
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r), 
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: TextStyle(fontSize: 14.sp)), 
              ),
              isLoading 
                ? const SizedBox(
                    width: 24, 
                    height: 24, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  ) 
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)), 
                    ),
                    onPressed: () async {
                      setState(() { isLoading = true; });

                      AuthService authService = AuthService();
                      bool success = await authService.submitDoctorReview(
                        doctorId: doctorId,
                        patientId: patientId,
                        rating: currentRating.toInt(),
                        comment: commentController.text,
                      );

                      setState(() { isLoading = false; });

                      if (success) {
                        Navigator.pop(context); 
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('شكراً لك! تم إرسال تقييمك بنجاح.', style: TextStyle(fontSize: 14.sp)), 
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('حدث خطأ، يرجى المحاولة لاحقاً.', style: TextStyle(fontSize: 14.sp)),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('إرسال التقييم', style: TextStyle(fontSize: 14.sp)), 
                  ),
            ],
          );
        }
      );
    },
  );
}