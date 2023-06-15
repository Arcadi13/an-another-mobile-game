// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../navigation/navigation_bloc.dart';
import '../navigation/navigation_events.dart';
import '../navigation/navigation_states.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settings});
  final SettingsController settings;
  static const _gap = SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
      return Dialog(
          child: state is OpenSettingsState
              ? Column(mainAxisSize: MainAxisSize.min, children: [
                  _gap,
                  ValueListenableBuilder<bool>(
                    valueListenable: settings.soundsOn,
                    builder: (context, soundsOn, child) => _SettingsLine(
                      'Sound FX',
                      Icon(soundsOn ? Icons.graphic_eq : Icons.volume_off),
                      onSelected: () => settings.toggleSoundsOn(),
                    ),
                  ),
                  _gap,
                  ValueListenableBuilder<bool>(
                    valueListenable: settings.musicOn,
                    builder: (context, musicOn, child) => _SettingsLine(
                      'Music',
                      Icon(musicOn ? Icons.music_note : Icons.music_off),
                      onSelected: () => settings.toggleMusicOn(),
                    ),
                  ),
                  _gap,
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                    ),
                    alignment: Alignment.topRight,
                    onPressed: () =>
                        context.read<NavigationBloc>().add(CloseDialogEvent()),
                  ),
                ])
              : null);
    });
  }
}

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                )),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '‘$name’',
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
