from django.db import models
from django.conf import settings
from django.utils.timezone import now

# Create your models here.

class Pet(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    species = models.CharField(max_length=255)
    birthday = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=50, null=True, blank=True)
    photo = models.CharField(max_length=255, null=True, blank=True)
    weight = models.FloatField(null=True, blank=True)
    height = models.FloatField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

class HealthRecord(models.Model):
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE)
    check_date = models.DateField()
    appetite = models.CharField(max_length=255, null=True, blank=True)
    activity_level = models.CharField(max_length=255, null=True, blank=True)
    stool_condition = models.CharField(max_length=255, null=True, blank=True)
    notes = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Vaccination(models.Model):
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE)
    vaccine_name = models.CharField(max_length=255)
    vaccination_date = models.DateField()
    next_due_date = models.DateField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class MealRecord(models.Model):
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE)
    meal_time = models.DateTimeField()
    food_type = models.CharField(max_length=255, null=True, blank=True)
    amount = models.FloatField(null=True, blank=True)
    notes = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class TrainingRecord(models.Model):
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE)
    training_date = models.DateField()
    training_type = models.CharField(max_length=255, null=True, blank=True)
    duration = models.IntegerField(null=True, blank=True)
    progress = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class EmergencyContact(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    contact_name = models.CharField(max_length=255)
    phone_number = models.CharField(max_length=255)
    address = models.CharField(max_length=255, null=True, blank=True)
    notes = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class ForumPost(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Event(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    event_name = models.CharField(max_length=255)
    event_date = models.DateField()
    location = models.CharField(max_length=255, null=True, blank=True)
    description = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class GrowthRecord(models.Model):
    pet = models.ForeignKey(Pet, related_name='growth_records', on_delete=models.CASCADE)
    entry_date = models.DateField()
    note = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Veterinarian(models.Model):
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    phone_number = models.CharField(max_length=20)
    email = models.EmailField()

    def __str__(self):
        return self.name

class HealthCheckupReminder(models.Model):
    pet = models.ForeignKey(Pet, on_delete=models.CASCADE)
    checkup_date = models.DateField()
    reminder = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.pet.name} - Checkup on {self.checkup_date}"
    
class MealRecord(models.Model):
    pet = models.ForeignKey('Pet', on_delete=models.CASCADE)
    date = models.DateField(default=now)
    food_type = models.CharField(max_length=100, default='')
    quantity = models.DecimalField(max_digits=5, decimal_places=2, default=0)

class PetFoodRecommendation(models.Model):
    food_name = models.CharField(max_length=100)
    recommended_for = models.CharField(max_length=100)  # 例: 犬種、年齢など

class EmergencyGuide(models.Model):
    title = models.CharField(max_length=255, verbose_name='タイトル')
    content = models.TextField(verbose_name='内容')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='作成日時')

    class Meta:
        verbose_name = '緊急対応ガイド'
        verbose_name_plural = '緊急対応ガイド'

    def __str__(self):
        return self.title