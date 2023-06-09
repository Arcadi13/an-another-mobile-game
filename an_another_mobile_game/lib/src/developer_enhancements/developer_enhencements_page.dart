import 'package:an_another_mobile_game/src/domain/department.dart';
import 'package:an_another_mobile_game/src/helpers/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/developer.dart';
import '../domain/game.dart';
import '../translations/translations_controller.dart';

class DeveloperEnhancementsWidget extends StatefulWidget {
  const DeveloperEnhancementsWidget({super.key});

  @override
  DeveloperEnhancementsWidgetState createState() =>
      DeveloperEnhancementsWidgetState();
}

class DeveloperEnhancementsWidgetState
    extends State<DeveloperEnhancementsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child:
        BlocBuilder<DeveloperBloc, DeveloperState>(builder: (context, state) {
      return ListView.builder(
          itemCount: state.developers.length,
          itemBuilder: (BuildContext context, int index) {
            var developer = state.developers[index];
            var department = state.getDepartment(developer.type);
            if (department.size == 0) {
              return Container();
            }

            return _getTile(context, developer, department);
          });
    }));
  }

  GestureDetector _getTile(
      BuildContext context, Developer developer, Department department) {
    return GestureDetector(
      onTap: () =>
          context.read<DeveloperBloc>().add(DeveloperHired(developer.type)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(TranslationsController().getTranslation(developer.title)),
          const SizedBox(height: 5),
          Text(TranslationsController()
              .getTranslation(developer.description)
              .format([
            (developer.productivity * department.productivityMultiplier)
                .toString()
          ])),
          const SizedBox(height: 5),
          Text(TranslationsController()
              .getTranslation('costLabel')
              .format([developer.cost.formatCurrency()])),
          const SizedBox(height: 5),
          Text(TranslationsController().getTranslation('developerHiredOf').format(
              [department.hired.toString(), department.size.toString()])),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class DeveloperBloc extends Bloc<DeveloperEvent, DeveloperState> {
  DeveloperBloc(Game game)
      : super(DeveloperState(game.developers, game.company.departments)) {
    on<DeveloperHired>((event, emit) {
      game.hireDeveloper(event.developerType);
      emit(DeveloperState(game.developers, game.company.departments));
    });

    on<UpdateDevelopers>((event, emit) => emit(DeveloperState(game.developers, game.company.departments)));
  }
}

class DeveloperState {
  DeveloperState(this.developers, this.departments);

  final List<Developer> developers;
  final List<Department> departments;

  Department getDepartment(DeveloperType developerType) => departments
      .firstWhere((element) => element.developerType == developerType);
}

abstract class DeveloperEvent {}

class DeveloperHired extends DeveloperEvent {
  DeveloperHired(this.developerType);

  final DeveloperType developerType;
}

class UpdateDevelopers extends DeveloperEvent{}
