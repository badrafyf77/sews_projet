import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
      //   try {
      //     emit(LoginLoading());

      //     await FirebaseAuth.instance.signInWithEmailAndPassword(
      //       email: event.email,
      //       password: event.password,
      //     );

      //     emit(LoginSuccess());
      //     Future.delayed(
      //       const Duration(seconds: 2),
      //       () {
      //       },
      //     );
      //   } on FirebaseAuthException catch (e) {
      //     if (e.code == 'user-not-found') {
      //       emit(
      //         LoginFAilure(errorMessage: 'No user found for that email.'),
      //       );
      //       Future.delayed(
      //         const Duration(seconds: 2),
      //         () {
      //         },
      //       );
      //     } else if (e.code == 'wrong-password') {
      //       emit(
      //         LoginFAilure(errorMessage: 'Wrong password.'),
      //       );
      //     }
      //     Future.delayed(
      //       const Duration(seconds: 2),
      //       () {
      //       },
      //     );
      //   } catch (e) {
      //     emit(
      //       LoginFAilure(errorMessage: 'ther is an error'),
      //     );
      //     Future.delayed(
      //       const Duration(seconds: 2),
      //       () {
      //       },
      //     );
      //   }
      }
      
    }
    );
  }
}
