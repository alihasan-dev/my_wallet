import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:my_wallet/constants/app_theme.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../constants/app_color.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_size.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_style.dart';
import '../../../features/profile/application/bloc/profile_bloc.dart';
import '../../../features/profile/application/bloc/profile_event.dart';
import '../../../features/profile/application/bloc/profile_state.dart';
import '../../../utils/app_extension_method.dart';
import '../../../utils/helper.dart';
import '../../../widgets/custom_outlined_button.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../utils/preferences.dart';
import '../../../widgets/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final Widget? closeButton;

  const ProfileScreen({
    super.key, 
    this.userId = '',
    this.closeButton  
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
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
      create: (_) => ProfileBloc(userId: widget.userId),
      child: Builder(
        builder: (context) {
          return BlocConsumer<ProfileBloc, ProfileState>(
            listenWhen: (previous, current) {
              if(previous is ProfileSuccessState && current is ProfileSuccessState) {
                return compareProfileMap(previous.profileData, current.profileData);
              }
              return true;
            },
            builder: (context, state) {
              return widget.userId.isEmpty
              ? mainWidget(bContext: context)
              : Scaffold(
                appBar: AppBar(
                  centerTitle: true, 
                  leading: widget.closeButton ?? const Center(child: BackButton()),
                  backgroundColor: AppColors.primaryColor,
                  title: CustomText(
                    title: _localizations!.profile, 
                    textStyle: getBoldStyle(color: AppColors.white)
                  ),
                  iconTheme: const IconThemeData(color: AppColors.white),
                ),
                body: mainWidget(bContext: context),
              );
            },
            listener: (context, state) {
              switch (state) {
                case ProfileShowIdState _:
                  showProfileId = state.isIdVisible;
                  break;
                case ProfileErrorIdState _:
                  errorUserId = state.message;
                  break;
                case ProfileErrorEmailState _:
                  errorEmail = state.message;
                  break;
                case ProfileErrorNameState _:
                  errorName = state.message;
                  break;
                case ProfileErrorPhoneState _:
                  errorPhone = state.message;
                  break;
                case ProfileErrorAddressState _:
                  errorAddress = state.message;
                  break;
                case ProfileChooseImageState _:
                  imageUrl = state.imagePath.isEmpty ? AppStrings.sampleImg : state.imagePath;
                  break;
                case ProfileSuccessState _:
                  var profileData = state.profileData;
                  userIdTextController.text = profileData['user_id'] ?? '';
                  emailTextController.text = profileData['email'] ?? '';
                  nameTextController.text = profileData['name'] ?? '';
                  phoneTextController.text = maskFormatter.maskText(profileData['phone'] ?? '');
                  addressTextController.text = profileData['address'] ?? '';
                  imageUrl = profileData['profile_img'] ?? AppStrings.sampleImg;
                  Preferences.setString(key: AppStrings.prefProfileImg, value: imageUrl);
                  hideLoadingDialog(context: context);
                  if(isFetchProfileData) {
                    showSnackBar(context: context, title: _localizations!.profileUpdateMsg, color: AppColors.green);
                  } else {
                    isFetchProfileData = true;
                  }
                  break;
                case ProfileLoadingState _:
                  showLoadingDialog(context: context);
                  break;
                case ProfileDeleteUserState _:
                  if(state.isDeleted) {
                    hideLoadingDialog(context: context);
                    context.pop();
                    context.pop();
                    showSnackBar(context: context, title: AppStrings.success, message: AppStrings.userDeletedMsg, color: AppColors.green);
                  } else {
                    onUserDelete(nameTextController.text, context);
                  }
                  break;
                default:
              }
            }
          );
        }
      ),
    );
  }

  Future<void> onUserDelete(String name, BuildContext bContext) async {
    if(await confirmationDialog(context: context, title: _localizations!.deleteUser, content: "${_localizations!.deleteUserMsg} $name", localizations: _localizations!)) {
      bContext.read<ProfileBloc>().add(ProfileDeleteUserEvent(isConfirmed: true));
    }
  }

  Widget mainWidget({required BuildContext bContext}) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppSize.s20),
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Hero(
              tag: 'profile',
              child: CustomImageWidget(
                imageUrl: imageUrl,
                imageSize: AppSize.s45,
              ),
            ),
            Positioned(
              bottom: 8,
              right: (MyAppTheme.columnWidth / 2) - 75,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSize.s30),
                // onTap: () => showModalBottomSheet(context: bContext, builder: (context) => Text('sdf')),
                onTap: () => showImagePickerSheet(bContext),
                child: Container(
                  padding: const EdgeInsets.all(AppSize.s8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                    boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: AppSize.s1)]
                  ),
                  child: const Icon(Icons.edit, size: AppSize.s16, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.s12),
        CustomTextField(
          title: _localizations!.userId, 
          isPasswordField: !showProfileId, 
          textEditingController: userIdTextController,
          readOnly: true,
          isMandatory: true,
          onShowPassword: () => bContext.read<ProfileBloc>().add(ProfileShowIdEvent()),
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
          onChange: (value) => bContext.read<ProfileBloc>().add(ProfileNameChangeEvent(text: value)),
        ),
        CustomTextField(
          title: _localizations!.phone, 
          isPasswordField: false, 
          textEditingController: phoneTextController,
          errorText: errorPhone,
          maxLength: 12,
          textInputFormatter: [maskFormatter],
          onChange: (value) => bContext.read<ProfileBloc>().add(ProfilePhoneChangeEvent(text: maskFormatter.unmaskText(value))),
        ),
        CustomTextField(
          title: _localizations!.address, 
          isPasswordField: false, 
          textEditingController: addressTextController,
          errorText: errorAddress
        ),
        const SizedBox(height: AppSize.s4),
        Row(
          children: [
            Visibility(
              visible: !widget.userId.isBlank,
              child: Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        onPressed: () => bContext.read<ProfileBloc>().add(ProfileDeleteUserEvent()),
                        title: _localizations!.deleteUser, 
                        icon: AppIcons.deleteIcon,
                        isSelected: true,
                        foregroundColor: AppColors.red,
                        backgroundColor: AppColors.red.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(width: AppSize.s8),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomTextButton(
                onPressed: () => bContext.read<ProfileBloc>().add(ProfileUpdateEvent(profileData: {
                  'user_id': userIdTextController.text,
                  'email': emailTextController.text,
                  'name': nameTextController.text,
                  'phone':  maskFormatter.unmaskText(phoneTextController.text),
                  'address': addressTextController.text,
                  'profile_img': imageUrl
                })),
                title: _localizations!.update,
                isSelected: true,
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.primaryColor,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ],
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
              const SizedBox(height: AppSize.s18),
              Row(
                children: [
                  const SizedBox(width: AppSize.s10),
                  InkWell(
                    onTap: () async {
                      context.pop();
                      var data = await pickImage(imageSource: ImageSource.camera, context: context);
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
                      var data = await pickImage(imageSource: ImageSource.gallery, context: context);
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
              const SizedBox(height: AppSize.s10),
              Container(
                padding: const EdgeInsets.all(AppSize.s5),
                decoration: BoxDecoration(
                  color: AppColors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSize.s4)
                ),
                child: Row(
                  children: [
                    const Icon(
                      AppIcons.warningIcon, 
                      color: AppColors.amber, 
                      size: AppSize.s20
                    ),
                    const SizedBox(width: AppSize.s5),
                    CustomText(
                      title: _localizations!.imageSizeMsg, 
                      textColor: AppColors.amber
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}