from rest_framework import viewsets
from .models import Pet, HealthRecord, GrowthRecord, Vaccination, MealRecord, TrainingRecord, EmergencyContact, ForumPost, Event
from .serializers import PetSerializer, HealthRecordSerializer, GrowthRecordSerializer, VaccinationSerializer, MealRecordSerializer, TrainingRecordSerializer, EmergencyContactSerializer, ForumPostSerializer, EventSerializer
from rest_framework.permissions import IsAuthenticated

class PetViewSet(viewsets.ModelViewSet):
    queryset = Pet.objects.all()
    serializer_class = PetSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class HealthRecordViewSet(viewsets.ModelViewSet):
    queryset = HealthRecord.objects.all()
    serializer_class = HealthRecordSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
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