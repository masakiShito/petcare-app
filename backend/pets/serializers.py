from rest_framework import serializers
from .models import Pet, HealthRecord, GrowthRecord, Vaccination, MealRecord, TrainingRecord, EmergencyContact, ForumPost, Event, Veterinarian, HealthCheckupReminder, PetFoodRecommendation, EmergencyGuide

class HealthRecordSerializer(serializers.ModelSerializer):
    """
    Serializer for the HealthRecord model.
    """
    class Meta:
        model = HealthRecord
        fields = '__all__'

class GrowthRecordSerializer(serializers.ModelSerializer):
    """
    Serializer for the GrowthRecord model.
    """
    class Meta:
        model = GrowthRecord
        fields = '__all__'

class VaccinationSerializer(serializers.ModelSerializer):
    """
    Serializer for the Vaccination model.
    """
    class Meta:
        model = Vaccination
        fields = '__all__'

class MealRecordSerializer(serializers.ModelSerializer):
    """
    Serializer for the MealRecord model.
    """
    class Meta:
        model = MealRecord
        fields = '__all__'

class TrainingRecordSerializer(serializers.ModelSerializer):
    """
    Serializer for the TrainingRecord model.
    """
    class Meta:
        model = TrainingRecord
        fields = '__all__'

class EmergencyContactSerializer(serializers.ModelSerializer):
    """
    Serializer for the EmergencyContact model.
    """
    class Meta:
        model = EmergencyContact
        fields = '__all__'

class ForumPostSerializer(serializers.ModelSerializer):
    """
    Serializer for the ForumPost model.
    """
    class Meta:
        model = ForumPost
        fields = '__all__'

class EventSerializer(serializers.ModelSerializer):
    """
    Serializer for the Event model.
    """
    class Meta:
        model = Event
        fields = '__all__'

class PetSerializer(serializers.ModelSerializer):
    """
    Serializer for the Pet model.
    """
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
        """
        Create a new Pet instance.

        Args:
            validated_data (dict): The validated data for creating a new Pet.

        Returns:
            Pet: The newly created Pet instance.
        """
        request = self.context.get('request', None)
        if request and hasattr(request, 'user'):
            validated_data['user'] = request.user
        return super().create(validated_data)

class VeterinarianSerializer(serializers.ModelSerializer):
    """
    Serializer for the Veterinarian model.
    """
    class Meta:
        model = Veterinarian
        fields = ['id', 'pet', 'name', 'phone_number', 'email']

class HealthCheckupReminderSerializer(serializers.ModelSerializer):
    """
    Serializer for the HealthCheckupReminder model.
    """
    class Meta:
        model = HealthCheckupReminder
        fields = ['id', 'pet', 'checkup_date', 'reminder']

class MealRecordSerializer(serializers.ModelSerializer):
    """
    Serializer for the MealRecord model.
    """
    class Meta:
        model = MealRecord
        fields = '__all__'

class PetFoodRecommendationSerializer(serializers.ModelSerializer):
    """
    Serializer for the PetFoodRecommendation model.
    """
    class Meta:
        model = PetFoodRecommendation
        fields = '__all__'

class EmergencyGuideSerializer(serializers.ModelSerializer):
    """
    Serializer for the EmergencyGuide model.
    """
    class Meta:
        model = EmergencyGuide
        fields = '__all__'