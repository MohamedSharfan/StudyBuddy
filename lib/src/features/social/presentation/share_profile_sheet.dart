import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/public_student.dart';

Future<void> showShareProfileSheet(
  BuildContext context, {
  required PublicStudent student,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Share @${student.username}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Scan the QR or send the StudyBuddy link',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.ink.withValues(alpha: .55),
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(20),
              ),
              child: QrImageView(
                data: student.shareUrl,
                version: QrVersions.auto,
                size: 180,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppColors.royalPurple,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SelectableText(
              student.shareUrl,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.royalPurple,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: student.shareUrl),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied')),
                        );
                      }
                    },
                    icon: const Icon(Icons.link_rounded, size: 18),
                    label: const Text('Copy link'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      SharePlus.instance.share(
                        ShareParams(
                          text:
                              'Connect with me on StudyBuddy: ${student.shareUrl}',
                          subject: '@${student.username} on StudyBuddy',
                        ),
                      );
                    },
                    icon: const Icon(Icons.ios_share_rounded, size: 18),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
