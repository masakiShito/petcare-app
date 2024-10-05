import logging

# Djangoのロガーを取得
logger = logging.getLogger('django')

def log_message(level, message, user=None, request=None):
    """
    共通のロギング関数。ログレベルに応じてメッセージを出力する。
    追加でユーザーやリクエスト情報を付加することが可能。

    :param level: ログレベル（'debug', 'info', 'warning', 'error', 'critical'）
    :param message: ログメッセージ
    :param user: ユーザー情報 (任意)
    :param request: リクエスト情報 (任意)
    """
    # ユーザー情報やリクエスト情報をメッセージに付与
    extra_info = ""
    if user:
        extra_info += f" | User: {user.username}"
    if request:
        extra_info += f" | Request Path: {request.path}"

    full_message = message + extra_info

    # ログのレベルに応じて出力
    if level == 'debug':
        logger.debug(full_message)
    elif level == 'info':
        logger.info(full_message)
    elif level == 'warning':
        logger.warning(full_message)
    elif level == 'error':
        logger.error(full_message)
    elif level == 'critical':
        logger.critical(full_message)
    else:
        logger.info("Undefined log level: " + full_message)
