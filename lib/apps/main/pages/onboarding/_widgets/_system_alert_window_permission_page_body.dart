part of '../page.dart';

class _SystemAlertWindowPermissionPageBody extends StatelessWidget {
  const _SystemAlertWindowPermissionPageBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.permission_screen_overlay_window_permission_instruction),
        const SizedBox(height: 8),
        Text(l10n.permission_screen_overlay_window_permission_step1),
        Text(l10n.permission_screen_overlay_window_permission_step2),
        Text(l10n.permission_screen_overlay_window_permission_step3),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 150,
            child: Builder(
              builder: (context) {
                final isSystemAlertWindowGranted = context
                    .select<PermissionBloc, bool>(
                      (bloc) => bloc.state.isSystemAlertWindowGranted,
                    );

                return ElevatedButton(
                  onPressed: isSystemAlertWindowGranted
                      ? null
                      : () => context.read<PermissionBloc>().add(
                          const PermissionEvent.requestSystemAlertWindowPermission(),
                        ),
                  child: Text(l10n.permission_screen_grant_access),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
