from rest_framework import viewsets
from .models import Pet, HealthRecord, GrowthRecord, Vaccination, MealRecord, TrainingRecord, EmergencyContact, ForumPost, Event, PetFoodRecommendation, EmergencyGuide
from .serializers import PetSerializer, HealthRecordSerializer, GrowthRecordSerializer, VaccinationSerializer, MealRecordSerializer, TrainingRecordSerializer, EmergencyContactSerializer, ForumPostSerializer, EventSerializer, PetFoodRecommendationSerializer, EmergencyGuideSerializer
from rest_framework.permissions import IsAuthenticated
import logging

# ロガーの設定
logger = logging.getLogger(__name__)

# ペット情報のCRUD API
class PetViewSet(viewsets.ModelViewSet):
    queryset = Pet.objects.all()
    serializer_class = PetSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # ユーザーが作成したペットのみを取得
        # ユーザー情報はリクエストから取得
        logger.info(f"User {self.request.user.email} requested pet list")  # ペットリスト取得のログ出力
        return self.queryset.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        # ペットの作成時にユーザー情報を付加
        # ユーザー情報はリクエストから取得
        logger.info(f"User {self.request.user.email} created a new pet")  # ペット作成のログ出力
        serializer.save(user=self.request.user)

# 健康記録のCRUD API
class HealthRecordViewSet(viewsets.ModelViewSet):
    queryset = HealthRecord.objects.all()
    serializer_class = HealthRecordSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # ユーザーが作成した健康記録のみを取得
        logger.info(f"User {self.request.user.email} requested health record list")  # 健康記録リス��取得のログ出力
        return self.queryset.filter(pet__user=self.request.user)

class GrowthRecordViewSet(viewsets.ModelViewSet):
    queryset = GrowthRecord.objects.all()
    serializer_class = GrowthRecordSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(pet__user=self.request.user)

class VaccinationViewSet(viewsets.ModelViewSet):
    queryset = Vaccination.objects.all()
    serializer_class = VaccinationSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(pet__user=self.request.user)

class MealRecordViewSet(viewsets.ModelViewSet):
    queryset = MealRecord.objects.all()
    serializer_class = MealRecordSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(pet__user=self.request.user)

class TrainingRecordViewSet(viewsets.ModelViewSet):
    queryset = TrainingRecord.objects.all()
    serializer_class = TrainingRecordSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(pet__user=self.request.user)

class EmergencyContactViewSet(viewsets.ModelViewSet):
    queryset = EmergencyContact.objects.all()
    serializer_class = EmergencyContactSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

class ForumPostViewSet(viewsets.ModelViewSet):
    queryset = ForumPost.objects.all()
    serializer_class = ForumPostSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all()
    serializer_class = EventSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)
    
class MealRecordViewSet(viewsets.ModelViewSet):
    queryset = MealRecord.objects.all()
    serializer_class = MealRecordSerializer

class PetFoodRecommendationViewSet(viewsets.ModelViewSet):
    queryset = PetFoodRecommendation.objects.all()
    serializer_class = PetFoodRecommendationSerializer

class EmergencyGuideViewSet(viewsets.ModelViewSet):
    queryset = EmergencyGuide.objects.all()
    serializer_class = EmergencyGuideSerializer