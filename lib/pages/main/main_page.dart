import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di/register_dependencies.dart';
import '../../features/authentication/state/device_sign_in_state.dart';
import '../../features/authentication/ui/wait_authentication_wrapper.dart';
import 'state/main_page_state.dart';
import 'ui/main_navigation_bar.dart';
import 'ui/page_content.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<DeviceSignInCubit>(),
          lazy: false,
        ),
        BlocProvider(create: (_) => getIt<MainPageCubit>()),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: MainNavigationBar(),
      body: SafeArea(
        child: WaitAuthenticationWrapper(
          child: PageContent(),
        ),
      ),
    );
  }
}
