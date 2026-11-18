// import 'package:futurex_erp/modules/kashier/presentation/cubit/modifier/modifiers_cubit.dart';
// import 'package:futurex_erp/modules/kashier/presentation/cubit/sort/sort_product_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> initDataConfiguration() async {}
List<BlocProvider<dynamic>> initProviders() {
  return [
    /// with get_it
    // BlocProvider<SplashCubit>(create: (context) => locator<SplashCubit>()),
    // BlocProvider<AuthCubit>(create: (context) => locator<AuthCubit>()),
    // BlocProvider<SortProductCubit>(
    //   create: (context) => locator<SortProductCubit>(),
    // ),
    // BlocProvider<ModifiersCubit>(
    //   create: (context) => locator<ModifiersCubit>(),
    // ),
    // BlocProvider<PinCodeCubit>(create: (context) => locator<PinCodeCubit>()),
    // // new
    // BlocProvider<AttendanceCubit>(
    //   create: (context) => locator<AttendanceCubit>(),
    // ),

    /// with out get_it
    // BlocProvider<SplashCubit>(create: (context) => SplashCubit(),),
    // BlocProvider<UserCubit>(create: (context) => UserCubit(authRepository)),
  ];
}
