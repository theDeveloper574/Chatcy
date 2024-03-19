import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;

class ShowEmojiKeyBoard extends StatelessWidget {
  final TextEditingController controller;
  const ShowEmojiKeyBoard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.36,
      child: EmojiPicker(
        textEditingController: controller,
        config: Config(
          height: 256,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            // Issue: https://github.com/flutter/flutter/issues/28894
            emojiSizeMax: 28 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.2
                    : 1.0),
          ),
        ),
      ),
    );
  }
}
