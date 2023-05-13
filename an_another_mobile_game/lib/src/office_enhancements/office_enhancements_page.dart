import 'package:an_another_mobile_game/src/helpers/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/game.dart';
import '../domain/office.dart';

class OfficeEnhancementsWidget extends StatefulWidget {
  const OfficeEnhancementsWidget({super.key});

  @override
  OfficeEnhancementsWidgetState createState() =>
      OfficeEnhancementsWidgetState();
}

class OfficeEnhancementsWidgetState extends State<OfficeEnhancementsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: BlocBuilder<OfficeBloc, OfficeState>(builder: (context, state) {
      return ListView.builder(
          itemCount: state.offices.length,
          itemBuilder: (BuildContext context, int index) {
            var office = state.offices[index];

            if (state.officeBought(office.type)) {
              return Container();
            }

            return _getTile(context, office);
          });
    }));
  }

  GestureDetector _getTile(BuildContext context, Office office) {
    return GestureDetector(
      onTap: () =>
          context.read<OfficeBloc>().add(OfficeImprovement(office.type)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(office.title),
          const SizedBox(height: 5),
          Text(office.description),
          const SizedBox(height: 5),
          Text('Cost: ${office.cost.formatCurrency()}'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class OfficeBloc extends Bloc<OfficeEvent, OfficeState> {
  OfficeBloc(Game game) : super(OfficeState(game.offices, game.boughtOffices)) {
    on<OfficeImprovement>((event, emit) {
      game.improveOffice(event.officeType);
      emit(OfficeState(game.offices, game.boughtOffices));
    });
  }
}

class OfficeState {
  OfficeState(this.offices, this.boughtOffices);

  final List<Office> offices;
  final List<OfficeType> boughtOffices;

  bool officeBought(OfficeType type) => boughtOffices.contains(type);
}

abstract class OfficeEvent {}

class OfficeImprovement extends OfficeEvent {
  OfficeImprovement(this.officeType);

  final OfficeType officeType;
}
