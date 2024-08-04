import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../features/profile/application/bloc/profile_bloc.dart';
import '../../../utils/app_extension_method.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Helper {
  
  late TextEditingController emailTextController;
  late TextEditingController nameTextController;
  late TextEditingController phoneTextController;
  late TextEditingController addressTextController;
  late TextEditingController userIdTextController;
  AppLocalizations? _localizations;
  
  bool showProfileId = false;
  String imageUrl = '';
  String errorUserId = '';
  String errorEmail = '';
  String errorName = '';
  String errorPhone = '';
  String errorAddress = '';
  bool isFetchProfileData = false;

  //US Phone Number Format
  var maskFormatter = MaskTextInputFormatter(
    mask: '####-###-###',
    filter: {"#": RegExp(r'[0-9]')}
  );

  @override
  void initState() {
    emailTextController = TextEditingController();
    nameTextController = TextEditingController();
    phoneTextController = TextEditingController();
    addressTextController = TextEditingController();
    userIdTextController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        builder: (context, state){
          switch (state.runtimeType) {
            case ProfileShowIdState:
              state = state as ProfileShowIdState;
              showProfileId = state.isIdVisible;
              break;
            case ProfileErrorIdState:
              state = state as ProfileErrorIdState;
              errorUserId = state.message;
              break;
            case ProfileErrorEmailState:
              state = state as ProfileErrorEmailState;
              errorEmail = state.message;
              break;
            case ProfileErrorNameState:
              state = state as ProfileErrorNameState;
              errorName = state.message;
              break;
            case ProfileErrorPhoneState:
              state = state as ProfileErrorPhoneState;
              errorPhone = state.message;
              break;
            case ProfileErrorAddressState:
              state = state as ProfileErrorAddressState;
              errorAddress = state.message;
              break;
            case ProfileChooseImageState:
              state = state as ProfileChooseImageState;
              imageUrl = state.imagePath.isEmpty ? AppStrings.sampleImg : state.imagePath;
              break;
            case ProfileSuccessState:
              ///hideLoadingDialog(context: context);
              state = state as ProfileSuccessState;
              var profileData = state.profileData;
              userIdTextController.text = profileData['user_id'] ?? '';
              emailTextController.text = profileData['email'] ?? '';
              nameTextController.text = profileData['name'] ?? '';
              phoneTextController.text = maskFormatter.maskText(profileData['phone'] ?? '');
              addressTextController.text = profileData['address'] ?? '';
              imageUrl = profileData['profile_img'] ?? AppStrings.sampleImg;
              Preferences.setString(key: AppStrings.prefProfileImg, value: imageUrl);
              break;
            default:
          }
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(AppSize.s20),
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSize.s2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryColor, width: AppSize.s2)
                    ),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(AppSize.s50), // Image radius
                        child: imageUrl.isEmpty
                        ? const Center(child: Icon(AppIcons.personIcon, size: AppSize.s60))
                        : imageUrl.isNetworkImage
                          ? Image.network(
                             imageUrl,
                             loadingBuilder: (context, child, loading){
                              if(loading == null){
                                return child;
                              } else {
                                return const Center(child: CircularProgressIndicator(strokeWidth: AppSize.s2));
                              }
                             }, 
                             fit: BoxFit.cover
                            )
                          : Image.file(File(imageUrl), fit: BoxFit.cover)
                      ),
                    )
                  ),
                  Positioned(
                    bottom: 15,
                    right: context.screenWidth / 2 - 80,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSize.s30),
                      onTap: () => showImagePickerSheet(context),
                      child: Container(
                        padding: const EdgeInsets.all(AppSize.s6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Helper.isDark ? AppColors.backgroundColorDark : AppColors.white,
                          boxShadow: const [BoxShadow(color: AppColors.grey, blurRadius: AppSize.s1)]
                        ),
                        child: const Icon(Icons.edit, size: AppSize.s18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.s15),
              CustomTextField(
                title: _localizations!.userId, 
                isPasswordField: !showProfileId, 
                textEditingController: userIdTextController,
                readOnly: true,
                isMandatory: true,
                onShowPassword: () => context.read<ProfileBloc>().add(ProfileShowIdEvent()),
                errorText: errorUserId,
              ),
              CustomTextField(
                title: _localizations!.email, 
                isPasswordField: false, 
                isEnabled: false,
                isMandatory: true,
                textEditingController: emailTextController,
                errorText: errorEmail,
              ),
              CustomTextField(
                title: _localizations!.name, 
                isPasswordField: false, 
                isMandatory: true,
                textEditingController: nameTextController,
                errorText: errorName,
                onChange: (value) => context.read<ProfileBloc>().add(ProfileNameChangeEvent(text: value)),
              ),
              CustomTextField(
                title: _localizations!.phone, 
                isPasswordField: false, 
                textEditingController: phoneTextController,
                errorText: errorPhone,
                maxLength: 12,
                textInputFormatter: [maskFormatter],
                onChange: (value) => context.read<ProfileBloc>().add(ProfilePhoneChangeEvent(text: maskFormatter.unmaskText(value))),
              ),
              CustomTextField(
                title: _localizations!.address, 
                isPasswordField: false, 
                textEditingController: addressTextController,
                errorText: errorAddress
              ),
              const SizedBox(height: AppSize.s8),
              CustomButton(
                title: _localizations!.update, 
                onTap: () => context.read<ProfileBloc>().add(ProfileUpdateEvent(profileData: {
                  'user_id': userIdTextController.text,
                  'email': emailTextController.text,
                  'name': nameTextController.text,
                  'phone':  maskFormatter.unmaskText(phoneTextController.text),
                  'address': addressTextController.text,
                  'profile_img': imageUrl
                }))
              ),
            ],
          );
        },
        listener: (context, state){
          switch (state.runtimeType) {
            case ProfileLoadingState:
              showLoadingDialog(context: context);
              break;
            case ProfileSuccessState:
              hideLoadingDialog(context: context);
              if(isFetchProfileData) {
                showSnackBar(context: context, title: _localizations!.profileUpdateMsg, color: AppColors.green);
              } else {
                isFetchProfileData = true;
              }
              break;
            default:
          }
        }
      )
    );
  }

  void showImagePickerSheet(BuildContext mContext) {
    showModalBottomSheet(
      context: mContext, 
      builder: (_) {
        return Container(
          width: context.screenWidth,
          color: Helper.isDark
          ? AppColors.backgroundColorDark
          : AppColors.white,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(AppSize.s20),
            children: [
              CustomText(
                title: _localizations!.selectImg, 
                textStyle: getMediumStyle(
                  color: Helper.isDark
                  ? AppColors.white.withOpacity(0.8)
                  : AppColors.black, 
                  fontSize: AppSize.s16
                ),
              ),
              const SizedBox(height: AppSize.s20),
              Row(
                children: [
                  const SizedBox(width: AppSize.s10),
                  InkWell(
                    onTap: () async {
                      context.pop();
                      var data = await pickImage(imageSource: ImageSource.camera);
                      if(data.isNotEmpty && context.mounted){
                        mContext.read<ProfileBloc>().add(ProfileChooseImageEvent(imagePath: data));
                      }
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: AppSize.s26,
                          child: Icon(
                            Icons.camera, 
                            size: AppSize.s28, 
                            color: Helper.isDark
                            ? AppColors.white.withOpacity(0.8)
                            : AppColors.primaryColor
                          ),
                        ),
                        const SizedBox(height: AppSize.s4),
                        CustomText(
                          title: _localizations!.camera, 
                          textColor: Helper.isDark
                          ? AppColors.white.withOpacity(0.8)
                          : AppColors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSize.s30),
                  InkWell(
                    onTap: () async {
                      context.pop();
                      String data = await pickImage(imageSource: ImageSource.gallery);
                      if(data.isNotEmpty && context.mounted){
                        mContext.read<ProfileBloc>().add(ProfileChooseImageEvent(imagePath: data));
                      }
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: AppSize.s26,
                          child: Icon(
                            Icons.photo, 
                            size: AppSize.s28, 
                            color: Helper.isDark
                            ? AppColors.white.withOpacity(0.8)
                            : AppColors.primaryColor
                          ),
                        ),
                        const SizedBox(height: AppSize.s4),
                        CustomText(
                          title: _localizations!.gallery, 
                          textColor: Helper.isDark
                          ? AppColors.white.withOpacity(0.8)
                          : AppColors.black,  
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  Future<String> pickImage({required ImageSource imageSource}) async {
    try {
      var pickImage = await ImagePicker().pickImage(source: imageSource);
      if(pickImage != null){
        return pickImage.path;
      } else {
        return AppStrings.emptyString;
      }
    } catch (e) {
      return AppStrings.emptyString;
    }
  }

}