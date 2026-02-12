import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';

class TermUseScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  TermUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 24.h),
        child: Column(
          children: [
            Expanded(
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(
                    Colors.green,
                  ), // Change thumb color
                  trackColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ), // Change track color
                  trackVisibility: MaterialStateProperty.all(
                    true,
                  ), // Show track
                  thickness: MaterialStateProperty.all(
                    8,
                  ), // Thickness of the scrollbar
                  radius: Radius.circular(10), // Rounded corners
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  thickness: 8.0,
                  radius: const Radius.circular(10),
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(),
                              Text(
                                "Terms of Use",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.black,
                              ),
                              children: const [
                                TextSpan(
                                  text:
                                      "Please indicate your approval and understanding before starting your clinic visit with a Telemedicine Hub healthcare provider.\n",
                                ),
                                TextSpan(
                                  text:
                                      "\nI ACKNOWLEDGE THAT TELEMEDICINE HUB CLINIC VISIT IS NOT DESIGNED OR INTENDED OR APPROPRIATE TO ADDRESS SERIOUS, EMERGENCY, OR ANY LIFE THREATINING MEDICAL CONDITIONS AND SHOULD NOT BE USED IN THOSE CIRCUMSTANCES.\n",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      "\nI acknowledge that I will answer questions truthfully and that if I do not understand a question, I will stop using Telemedicine Hub clinic.",
                                ),
                                TextSpan(
                                  text:
                                      "\nI understand and acknowledge that my ",
                                ),
                                TextSpan(
                                  text:
                                      "Telemedicine Hub clinic will establish a therapeutic clinician patient relationship and that my visit information will result in the creation of a medical record of Telemedicine Hub.\n",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "\nI acknowledge that I have "),
                                TextSpan(
                                  text: "agreed to the Terms of use, ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "and I "),
                                TextSpan(
                                  text: "understand the privacy policy",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      "and Telemedicine Hub’s notice of privacy practices which describes how my provider(s) will use and disclose my information and informs me of my rights relating to my information.\n",
                                ),
                                TextSpan(
                                  text: "\nConsent for treatment: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      "I will have a chance to discuss and /or refuse the care recommended by my Telemedicine Hub clinic provider, certified clinician licensed to practice medicine in Iraq. Telemedicine Hub providers cannot promise specific results. To provide this care, my Telemedicine Hub clinic provider will rely on information I provide about my health, including genetic information such as family health history.\nElectronic health record: Telemedicine Hub clinic uses shared electronic health records. This allows care providers using this record to store, update, and use my health information when needed at the time I am seeking care. the electronic health record allows better access to my health information, leading to better coordination and quality of care. this shared electronic health record is a secure system. For a list of the health care providers that use this shared electronic health record please contact us at the phone number listed below.\nI acknowledge that any care provider who uses this shared electronic health record may access and use my health records as needed to provide treatment (including coordinating my care) and to improve the quality of care.\nIf I have concerns with parts of this consent, I will call the number below to discuss them.\nThe authorization on this form will remain valid until I revoke (withdraw) them in writing or until the law states that they have expired. However, any actions already taken in reliance upon these authorizations will remain valid. (I cannot undo actions that were taken while my consent was valid).\nI may get help with this process at any time by contacting Telemedicine Hub clinic.\nBy signing this form, I consent to and authorize the Telemedicine Hub clinic medical provider to assess and recommend treatment if necessary.",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 70.h),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 300,
                              child: DynamicButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
