import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'package:the_coach/Modules/CustomPlans/custom_plans_module.dart';

class AddCustomPlanScreen extends StatefulWidget {
  const AddCustomPlanScreen({Key? key}) : super(key: key);

  @override
  _AddCustomPlanScreenState createState() => _AddCustomPlanScreenState();
}

class _AddCustomPlanScreenState extends State<AddCustomPlanScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleTextController;
  late final TextEditingController _descTextController;

  @override
  void initState() {
    _formKey = GlobalKey();
    _titleTextController = TextEditingController();
    _descTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descTextController.dispose();
    super.dispose();
  }

  void _createNewPlan() {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleTextController.text.trim();
    final description = _descTextController.text.trim();
    final newPlan = NewPlan(title: title, description: description);
    context.read<CustomPlansCubit>().createPlan(plan: newPlan);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomPlansCubit, CustomPlansState>(
      listener: (context, state) {
        if (state.isCreated) {
          Navigator.pop(context);
        }
      },
      child: KeyboardDismissed(
        child: Scaffold(
          appBar: CAppBar(
              header: LocaleKeys.screens_plans_custom_plans_create_new.tr()),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: BlocBuilder<CustomPlansCubit, CustomPlansState>(
            builder: (context, state) {
              return CustomButton(
                onPressed: _createNewPlan,
                isLoading: state.isGeneralLoading,
                visualDensity: VisualDensity.comfortable,
                child: Text(
                  LocaleKeys.general_titles_add.tr(),
                  style: theme(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: CColors.fancyBlack),
                ),
              );
            },
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: KEdgeInsets.h10,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CTextField(
                            keyboardType: TextInputType.text,
                            controller: _titleTextController,
                            isRequired: true,
                            title: LocaleKeys
                                .screens_plans_custom_plans_plan_name
                                .tr(),
                          ),
                          Space.v5(),
                          TextFormField(
                            controller: _descTextController,
                            // keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText:
                                  LocaleKeys.screens_general_description.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LocaleKeys
                                    .error_validation_required_field
                                    .tr();
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
