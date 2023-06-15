import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../../batch/domain/entity/batch_entity.dart';
import '../../../batch/presentation/viewmodel/batch_view_model.dart';
import '../../../course/domain/entity/course_entity.dart';
import '../../../course/presentation/viewmodel/course_viewmodel.dart';
import '../../domain/entity/student_entity.dart';
import '../viewmodel/auth_view_model.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  BatchEntity? _dropDownValue;
  final List<CourseEntity> _lstCourseSelected = [];

  final _gap = const SizedBox(height: 8);

  final _key = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    final batchState = ref.watch(batchViewModelProvider);
    final courseState = ref.watch(courseViewModelProvider);
    final authState = ref.watch(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: _fnameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    }),
                  ),
                  _gap,
                  TextFormField(
                    controller: _lnameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    }),
                  ),
                  _gap,
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone No',
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phoneNo';
                      }
                      return null;
                    }),
                  ),
                  _gap,
                  if (batchState.isLoading) ...{
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  } else if (batchState.error != null) ...{
                    Center(
                      child: Text(batchState.error!),
                    )
                  } else ...{
                    DropdownButtonFormField(
                      items: batchState.batches
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.batchName),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _dropDownValue = value;
                      },
                      value: _dropDownValue,
                      decoration: const InputDecoration(
                        labelText: 'Select Batch',
                      ),
                      validator: ((value) {
                        if (value == null) {
                          return 'Please select batch';
                        }
                        return null;
                      }),
                    ),
                  },
                  _gap,
                  if (courseState.isLoading) ...{
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  } else if (courseState.error != null) ...{
                    Center(
                      child: Text(courseState.error!),
                    )
                  } else ...{
                    MultiSelectDialogField(
                      title: const Text('Select course'),
                      items: courseState.courses
                          .map((course) => MultiSelectItem(
                                course,
                                course.courseName,
                              ))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      buttonText: const Text('Select course'),
                      buttonIcon: const Icon(Icons.search),
                      onConfirm: (values) {
                        _lstCourseSelected.clear();
                        _lstCourseSelected.addAll(values);
                      },
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select courses';
                        }
                        return null;
                      }),
                    ),
                  },
                  _gap,
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    }),
                  ),
                  _gap,
                  TextFormField(
                    controller: _passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                    ),
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    }),
                  ),
                  _gap,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          var student = StudentEntity(
                            fname: _fnameController.text,
                            lname: _lnameController.text,
                            phone: _phoneController.text,
                            username: _usernameController.text,
                            password: _passwordController.text,
                            batch: _dropDownValue,
                            courses: _lstCourseSelected,
                          );

                          ref
                              .read(authViewModelProvider.notifier)
                              .registerStudent(student);

                          if (authState.error != null) {
                            showSnackBar(
                              message: authState.error.toString(),
                              context: context,
                              color: Colors.red,
                            );
                          } else {
                            showSnackBar(
                              message: 'Registered successfully',
                              context: context,
                            );
                          }
                        }
                      },
                      child: const Text('Register'),
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
