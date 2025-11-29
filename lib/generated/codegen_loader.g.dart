// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en = {
    "TEST_ONLY": {
      "happy": "happy",
      "computer95": "computer95",
      "age": "age {}",
      "name": "name {name}"
    },
    "currency": {"SAR": "{} sar", "EGP": "{} EGP", "USD": "{} USD"},
    "about": {
      "credits": "about app",
      "team": "team",
      "back_end": "back end",
      "front_end": "front end",
      "app_owner": "app owner",
      "sounds": "sounds",
      "thanks_to": "thanks toـ{}",
      "visit_us": "visit us"
    },
    "general_titles": {
      "app_title": "El Captain",
      "continue": "continue",
      "calculate": "calculate",
      "add": "add",
      "edit": "edit",
      "next": "next",
      "upload": "upload",
      "confirm": "confirm",
      "reload": "reload",
      "ok": "ok",
      "cancel": "cancel",
      "close": "close",
      "back": "back",
      "reset": "reset",
      "media_souce": "media source",
      "images_library": "images library",
      "camera_roll": "camera",
      "loading": "loading",
      "show_all": "show all",
      "chat": {
        "attachments": "attachments",
        "image": "attach image",
        "video": "attach video",
        "voice_note": "attach voice note",
        "copied": "copied",
        "send_message": "send message...",
        "no_rooms_found": "no chat found",
        "sent_image": "image sent",
        "sent_voice_note": "voice not sent",
        "start_chat": "start chat",
        "no_active_chats": "not chat history"
      },
      "g_gender": {"title": "gender", "male": "male", "female": "female"},
      "day_off_rest": "rest day",
      "ranges": {
        "less": " less than {num}",
        "from_to": "from {from} to {to}",
        "or_above": "{num} more than "
      },
      "result": "result",
      "age": "age",
      "category": "category",
      "copy": "copy",
      "copied_to_clipboard": " copy",
      "options": "options",
      "optional": "(optional)",
      "go_to_settings": "open sound settings",
      "favorite": "favorite",
      "how_we_calculate": "How do we calculate?",
      "what_are_our_sources": "What are our sources?",
      "where_certes":
          "Our trainers have the most prestigious training certificates to get the best results to maintain your health"
    },
    "search": {
      "start": "search {query} ",
      "no_results": "no result found",
      "err_searching": " error search {query}"
    },
    "success": {
      "data_update": {
        "personal_info": "personal data added successfully ",
        "password": " password is changed successfully"
      },
      "favorite": {
        "create": "added to favorites",
        "delete": "like engagement is deleted"
      },
      "deleted": "deleted success",
      "created": "new program is made",
      "email_verified": "your email is verified successfully",
      "code_resent": "code has been resent",
      "changed": "Done successfully",
      "password_changed_successfuly": "new password is changed",
      "payment_success": "Subscription was successful"
    },
    "error": {
      "no_data_avaiable": "there is no data try again",
      "error_happened": " something is wrong please try again ",
      "error_happened_because":
          "  something is wrong  {cause} ,try again later ",
      "retry": "retry",
      "enter_valid": "enter the right data",
      "login_error": "email or password is wrong",
      "data_update": {
        "personal_info": "data update failed try again",
        "password": "new password updated failed try again"
      },
      "logout": "logout failed try again",
      "validation": {
        "required_field": "required data",
        "required_image": "required image"
      },
      "apple_not_available": "Apple login is not working",
      "wrong_code": "wrong code",
      "verification": {
        "user_not_verified": "verify your email to complete",
        "not_verified_title": "your email is not verified",
        "not_verified":
            "you didn't verify your email , we sent a code to your email please use it to verify "
      },
      "audio": {"permission": "we need permission to apply your microphone"}
    },
    "auth": {
      "terms": {
        "accept": "Accept",
        "use": "use",
        "and": "and",
        "use_of_personal_data": "my personal data",
        "info": {
          "why_we_need_info": "we need these information",
          "personal_info_explanation": "  we need these information for team",
          "not_for_sale": "your data is not shared with anyone"
        }
      },
      "general": {
        "country": "Country",
        "phone": "Phone",
        "email": "Email",
        "name": "Name",
        "password": "Password",
        "password_confirmation": "Confirm Password",
        "validation": {
          "required_field": "required information",
          "invalid_email": "invalid email",
          "weak_password": "password is weak",
          "password_not_match": "password is not matched",
          "invalid_phone": "wrong phone number",
          "invalid_password": "wrong password"
        },
        "code_verification": {
          "verify_email": "Verify your email",
          "check_your_email": "  check the code on your email {email}",
          "check_email": "check the code on your email",
          "spam_wranging": " if you didn't find code check spam list"
        }
      },
      "logout": {
        "title": "Logout",
        "are_you_sure": "Are you sure",
        "are_you_sure_desc": "Are you sure for logging out ? "
      },
      "registation": {
        "title": "Registration",
        "accept_terms_of_service": "Accept terms of service",
        "have_an_account": "Already have account?"
      },
      "login": {
        "title": "Login",
        "forget_password": "Forgot your password?",
        "have_no_account": "Create new account"
      },
      "social": {
        "sing_in_with_apple": "Login by Apple",
        "sing_in_with_facebook": "Login by Facebook",
        "sing_in_with_google": "Login by Google"
      },
      "password_recovery": {
        "reset_passwrod": "Reset Password",
        "resend_code": "Resend Code",
        "can_resend_after": "You can resend code after  {time} minutes",
        "change_password": "Change Password",
        "new_password": "New Password",
        "new_password_confirmation": "Confirm new password",
        "enter_email": "Enter your email to send code"
      },
      "delete_account": {
        "title": "Delete Account",
        "are_you_sure": "Are you sure",
        "are_you_sure_desc":
            "Are you sure for deleting your account? You will lose all your data",
        "delete": "Delete"
      },
      "guest_user": {
        "needs_login": {
          "title": "Login now for free",
          "description":
              "Login now to start enjoying all the features of our application."
        },
        "needs_payed_login": {
          "title":
              "This feature requires you to be signed up with us to enjoy it",
          "description": "Sign up now for free"
        },
        "login_now": "Login now",
        "skip": "Skip"
      }
    },
    "screens": {
      "general": {
        "comments": "Comments",
        "comment": "Comment",
        "likes": "Likes",
        "loved_it": "Liked it",
        "write_a_comment": " write a comment ...",
        "be_first_commenter": "be first to share a comment",
        "duration": "duration",
        "duration_weeks": "{num} weeks",
        "duration_months": "{num} months",
        "exercise_r": {
          "steps_and_reps": "sets and reps",
          "exercise": "exercise",
          "exercise_num": "{num} exercise",
          "exercise_name": "exercise name",
          "sets": "sets",
          "repeats": "repeats",
          "rest": "rest time",
          "rest_time": "{time} second",
          "exer_plan": "exercise system",
          "sets_num": "sets: {num}",
          "repeats_num": "repetition: {num} time",
          "rest_duration": "rest time : {time} second",
          "plan": "exercise system : {plan}",
          "exercise_type": "exercise type",
          "exercise_with_num": " exercise number #{num}",
          "exercises": "exercises"
        },
        "body_part": "body part",
        "description": "description",
        "steps": "steps",
        "week": "week",
        "week_num": " week {num}",
        "week_days": {
          "Monday": "Monday",
          "Tuesday": "Tuesday",
          "Wednesday": "wednesday",
          "Thursday": "Thursday",
          "Friday": "Friday",
          "Saturday": "Saturday",
          "Sunday": "Sunday"
        },
        "free_day": "rest day",
        "exercises": "exercises",
        "exercises_num": "{num} exercise",
        "speed": "exercises",
        "commenting": {"delete_comment": "delete comment"}
      },
      "articles": {
        "title": "Articles",
        "search": "search for your favorite article..."
      },
      "power_training": {"title": "Top Exercise"},
      "all_muscles": {
        "title": "All Muscles",
        "primary_muscle": " primary muscle",
        "secondary_muscle": " assisted muscle",
        "body_part": "body part",
        "description": "description",
        "steps": "steps"
      },
      "utilities": {
        "title": "Tools",
        "general": {
          "goal": "goal",
          "height": "height",
          "weight": "weight",
          "units": {
            "m": "meter",
            "km": "km",
            "cm": "cm",
            "g": "gm",
            "kg": "kg",
            "m_num": "{num} meter",
            "km_num": "{num} km",
            "cm_num": "{num} cm",
            "g_num": "{num} gm",
            "calory_num": "{num} calory",
            "kg_num": "{num} kg"
          }
        },
        "calculators": {
          "BMI_calc": {
            "title": "BMI calculator",
            "result": {
              "your_score": "result",
              "range": "range",
              "BMI_table": "BMI table",
              "category": {
                "title": "category",
                "sev_under": "very thin",
                "under": "slim",
                "normal": "normal",
                "over": "over weight",
                "extreme": "Excessive obesity"
              }
            }
          },
          "protine_calc": {
            "title": "Protein calculator",
            "fitness_level": {
              "title": "fitness level",
              "no_exercise": "no exercise",
              "low_level": {
                "title": "low activity",
                "sub_title": "running or session 2 per week "
              },
              "active_level": {
                "title": "high exercise",
                "sub_title": "running or swimming or bike 5 hours per week"
              },
              "sports": {
                "title": "sporty",
                "sub_title": " you do sports for 5 hours per week  "
              },
              "weight_training": {
                "title": "weight training",
                "sub_title": "training for muscle mass"
              }
            },
            "result": {"required_protein": "required protein"}
          },
          "calories_calc": {
            "title": "Calory calculator",
            "dcn": "calories",
            "calory_num": "{num} calory ",
            "calory": "calory ",
            "activity": {
              "title": "activity",
              "select": "select activity",
              "basic_metabolism": "basic metabolism",
              "sendentary": " simple : only activity at work",
              "light": "low exercise level : training 1-3 days per week",
              "modrate": "moderate level : training 3-5 days per week",
              "very_active": "very active : training 6-7 days per week",
              "extra_active": "High intensity: training 6-7 days high intensity"
            },
            "result": {
              "title": "results",
              "calo_loss_per_day": "calories needed to lose {num} kg per week",
              "calo_gain_per_day": "calories needed to gain {num} kg per week",
              "cal_to_mentain": "calories to maintain (without exercising)"
            }
          },
          "fat_calc": {
            "title": "Fat calculator",
            "results": {
              "body_fat_persentage": "Body fat percentage",
              "fat_mass": "Fat mass",
              "lean_mass": "lean mass",
              "table": {
                "under": "Low fat",
                "healthy": "Healthy",
                "over": "over weight",
                "obese": "Excessive obesity",
                "essential_fat": "essential fats",
                "atheletes": "athletes",
                "fitness": "fit",
                "average": "intermediate"
              }
            }
          },
          "carbs_calc": {"title": "Carbohydrate calculator"}
        }
      },
      "plans": {
        "title": "Workout Plans",
        "my_plans": "My plans",
        "goal": "Goal",
        "requirment": "requirement",
        "target_group": "exercise class",
        "custom_plans": {
          "title": "My own workouts",
          "create_new": "Add new workout plan",
          "add_work_out": "Add exercise",
          "details": "Details",
          "select_muscle": "Select Muscle",
          "select_exercise": "Select Exercise",
          "plan": {"name": "name"},
          "new_week": {
            "title": "add one more week",
            "content": "you can add new week for the program from here"
          },
          "reps_description":
              "you can set kind of exercises like superset (10-10) or pyramid set (12-10-8)",
          "exercise_type": "exercise type",
          "select_exercise_type": "choose exercise type",
          "enter_valid_exercises": "enter valid exercise",
          "exercises_description": "these exercises are part of the workout",
          "for_more_details":
              "to know what kinds of exercise program go to articles partition then join training basics"
        }
      }
    },
    "drawer": {
      "settings": {
        "title": "Settings",
        "personal_info": "Personal Information",
        "theme": {
          "title": "App Theme",
          "current_theme": "Current Theme",
          "system": "System Theme",
          "light": "Light Theme",
          "dark": "Dark Theme"
        },
        "change_lang": {
          "title": "Change Language",
          "Arabic": "Arabic",
          "English": "English",
          "note": "Note: The app will restart to apply the changes."
        },
        "privacy_policy": "Privacy Policy",
        "terms_of_service": "Terms of Service",
        "text_scale": {
          "title": "Writing Size",
          "dummy_messages": {
            "question": "how to change writing size",
            "answer": "change the number from down!"
          }
        },
        "change_theme_color": {
          "title": "change theme color",
          "select_color": "select color",
          "reset": "reset"
        }
      },
      "contact_us": "Contact Us",
      "rate_app": "Rate the App",
      "chat_with_coach": "Chat with captain",
      "chat_with_users": "Chat with users",
      "share_app": "Share the app"
    },
    "payment": {
      "subscription_expired": {
        "title": "subscriptions is out",
        "description":
            "free trial is out , we are happy to help you and become with us just choose your plan",
        "subscribe_again": "subscribe again"
      },
      "subscribed": {
        "title": "you are now in subscription period",
        "cancel_subscription": "cancel subscription",
        "details": {
          "title": "membership details",
          "name": "",
          "price": "",
          "started_at": "start at {date}",
          "end_at": "renewal date {date}"
        }
      },
      "general": {
        "subscriptions": "memberships",
        "remove_ads": "Subscribe to enjoy the app without ads",
        "subscribe_now": "subscribe now",
        "go_to_subscription": "go for subscription",
        "you_have": "you have",
        "in_free_trial": "you are using free trial",
        "of_free_days": "for seven days free trial",
        "after_the_free_period":
            "We are happy for you to complete your journey with us after the free period ends and activate the subscription to use the application again.",
        "enjoy_completely": "Enjoy a completely free trial for a limited time.",
        "titles": {"no_packages_found": "no membership is found"},
        "vip_dialog": {
          "title": "Vip Feature",
          "content":
              "To chat with the captain, Remove Ads and Enjoy coaching features, we are happy to have you with us",
          "subscribe": "Subscribe Now"
        },
        "manage_subscription": "Manage subscription"
      },
      "plans": {
        "promotions": {"27_per_year": "start now for 27 Dollar/year "}
      },
      "free_trial_reminding_dialog": {},
      "free_trail_ended": {
        "title": "free trial is out",
        "content":
            "We are happy to help you and become with us just choose your plan",
        "continue_with_ads": "continue with ads"
      }
    },
    "app_rating": {
      "title": "Rate El Captain App",
      "content": "How was your experience with the app?",
      "comment": "Write your comment",
      "rate": "Rate",
      "later": "Later"
    },
    "showcase": {
      "bottom_nav_bar": {
        "articles":
            "More than 100 articles about exercise, nutrition and fitness",
        "power_exercises": "The strongest set of exercises for each muscle",
        "plans": "More than 50 exercise schedules for various goals and levels",
        "muscles": "Complete video exercise library (700 exercises)",
        "utilities": "Calories and nutrients calculators"
      },
      "drawer": {
        "drawer_icon":
            "To chat with the captain and change the application settings",
        "my_plans":
            "Create your own plan that suits your goals and appointments",
        "contact_capitan": "Chat with the captain and get advice from him"
      }
    }
  };
  static const Map<String, dynamic> ar = {
    "TEST_ONLY": {
      "happy": "سعيد",
      "computer95": "حاسوب95",
      "age": "عمري {}",
      "name": "اسمي {name}"
    },
    "currency": {"SAR": "{} ريال", "EGP": "{} جنية مصري", "USD": "{} دولار"},
    "about": {
      "credits": "عن البرنامج",
      "team": "فريق العمل",
      "back_end": "مطور ويب",
      "front_end": "مطور الواجهة وتطبيق الهاتف",
      "support_front_end": "دعم فني وتطوير تطبيق الهاتف",
      "app_owner": "صاحب فكرة التطبيق",
      "sounds": "الاصوات",
      "thanks_to": "شكراً لـ {}",
      "visit_us": "زرونا"
    },
    "general_titles": {
      "app_title": "الكابتن: لكمال الاجسام",
      "continue": "متابعة",
      "calculate": "احسب",
      "add": "اضف",
      "edit": "تعديل",
      "next": "التالي",
      "upload": "رفع",
      "confirm": "تاكيد",
      "reload": "تحديث",
      "ok": "حسنأ",
      "cancel": "الغاء",
      "close": "اغلق",
      "back": "الرجوع",
      "reset": "اعادة ضبط",
      "media_souce": "مصدر المرفقات",
      "images_library": "مكتبة الوسائط",
      "camera_roll": "الكاميرا",
      "loading": "جار التحميل",
      "show_all": "مشاهدة الكل",
      "chat": {
        "attachments": "المرفقات",
        "image": "ارفق صورة",
        "video": "ارفق فيديو",
        "voice_note": "ارفق ملاحظة صوتية",
        "copied": "تم النسخ للحافظة",
        "send_message": "ارسل اول رسالة...",
        "no_rooms_found": "لا يوجد اي محادثات حديثة",
        "sent_image": " 📷 تم ارسال صورة",
        "sent_voice_note": "🎤 تم ارسال ملف صوتي ",
        "start_chat": "ابدأ بمحادثة الكابتن الان",
        "no_active_chats": "لا يوجد محادثات بعد"
      },
      "g_gender": {"title": "النوع", "male": "ذكر", "female": "انثي"},
      "day_off_rest": "راحة",
      "ranges": {
        "less": "اقل من {num}",
        "from_to": "من {from} الى {to}",
        "or_above": "{num} او اعلى"
      },
      "result": "النتيجة",
      "age": "العمر",
      "category": "الفئة",
      "copy": "نسخ",
      "copied_to_clipboard": "نًسخ للحافظة",
      "options": "الخيارات",
      "optional": "(اختياري)",
      "go_to_settings": "افتح اعدادات الميكروفون",
      "favorite": "المُفضلة",
      "how_we_calculate": "كيف نحسب النتيجة؟",
      "what_are_our_sources": "ما مصادر البيانات؟",
      "where_certes":
          "يمتلك مدربينا اعرق الشهادات للتدريب للحصول علي افضل النتائج للحفاظ علي صحتك"
    },
    "search": {
      "start": "ابحث عن {query} لان",
      "no_results": "عفوأ لم نجد ما تبحث عنه",
      "err_searching": "حدث خطأ اثناء البحث عن {query}"
    },
    "success": {
      "data_update": {
        "personal_info": "تم عمل تحيث لبياناتكم بنجاح",
        "password": "تم تحديث كلمة المرور الخاصة بكم"
      },
      "favorite": {"create": "تم تسجيل الاعجاب", "delete": "تم حذف الاعجاب"},
      "deleted": "تم الحذف بنجاج",
      "created": "تم عمل برنامج جديد بنجاح",
      "email_verified": "تم تأكد البريد الالكتروني بنجاح",
      "code_resent": "تم اعادة ارسال الكود",
      "changed": "تم بنجاح",
      "password_changed_successfuly": "تم تعيين كلمة المرور الخاصة بكم بنجاح",
      "payment_success": "تمت عملية الدفع بنجاح"
    },
    "error": {
      "no_data_avaiable": "لا يوجد محتوي",
      "error_happened": "حدث خطأ ما, من فضلك حاول لاحقاً",
      "error_happened_because":
          "حدث خطأ ما بسبب {cause} ,يمكنك المحاولة لاحقاً",
      "retry": "اعادة المحاولة",
      "enter_valid": "ادخل البيانات المطلوبة صحيحة",
      "login_error":
          "يبدو ان البريد الاكتروني او كلمة المرور الخاصة بكم بهما خطأ",
      "data_update": {
        "personal_info": "فشلت عملية تحديث بياناتكم, من فضلك حاول لاحقاً",
        "password":
            "فشلن عملية تحديث كلمة الرور الخاصة بكم, من فضلك حاول لاحقاً"
      },
      "logout": "حدث خطأ ما اثنائ محاولة تسجيل الخروج",
      "validation": {
        "required_field": "هذه المعلومات مطلوبة",
        "required_image": "من فضلك قم بزويدنا بصورة لك"
      },
      "apple_not_available":
          "تسجيل الدخول عن طريق Apple غير متاح على نظام تشغيلكم الحالي",
      "wrong_code": "الكود المُعطي خطأ",
      "verification": {
        "user_not_verified": "تحتاج الى تفعيل الحساب الخاص بك لاتمام العملية",
        "not_verified_title": "حسابك ليس مفعل",
        "not_verified":
            "يبدو انك لم تقم بتفعيل حسابك حتي الان, لقد ارسلنا على الحساب كود تفعيل قم بادخالة لمعاودة استخدام التطبيق"
      },
      "audio": {"permission": "نحتاج الي اذن الوصول للميكرفون الخاص بكم"}
    },
    "auth": {
      "terms": {
        "accept": "اوافق علي ",
        "use": "استخدام ",
        "and": "و ",
        "use_of_personal_data": "معلوماتي الشخصية المذكورة",
        "info": {
          "why_we_need_info": "نحتاج الى تلك المعلومات",
          "personal_info_explanation":
              "نحتاج الى تلك المعلومات الشخصية لكي يتم عرضها لمختاري الخدمة.",
          "not_for_sale": "تلك المعلومات لا يتم مشاركتها مع اي احد او اي جهة."
        }
      },
      "general": {
        "country": "الدولة",
        "phone": "الهاتف",
        "email": "البريد",
        "name": "الاسم",
        "password": "كلمة المرور",
        "password_confirmation": "تأكيد كلمة المرور",
        "validation": {
          "required_field": "هذه المعلومات مطلوبة",
          "invalid_email": "ادخل بريد الكتروني صحيح",
          "weak_password": "كلمة المرور ضعيفة",
          "password_not_match": "كلمة المرور غير متطابقة",
          "invalid_phone": "رقم الهاتف غير صحيح",
          "invalid_password": "كلمة المرور غير صحيحة"
        },
        "code_verification": {
          "verify_email": "تأكد البريد الالكتروني",
          "check_your_email": "تأكد من وصول كود التفعيل الخاص بكم الي {email}",
          "check_email":
              "تأكد من وصول كود التفعيل الي البريد الالكتروني الخاص بك",
          "spam_wranging":
              "ان لم تجد رسالة من التطبيق تأكد من قسم الرسائل إلكترونية مزعجة Spam"
        }
      },
      "logout": {
        "title": "تسجيل الخروج",
        "are_you_sure": "هل انت متأكد؟",
        "are_you_sure_desc": "هل حقاُ تريد ان تسجل الخروج من التطبيق؟"
      },
      "registation": {
        "title": "تسجيل",
        "accept_terms_of_service": "اوافق على الشروط والاحكام",
        "have_an_account": "لديك حساب بالفعل؟"
      },
      "login": {
        "title": "تسجيل الدخول",
        "forget_password": "نسيت كلمة المرور؟",
        "have_no_account": "انشئ حساب جديد"
      },
      "social": {
        "sing_in_with_apple": "الدخول بحساب Apple",
        "sing_in_with_facebook": "الدخول بحساب Facebook",
        "sing_in_with_google": "الدخول بحساب Goolge"
      },
      "password_recovery": {
        "reset_passwrod": "اعادة تعين كلمة المرور",
        "resend_code": "اعادة ارسال",
        "can_resend_after": "يمكنك اعادة ارسال الرمز بعد {time} دقائق",
        "change_password": "تغير كلمة المرور",
        "new_password": "كلمة المرور الجديدة",
        "new_password_confirmation": "تأكيد كلمة المرور الجديدة",
        "enter_email": "ادخل البريد الخاص بكم لارسال رسالة تأكيد اليه"
      },
      "delete_account": {
        "title": "حذف الحساب",
        "are_you_sure": "هل انت متأكد؟",
        "are_you_sure_desc":
            "هل حقاُ تريد حذف حسابكم؟ لا يمكنك التراجع عن هذا الاجراء",
        "delete": "حذف"
      },
      "guest_user": {
        "needs_login": {
          "title": "سجل الدخول الان مجاناً",
          "description":
              "لكي تستخدم جميع ميزات التطبيق يجب ان تقوم بتسجيل الدخول"
        },
        "needs_payed_login": {
          "title": "تلك الميزة تحتاج ان تكون مُسجل لدينا للاستمتاع بها",
          "description": "سجل الان مجاناً"
        },
        "login_now": "سجل الان",
        "skip": "تخطي"
      }
    },
    "screens": {
      "general": {
        "comments": "التعليقات",
        "comment": "تعليق",
        "likes": "اعجاب",
        "loved_it": "اعجبني",
        "write_a_comment": "شاركنا بتعليق ...",
        "be_first_commenter": "كن اول من يشاركنا بتعليق على المقال",
        "duration": "المدة",
        "duration_weeks": "{num} اسابيع",
        "duration_months": "{num} شهور",
        "exercise_r": {
          "steps_and_reps": "المجموعات والتكرار",
          "exercise": "تمرين",
          "exercise_num": "{num} تمرين",
          "exercise_name": "اسم التمرين",
          "sets": "عدد المجموعات",
          "repeats": "عدد التكرار",
          "rest": "وقت الراحة",
          "rest_time": "{time} ثانية",
          "exer_plan": "نظام التمرين",
          "sets_num": "مجموعات: {num}",
          "repeats_num": "تكرار: {num} مرات",
          "rest_duration": "وقت الراحة: {time} ثانية",
          "plan": "نظام التمرين: {plan}",
          "exercise_type": "نوع التمرين",
          "exercise_with_num": "تمرين رقم #{num}",
          "exercises": "التمارين"
        },
        "body_part": "الجزء المرجو",
        "description": "الوصف",
        "steps": "الخطوات",
        "week": "اسبوع",
        "week_num": " اسبوع {num}",
        "week_days": {
          "Monday": "الاثنين",
          "Tuesday": "الثلاثاء",
          "Wednesday": "الاربعاء",
          "Thursday": "الخميس",
          "Friday": "الجمعة",
          "Saturday": "السبت",
          "Sunday": "الاحد"
        },
        "free_day": "راحة",
        "exercises": "تمارين",
        "exercises_num": "{num} تمارين",
        "speed": "تمارين",
        "commenting": {"delete_comment": "حذف التعليق"}
      },
      "articles": {"title": "المقالات", "search": "ابحث عن مقالاتك المفضلة..."},
      "power_training": {"title": "اقوي التمارين"},
      "all_muscles": {
        "title": "جميع العضلات",
        "primary_muscle": "العضلة الاساسية",
        "secondary_muscle": "العضلة المساعدة",
        "body_part": "جزء الجسم",
        "description": "الوصف",
        "steps": "الخطوات"
      },
      "utilities": {
        "title": "الادوات",
        "general": {
          "goal": "الهدف",
          "height": "الطول",
          "weight": "الوزن",
          "units": {
            "m": "متر",
            "km": "كم",
            "cm": "سم",
            "g": "جم",
            "kg": "كجم",
            "m_num": "{num} متر",
            "km_num": "{num} كم",
            "cm_num": "{num} سم",
            "g_num": "{num} جم",
            "calory_num": "{num} سعر حراري",
            "kg_num": "{num} كجم"
          }
        },
        "calculators": {
          "BMI_calc": {
            "title": "حاسبة مؤشر كتله الجسم BMI",
            "result": {
              "your_score": "النتيجة",
              "range": "المدي",
              "BMI_table": "جدول مؤشر كتله الجسم",
              "category": {
                "title": "الفئة",
                "sev_under": "نحيف للغاية",
                "under": "نحيف",
                "normal": "طبيعي",
                "over": "وزن زائد",
                "extreme": "سمنة مفرطة"
              }
            }
          },
          "protine_calc": {
            "title": "حاسبة البروتين",
            "fitness_level": {
              "title": "مستوي اللياقة",
              "no_exercise": "لا تتمرن",
              "low_level": {
                "title": "تمرين عادي",
                "sub_title": "المشي والجري وحصص لياقة ساعتين بالاسبوع"
              },
              "active_level": {
                "title": "تمرين نشيط",
                "sub_title":
                    "الجري , ركوب الدراجة او السباحة لاقل من ٥ ساعات اسبوعياً"
              },
              "sports": {
                "title": "رياضي",
                "sub_title":
                    "لعب كرة القدم او اي رياضة قوية لاقل من ٥ ساعات اسبوعياً"
              },
              "weight_training": {
                "title": "حمل الاثقال",
                "sub_title": "تتمرن لزيادة كتلتك العضلية"
              }
            },
            "result": {"required_protein": "البروتين المطلوب"}
          },
          "calories_calc": {
            "title": "حاسبة السعرات الحرارية",
            "dcn": "السعرات",
            "calory_num": "{num} سعر حراري",
            "calory": "سعر حراري",
            "activity": {
              "title": "النشاط",
              "select": "اختر النشاط",
              "basic_metabolism": "الإحتياج الغذائي الاساسي",
              "sendentary": "مجهود بسيط : فقط نشاط حركي بالعمل",
              "light": "تمرين منخفض الشدة : بمعدل تمرين 1-3 ايام بالاسبوع",
              "modrate": "تمرين متوسط الشدة : بمعدل تمرين 3-5 ايام بالاسبوع",
              "very_active": "تمرين عالي الشدة : بمعدل تمرين 6-7 ايام بالاسبوع",
              "extra_active":
                  "مستوى تمرين المحترفين: بمعدل تمرين 6-7 ايام بالاسبوع بمستوى تمرين عالي الشدة"
            },
            "result": {
              "title": "النتائج",
              "calo_loss_per_day":
                  "السعرات الحرارية المطلوبة لخسارة {num} كجم بالاسبوع",
              "calo_gain_per_day":
                  "السعرات الحرارية المطلوبة لكسب {num} كجم بالاسبوع",
              "cal_to_mentain":
                  "السعرات الحرارة المطلوبة للحفاظ على وزنك (بدون تمرين)"
            }
          },
          "fat_calc": {
            "title": "حاسبة الدهون",
            "results": {
              "body_fat_persentage": "نسبة الدهون",
              "fat_mass": "كتلة الدهون",
              "lean_mass": "الكتلة الفعلية",
              "table": {
                "under": "دهون قليلة",
                "healthy": "صحي",
                "over": "وزن زائد",
                "obese": "سمنة مفرطة",
                "essential_fat": "دهون اساسية",
                "atheletes": "رياضي",
                "fitness": "رشيق",
                "average": "متوسط"
              }
            }
          },
          "carbs_calc": {"title": "حاسبة الكربوهيدرات"}
        }
      },
      "plans": {
        "title": "برامج التمرين",
        "my_plans": "خاص بي",
        "goal": "الهدف",
        "requirment": "المتطلبات",
        "target_group": "فئة التمرين",
        "custom_plans": {
          "title": "برامج التدريب خاصتي",
          "create_new": "اضف برنامج جديد",
          "add_work_out": "اضف تمرين",
          "details": "التفاصيل",
          "select_muscle": "اختر العضلة",
          "select_exercise": "اختر التمرين",
          "plan": {"name": "الاسم"},
          "new_week": {
            "title": "اضف اسبوع للبرنامج",
            "content": "يمكنك اضافة اسبوع جديد للبرنامج الخاص بك من هنا"
          },
          "reps_description":
              "يمكنك ادخال التكرار بشكل منفصل تعبيرا عن الsuperset (10-10 ) او ال pyramid set (12-10-8 )",
          "exercise_type": "نوع التمرين",
          "select_exercise_type": "اختر نوع التمرين",
          "enter_valid_exercises": "ادخل تمارين صحيحة",
          "exercises_description":
              "هذه التمارين التي سوف تلعب كجزء من هذا التمرين",
          "for_more_details":
              "لمعرفة انواع برامج التمارين ادخل قائمة المقالات قسم ( اساسيات التمرين )"
        }
      }
    },
    "drawer": {
      "settings": {
        "title": "الاعدادات",
        "personal_info": "المعلومات الشخصية",
        "theme": {
          "title": "مظهر التطبيق",
          "current_theme": "المظهر الحالي",
          "system": "مظهر النظام",
          "light": "المظهر الساطع",
          "dark": "المظهر الداكن"
        },
        "change_lang": {
          "title": "تغير اللغة",
          "Arabic": "العربية",
          "English": "الانجليزية",
          "note": "يجب اعادة تشغيل التطبيق لتطبيق التغيرات"
        },
        "privacy_policy": "سياسة الخصوصية",
        "terms_of_service": "الشروط والاحكام",
        "text_scale": {
          "title": "حجم الخط",
          "dummy_messages": {
            "question": "كيف يمكنني تغير حجم الخط؟",
            "answer": "حاول ان تغير قيمة الاختيار من اسفل!"
          }
        },
        "change_theme_color": {
          "title": "تغير لون التطبيق",
          "select_color": "اختر اللون",
          "reset": "اعادة للافتراضي"
        }
      },
      "contact_us": "تواصل معنا",
      "rate_app": "تقيم التطبيق",
      "chat_with_coach": "تواصل مع الكابتن",
      "chat_with_users": "تواصل مع المستخدمين",
      "share_app": "مشاركة"
    },
    "payment": {
      "subscription_expired": {
        "title": "انتهت فترة الاشتراك",
        "description":
            "لقد انتهت الفترة التجريبية يسعدنا ان تكون عضو مع فريق تطبيق الكابتن و نكون في مساعدتك في تحقيق هدفك",
        "subscribe_again": "اشترك من جديد"
      },
      "subscribed": {
        "title": "انت الان مشترك في الخطة المدفوعة",
        "cancel_subscription": "الغي الاشتراك",
        "details": {
          "title": "معلومات عن الاشتراك",
          "name": "",
          "price": "",
          "started_at": "بدأ في {date}",
          "end_at": "تاريخ التجديد {date}"
        }
      },
      "general": {
        "subscriptions": "الإشتراكات",
        "remove_ads": "اشترك للتمت علي كل ميزات التطبيق",
        "subscribe_now": "اشترك الان",
        "go_to_subscription": "اذهب للاشتراك",
        "you_have": "لديك",
        "in_free_trial": "انت الان في فترة التجربة المجانية",
        "of_free_days": "من الـ 7 ايام المجانية",
        "after_the_free_period":
            "يسعدنا أن تكمل رحلتك معنا بعد انتهاء الفترة المجانية وتقوم بتفعيل الاشتراك لاستخدام التطبيق مرة اخرى",
        "enjoy_completely": "استمتع بتجربة مجانية كاملة لفترة محدودة",
        "titles": {"no_packages_found": "لا يوجد خطط للاشتراكات"},
        "vip_dialog": {
          "title": "ميزة VIP",
          "content":
              "للتواصل مع الكابتن, ازالة الاعلانات و استخدام خدمة المتابعة يسعدنا ان تكون من متابعين الكابتن",
          "subscribe": "اشترك الان"
        },
        "manage_subscription": "ادارة الاشتراك"
      },
      "plans": {
        "promotions": {
          "27_per_year": "ابدأ بالاشتراك الان ابتدأً من 27 دولار/السنة"
        }
      },
      "free_trial_reminding_dialog": {},
      "free_trail_ended": {
        "title": "انتهت الخطة المجانية",
        "content":
            "لقد انتهت الفترة التجريبية يسعدنا ان تكون عضو مع فريق تطبيق الكابتن و نكون في مساعدتك في تحقيق هدفك",
        "continue_with_ads": "استمر بالاستخدام مع الاعلانات"
      }
    },
    "app_rating": {
      "title": "قيم تطبيق الكابتن",
      "content": "كيف كانت تجربتك مع التطبيق؟ قيم التطبيق و اخبرنا برأيك",
      "comment": "اكتب تعليقك",
      "rate": "قيم",
      "later": "لاحقاً"
    },
    "showcase": {
      "bottom_nav_bar": {
        "articles": "اكثر من 100 مقالة عن التمرين \nو التغذية و الفيتنس",
        "power_exercises": "اقوى مجموعة تمارين لكل عضلة",
        "plans": "اكثر من 50 جدول تمارين \nمتنوع الاهداف و المستويات",
        "muscles": "مكتبة تمارين كاملة \nبالفيديو (700 تمرين)",
        "utilities": "حاسبة السعرات \nو العناصر الغذائية"
      },
      "drawer": {
        "drawer_icon": "للتواصل مع الكابتن \nو تغيير اعدادات التطبيق",
        "my_plans": "اصنع جدولك الخاص \nالمناسب لهدفك و مواعيدك",
        "contact_capitan": "للتواصل مع الكابتن"
      }
    }
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "ar": ar
  };
}
