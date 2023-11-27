import 'dart:math';

import 'package:face_commute/module/module.dart';
import 'package:face_commute/ui/main/dialog/main_dialog_controller.dart';
import 'package:face_commute/ui/main/dialog/main_dialog_cubit.dart';
import 'package:face_commute/ui/main/dialog/main_dialog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension on BuildContext {
  MainDialogController get controller => MainDialogController(this);
}

final class MainDialog extends StatelessWidget {
  const MainDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints.expand(height: max(MediaQuery.of(context).size.height / 3, 200)),
        child: Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: UI.radius),
            ),
            child: BlocBuilder<MainDialogCubit, MainDialogState>(
              builder: (context, state) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Paddings.height8,
                  Row(
                    children: [
                      Paddings.width8,
                      const Opacity(
                        opacity: 0,
                        child: IgnorePointer(
                          child: CloseButton(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '(${Day.values[state.program.dateTime.weekday].value}) ${state.program.title}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Resource.colors[state.program.title],
                                fontWeight: FontWeight.w500,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const CloseButton(),
                      Paddings.width8,
                    ],
                  ),
                  Paddings.height8,
                  Padding(
                    padding: Paddings.paddingHorizontal16,
                    child: Text(
                      '일시: ${state.program.dateTime.dateAndTime}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black87,
                          ),
                    ),
                  ),
                  Paddings.height8,
                  Padding(
                    padding: Paddings.paddingHorizontal16,
                    child: Text(
                      '장소: ${state.program.place}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black87,
                          ),
                    ),
                  ),
                  Paddings.height8,
                  Padding(
                    padding: Paddings.paddingHorizontal16,
                    child: Text(
                      '과목코드: ${state.program.code}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.black87,
                          ),
                    ),
                  ),
                  UI.spacer,
                  if (!state.isActive)
                    Padding(
                      padding: Paddings.paddingHorizontal16,
                      child: Center(
                        child: Text(
                          '수업이 진행되는 ${!state.isTime ? '시간' : '강의실'}이 아닙니다.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Resource.colorFB2330,
                              ),
                        ),
                      ),
                    ),
                  FilledButtonTheme(
                    data: FilledButtonThemeData(
                      style: FilledButton.styleFrom(
                        backgroundColor: Resource.colors[state.program.title],
                        shape: const RoundedRectangleBorder(),
                        padding: Paddings.paddingVertical16,
                      ).merge(Theme.of(context).filledButtonTheme.style),
                    ),
                    child: FilledButton(
                      onPressed: state.isActive ? context.controller.onPressed : null,
                      child: Text(
                        '출석',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                  Paddings.height8,
                ],
              ),
            ),
          ),
        ),
      );
}
