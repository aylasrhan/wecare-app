import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/auth/login/data/models/user_model.dart'; // تأكدي من مسار الـ AuthService الصحيح
// استدعي ملف الـ AuthService هنا

void showReviewDialog(BuildContext context, int doctorId, int patientId) {
  double currentRating = 3.0; // التقييم الافتراضي
  TextEditingController commentController = TextEditingController();
  bool isLoading = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('تقييم الطبيب', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('ما رأيك في تجربتك مع الطبيب؟'),
                const SizedBox(height: 15),
                // النجوم
                RatingBar.builder(
                  initialRating: currentRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    currentRating = rating;
                  },
                ),
                const SizedBox(height: 15),
                // حقل التعليق
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'اكتب تعليقك هنا (اختياري)...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              isLoading 
                ? const CircularProgressIndicator() 
                : ElevatedButton(
                    onPressed: () async {
                      setState(() { isLoading = true; });

                      // 🔴 التعديل هنا: استدعاء دالة التقييم من AuthService
                      AuthService authService = AuthService();
                      bool success = await authService.submitDoctorReview(
                        doctorId: doctorId,
                        patientId: patientId,
                        rating: currentRating.toInt(),
                        comment: commentController.text,
                      );

                      setState(() { isLoading = false; });

                      if (success) {
                        Navigator.pop(context); // إغلاق النافذة
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('شكراً لك! تم إرسال تقييمك بنجاح.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('حدث خطأ، يرجى المحاولة لاحقاً.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text('إرسال التقييم'),
                  ),
            ],
          );
        }
      );
    },
  );
}