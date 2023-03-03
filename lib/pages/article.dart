import 'dart:ui';

import '../imports.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage(
    this.article, {
    super.key,
  });
  final Article article;

  @override
  Widget build(BuildContext context) {
    FocusNode commentFocusNode = FocusNode();
    TextEditingController commentCtrl = TextEditingController();
    return Obx(() {
      List<Comment> commentsList = zeroNetController.commentsList;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Text(
            article.title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          // const SizedBox(width: 36),
          MarkdownBody(
            imageBuilder: (uri, title, alt) {
              if (uri.path.startsWith('data/')) {
                return Image(
                  image: NetworkImage(
                      "http://127.0.0.1:43110/1SCribeHs1nz8m3vXipP84oyXUy4nf2ZD/$uri"),
                );
              } else {
                return const SizedBox();
              }
            },
            onTapLink: (str1, str2, str3) {
              debugPrint(str1);
              debugPrint(str2); //TODO!: add go router, to handle str2
              // TODO!: replace current article with this article
              debugPrint(str3);
            },
            data: article.body,
            shrinkWrap: true,
            styleSheet: themeController.getMarkdownStyleSheet(),
            styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
          ).paddingSymmetric(vertical: 20),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: zeroNetController
                                        .siteInfo.value!.certUserId ??
                                    'UnknowUser',
                              ),
                              const TextSpan(text: '--New comment')
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                        child: AbsorbPointer(
                          absorbing:
                              zeroNetController.siteInfo.value!.certUserId ==
                                  null,
                          child: TextFormField(
                            controller: commentCtrl,
                            focusNode: commentFocusNode,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 15,
                            validator: (value) {
                              if (value != null) {
                                if (value.isNotEmpty) {
                                  return null;
                                }
                              }
                              return "Enter comment";
                            },
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AbsorbPointer(
                        absorbing:
                            zeroNetController.siteInfo.value!.certUserId ==
                                null,
                        child: ElevatedButton(
                          onPressed: () {
                            if (zeroNetController.siteInfo.value!.certUserId !=
                                null) {
                              zeroNetController.addComment(
                                Comment(
                                  body: commentCtrl.text,
                                  dateAdded:
                                      DateTime.now().millisecondsSinceEpoch ~/
                                          1000,
                                  commentId:
                                      menuController.currentArticle.value!.id,
                                  commentVotes: 0,
                                  directory: '',
                                  jsonId: 0,
                                  userId: zeroNetController
                                          .siteInfo.value!.certUserId ??
                                      "",
                                ),
                              );
                              commentCtrl.clear();
                            }
                          },
                          style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.amber)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 8),
                            child: Text(
                              "Submit Comment",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  zeroNetController.siteInfo.value!.certUserId == null
                      ? Positioned(
                          bottom: 0,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: const SizedBox(
                              width: double.maxFinite,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  zeroNetController.siteInfo.value!.certUserId == null
                      ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: ElevatedButton(
                              onPressed: () {
                                showZeroNetxDialog(context, () {});
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("Sign In"),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              );
            },
          ),

          const SizedBox(
            height: 20,
          ),

          for (var obj in commentsList)
            CommentItem(
              obj: obj,
              commentCtrl: commentCtrl,
              commentFocusNode: commentFocusNode,
            )
        ],
      );
    });
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.obj,
    required this.commentCtrl,
    required this.commentFocusNode,
  });

  final Comment obj;
  final TextEditingController commentCtrl;
  final FocusNode commentFocusNode;

  @override
  Widget build(BuildContext context) {
    GlobalObjectKey<CommentReplyButtonState> replyButtonKey =
        GlobalObjectKey(obj);

    return InkWell(
      onTap: () {},
      onHover: (isHovered) {
        replyButtonKey.currentState!.changeVisibility(isHovered);
      },
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.black12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: obj.userId,
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' --on ${DateFormat('MMM d, y').format(DateTime.fromMillisecondsSinceEpoch(obj.dateAdded * 1000))}',
                        )
                      ],
                    ),
                  ),
                ),
                CommentReplyButton(
                  key: replyButtonKey,
                  callBack: () {
                    commentCtrl.clear();
                    commentCtrl.text = "> ${[
                      obj.userId
                    ]}(#comment_${obj.commentId}_${obj.directory.split('/').last}):${obj.body}\n";
                    commentFocusNode.requestFocus();
                  },
                ),
              ],
            ),
            MarkdownBody(
                    imageBuilder: (uri, title, alt) {
                      return Container(
                        height: 10,
                        width: 200,
                        color: Colors.amber,
                      );
                    },
                    data: obj.body,
                    shrinkWrap: true,
                    styleSheet: themeController.getMarkdownStyleSheet())
                .paddingSymmetric(vertical: 20),
          ],
        ),
      ),
    );
  }
}

class CommentReplyButton extends StatefulWidget {
  final VoidCallback callBack;
  const CommentReplyButton({required this.callBack, super.key});

  @override
  State<CommentReplyButton> createState() => CommentReplyButtonState();
}

class CommentReplyButtonState extends State<CommentReplyButton> {
  bool isHovering = false;
  void changeVisibility(bool onHover) {
    if (mounted) {}
    setState(() {
      isHovering = onHover;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.callBack,
      child: Visibility(
        visible:
            isHovering && zeroNetController.siteInfo.value!.certUserId != null,
        child: Row(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.reply),
            ),
            Text("Reply")
          ],
        ),
      ),
    );
  }
}
