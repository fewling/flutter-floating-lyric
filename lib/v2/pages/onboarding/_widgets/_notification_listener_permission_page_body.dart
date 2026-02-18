part of '../page.dart';

class _NotificationListenerPermissionPageBody extends StatelessWidget {
  const _NotificationListenerPermissionPageBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.permission_screen_notif_listener_permission_instruction),
        const SizedBox(height: 8),
        Text(l10n.permission_screen_notif_listener_permission_step1),
        Text(l10n.permission_screen_notif_listener_permission_step2),
        Text(l10n.permission_screen_notif_listener_permission_step3),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 150,
            child: Builder(
              builder: (context) {
                final isNotificationListenerGranted = context
                    .select<PermissionBloc, bool>(
                      (bloc) => bloc.state.isNotificationListenerGranted,
                    );

                return ElevatedButton(
                  onPressed: isNotificationListenerGranted
                      ? null
                      : () => context.read<PermissionBloc>().add(
                          const PermissionEvent.requestNotificationListenerPermission(),
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
