import 'package:common_widgets/common_widgets.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../shared/util/assemble_media_url.dart';
import '../state/math_battle_state.dart';

class MatchMathProblemImage extends StatelessWidget {
  const MatchMathProblemImage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MathBattleCubit, MathBattleState>(
      buildWhen: (previous, current) => previous.currentMathProblem != current.currentMathProblem,
      builder: (_, state) {
        if (state.currentMathProblem == null) {
          return const SizedBox.shrink();
        }

        final images = state.currentMathProblem!.images;
        if (images == null || images.isEmpty) {
          return const SizedBox.shrink();
        }

        final imagesWidget = switch (images.length) {
          1 => _image(theme, images.first),
          2 => Row(
              children: [
                _image(theme, images[0]),
                const SizedBox(width: 16),
                _image(theme, images[1]),
              ],
            ),
          _ => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, index) => _image(
                theme,
                images[index],
                width: 200,
              ),
            ),
        };

        return AspectRatio(
          aspectRatio: 16 / 9,
          child: imagesWidget,
        );
      },
    );
  }

  Widget _image(
    ThemeData theme,
    MediaFile mediaFile, {
    double? width,
  }) {
    return SafeImage(
      url: assembleResourceUrl(mediaFile.path),
      width: width,
      placeholderColor: theme.colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
    );
  }
}

class MatchMathProblemTexContainer extends StatelessWidget {
  const MatchMathProblemTexContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MathBattleCubit, MathBattleState>(
      buildWhen: (previous, current) => previous.currentMathProblem != current.currentMathProblem,
      builder: (context, state) {
        if (state.currentMathProblem == null ||
            state.currentMathProblem!.tex == null ||
            state.currentMathProblem!.tex!.isEmpty) {
          return const SizedBox.shrink();
        }

        final tex = state.currentMathProblem!.tex!;

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: Math.tex(
              tex,
              textStyle: const TextStyle(fontSize: 20),
            ).texBreak().parts,
          ),
        );
      },
    );
  }
}

class MatchMathProblemText extends StatelessWidget {
  const MatchMathProblemText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MathBattleCubit, MathBattleState>(
      buildWhen: (previous, current) => previous.currentMathProblem != current.currentMathProblem,
      builder: (_, state) {
        if (state.currentMathProblem?.text == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 8),
          child: Text(
            state.currentMathProblem!.text!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}

class MatchMathProblemAnswers extends StatelessWidget {
  const MatchMathProblemAnswers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MathBattleCubit, MathBattleState>(
      buildWhen: (previous, current) => previous.currentMathProblem != current.currentMathProblem,
      builder: (_, state) {
        if (state.currentMathProblem == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children:
              state.currentMathProblem!.answers.map((answer) => _MathProblemAnswer(tex: answer.tex)).toList(),
        );
      },
    );
  }
}

class _MathProblemAnswer extends StatelessWidget {
  const _MathProblemAnswer({
    required this.tex,
  });

  final String tex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.secondaryContainer,
      ),
      alignment: Alignment.center,
      child: Math.tex(
        tex,
        mathStyle: MathStyle.textCramped,
        textStyle: const TextStyle(fontSize: 20),
      ),
    );
  }
}