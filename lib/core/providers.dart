import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'viewmodels/controller_vm.dart';

final controllerProvider = ChangeNotifierProvider((_) => ControllerVM());
