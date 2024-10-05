from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from .models import User
from .serializers import UserSerializer
from rest_framework_simplejwt.tokens import RefreshToken
import logging

# ロガーの設定
logger = logging.getLogger(__name__)


# ユーザー登録API
class UserRegistrationView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        logger.info('User registration attempt')  # 登録試行のログ出力
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            logger.info(f"User {user.email} registered successfully.")  # 登録成功のログ出力
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        # バリデーションエラー時のログ出力
        logger.error(f"User registration failed: {serializer.errors}")
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# ログインAPI (JWTを使用)
class UserLoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email = request.data.get('email')
        password = request.data.get('password')
        logger.info(f"Login attempt for user {email}")  # ログイン試行のログ出力

        user = User.objects.filter(email=email).first()

        if user is not None and user.check_password(password):
            refresh = RefreshToken.for_user(user)
            logger.info(f"User {email} logged in successfully.")  # ログイン成功のログ出力
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            })

        # 認証失敗時のログ出力
        logger.error(f"Login failed for user {email}: Invalid credentials")
        return Response({'error': 'Invalid Credentials'}, status=status.HTTP_400_BAD_REQUEST)
