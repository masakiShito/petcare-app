from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import PetViewSet, HealthRecordViewSet, GrowthRecordViewSet, VaccinationViewSet, MealRecordViewSet, TrainingRecordViewSet, EmergencyContactViewSet, ForumPostViewSet, EventViewSet

# DefaultRouterのインスタンスを作成
router = DefaultRouter()
# 各ViewSetをrouterに登録
router.register(r'pets', PetViewSet)
router.register(r'health_records', HealthRecordViewSet)
router.register(r'growth_records', GrowthRecordViewSet)
router.register(r'vaccinations', VaccinationViewSet)
router.register(r'meal_records', MealRecordViewSet)
router.register(r'training_records', TrainingRecordViewSet)
router.register(r'emergency_contacts', EmergencyContactViewSet)
router.register(r'forum_posts', ForumPostViewSet)
router.register(r'events', EventViewSet)

# urlpatternsリストを定義し、router.urlsを含める
urlpatterns = [
    path('', include(router.urls)),
]