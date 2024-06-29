from rest_framework import serializers
from .models import Pet, HealthRecord, GrowthRecord, Vaccination, MealRecord, TrainingRecord, EmergencyContact, ForumPost, Event, Veterinarian, HealthCheckupReminder, PetFoodRecommendation, EmergencyGuide

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
        read_only_fields = ['user', 'created_at', 'updated_at']

    def create(self, validated_data):
        request = self.context.get('request', None)
        if request and hasattr(request, 'user'):
            validated_data['user'] = request.user
        return super().create(validated_data)

class VeterinarianSerializer(serializers.ModelSerializer):
    class Meta:
        model = Veterinarian
        fields = ['id', 'pet', 'name', 'phone_number', 'email']

class HealthCheckupReminderSerializer(serializers.ModelSerializer):
    class Meta:
        model = HealthCheckupReminder
        fields = ['id', 'pet', 'checkup_date', 'reminder']

class MealRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = MealRecord
        fields = '__all__'

class PetFoodRecommendationSerializer(serializers.ModelSerializer):
    class Meta:
        model = PetFoodRecommendation
        fields = '__all__'

class EmergencyGuideSerializer(serializers.ModelSerializer):
    class Meta:
        model = EmergencyGuide
        fields = '__all__'