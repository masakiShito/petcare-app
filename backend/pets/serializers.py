from rest_framework import serializers
from .models import Pet, HealthRecord, GrowthRecord, Vaccination, MealRecord, TrainingRecord, EmergencyContact, ForumPost, Event

class HealthRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = HealthRecord
        fields = '__all__'

class GrowthRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = GrowthRecord
        fields = '__all__'

class VaccinationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vaccination
        fields = '__all__'

class MealRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = MealRecord
        fields = '__all__'

class TrainingRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = TrainingRecord
        fields = '__all__'

class EmergencyContactSerializer(serializers.ModelSerializer):
    class Meta:
        model = EmergencyContact
        fields = '__all__'

class ForumPostSerializer(serializers.ModelSerializer):
    class Meta:
        model = ForumPost
        fields = '__all__'

class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = Event
        fields = '__all__'

class PetSerializer(serializers.ModelSerializer):
    health_records = HealthRecordSerializer(many=True, read_only=True)
    growth_records = GrowthRecordSerializer(many=True, read_only=True)
    vaccinations = VaccinationSerializer(many=True, read_only=True)
    meal_records = MealRecordSerializer(many=True, read_only=True)
    training_records = TrainingRecordSerializer(many=True, read_only=True)

    class Meta:
        model = Pet
        fields = '__all__'
